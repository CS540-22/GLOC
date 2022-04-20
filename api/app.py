from flask import Flask, request, jsonify
from flask_cors import CORS
from git import Repo
from rq import Queue, get_current_job
from rq.job import Job, NoSuchJobError
from wtforms import Form, StringField, IntegerField, validators
import redis
import json
import os
import shlex
import shutil
import subprocess


app = Flask(__name__)
cors = CORS(app, resources={
            r"/*": {"origins": "https://gloc.homelab.benlg.dev"}})
conn = redis.Redis(host=os.environ.get("REDIS_HOST"), port=6379, db=0,
                   password=os.environ.get("REDIS_AUTH"))
q = Queue(connection=conn)


class ResultsGetForm(Form):
    job_hash = StringField('job_hash', [validators.InputRequired()])


class DataForm(Form):
    url = StringField('url', [validators.InputRequired()])
    limit = IntegerField('limit', default=1)
    step = IntegerField('step', default=1)
    branch = StringField('branch')
    commit = StringField('commit')


"""
    Method to clone the provided repo and start the RQ Worker to run the cloc job before returning the 'started' status and the hash of the current job
"""


def start_runner(form, runner_type):
    url, job_hash = form.url.data, hash(form)

    if runner_type == "single":
        job = q.enqueue_call(
            func="app.execute_cloc",
            args=(url, job_hash, runner_type,),
        )
    elif runner_type == "history":

        job = q.enqueue_call(
            func="app.execute_cloc",
            args=(url, job_hash, runner_type,),
            kwargs={'limit': form.limit.data, 'step': form.step.data},
        )

    print(job.get_id())
    return jsonify({'status': 'started', 'hash': job.get_id()})


"""
    Clones the repo to a tmp folder based on the hash of the form input
"""


def clone(url, job_hash, **kwargs):
    path = f"/tmp/cloc-api-{job_hash}"
    runner_type = kwargs.get("runner_type")
    if runner_type == "single":
        Repo.clone_from(url, path, depth=1)
    elif runner_type == "history":
        Repo.clone_from(url, path)


"""
    Executes the cloc command based on the provided input
    Should only be run by an RQ Worker to prevent Flask from hanging
"""


def execute_cloc(url, job_hash, runner_type, **kwargs):
    path = f"/tmp/cloc-api-{job_hash}"
    job = get_current_job()

    clone(url, job_hash, runner_type=runner_type)
    job.set_status("cloning")

    # Run Cloc
    history = []
    if runner_type == "single":
        result = subprocess.run(
            args=["cloc", "-json", shlex.quote(path)], capture_output=True, text=True, shell=False
        ).stdout
        result = json.loads(result)
        history.append(result)

    elif runner_type == "history":
        history = []
        repo = Repo(path)
        step = kwargs.get("step", 1)
        limit = kwargs.get("limit", 1)
        commits = list(repo.iter_commits(
            repo.head, max_count=limit, first_parent=True))[::step]

        for index, commit in enumerate(reversed(commits)):
            repo.git.checkout(commit)
            result = subprocess.run(
                args=["cloc", "-json", shlex.quote(path)], capture_output=True, text=True, shell=False
            ).stdout
            result = json.loads(result)
            result['header']['commit_hash'] = commit.hexsha
            result['header']['date'] = commit.committed_date
            history.append(result)
            job.set_status(f"{index+1}/{limit}")

    # Delete directory
    shutil.rmtree(path)

    return history


"""
    Returns the status of the cloc job if execute_cloc is not yet finished
    Otherwise it returns the results of the cloc job based on the provided hash
"""


def get_results(job_hash):
    try:
        job = Job.fetch(str(job_hash), connection=conn)
    except NoSuchJobError:
        return f"Job-{job_hash} Not Found", 500

    if job.is_finished:
        return jsonify({
            'status': 'finished',
            'results': job.result,
        }), 200

    return jsonify({'status': job.get_status()}), 200


"""
    Route for querying cloc on the stats of the current state of a git repo
"""


@ app.route('/single', methods=["POST"])
def single():

    if request.method == "POST":
        if (form := DataForm(request.form)).validate():
            return start_runner(form=form, runner_type='single')
        elif (form := ResultsGetForm(request.form)).validate():
            return get_results(form.job_hash.data)

    return "Bad Request\n", 400


"""
    Route for querying cloc based on a specified history of the git repo at many points
"""


@ app.route('/history', methods=["POST"])
def history():
    if request.method == "POST":
        if (form := DataForm(request.form)).validate():
            return start_runner(form=form, runner_type='history')
        elif (form := ResultsGetForm(request.form)).validate():
            return get_results(form.job_hash.data)

    return "Bad Request\n", 400


if __name__ == '__main__':
    app.run(host=os.environ.get("FLASK_HOST"))
