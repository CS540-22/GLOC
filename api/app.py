from flask import Flask, request, jsonify
from flask_executor import Executor
from git import Repo
from wtforms import Form, StringField, IntegerField, validators
import json
import shlex
import shutil
import subprocess


app = Flask(__name__)
executor = Executor(app)


class ResultsGetForm(Form):
    job_hash = StringField('job_hash', [validators.InputRequired()])


class DataForm(Form):
    url = StringField('url', [validators.InputRequired()])
    limit = IntegerField('limit', default=1)
    step = IntegerField('step', default=1)
    branch = StringField('branch')
    commit = StringField('commit')


"""
    Method to clone the provided repo and start the executor to run the cloc job before returning the STARTED status and the hash of the current job 
"""


def start_runner(form, runner_type):
    url, job_hash = form.url.data, hash(form)
    clone(url, job_hash, runner_type=runner_type)

    if runner_type == "single":
        executor.submit_stored(
            f'cloc_results_{job_hash}', execute_cloc, job_hash, runner_type
        )
    elif runner_type == "history":
        executor.submit_stored(
            f'cloc_results_{job_hash}', execute_cloc, job_hash, runner_type, limit=form.limit.data, step=form.step.data
        )
    return jsonify({'status': 'STARTED', 'hash': job_hash})


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
    Should only be run by Executor to prevent Flask from hanging
"""


def execute_cloc(job_hash, runner_type, **kwargs):
    path = f"/tmp/cloc-api-{job_hash}"

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

        for commit in reversed(commits):
            repo.git.checkout(commit)
            result = subprocess.run(
                args=["cloc", "-json", shlex.quote(path)], capture_output=True, text=True, shell=False
            ).stdout
            result = json.loads(result)
            result['header']['commit_hash'] = commit.hexsha
            result['header']['date'] = commit.committed_date
            history.append(result)

    # Delete directory
    shutil.rmtree(path)

    return history


"""
    Returns the status of the cloc job if execute_cloc is not yet finished
    Otherwise it returns the results of the cloc job based on the provided hash
"""


def get_results(job_hash):
    if not executor.futures.done(f'cloc_results_{job_hash}'):
        return jsonify({'status': executor.futures._state(f'cloc_results_{job_hash}')})

    future = executor.futures.pop(f'cloc_results_{job_hash}')
    return jsonify({
        'status': 'FINISHED',
        'results': future.result(),
    })


"""
    Route for querying cloc on the stats of the current state of a git repo
"""


@ app.route('/single', methods=["GET", "POST"])
def single():

    if request.method == "POST" and (form := DataForm(request.form)).validate():
        return start_runner(form=form, runner_type='single')
    elif request.method == "GET" and (form := ResultsGetForm(request.form)).validate():
        return get_results(form.job_hash.data)

    return "Bad Request\n", 400


"""
    Route for querying cloc based on a specified history of the git repo at many points
"""


@ app.route('/history', methods=["GET", "POST"])
def history():
    if request.method == "POST" and (form := DataForm(request.form)).validate():
        return start_runner(form=form, runner_type='history')
    elif request.method == "GET" and (form := ResultsGetForm(request.form)).validate():
        return get_results(form.job_hash.data)

    return "Bad Request\n", 400


if __name__ == '__main__':
    app.run(host='127.0.0.1')
