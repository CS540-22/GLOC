from flask import Flask, request
from flask_executor import Executor
from flask_shell2http import Shell2HTTP

import functools

app = Flask(__name__)

executor = Executor(app)
shell2http = Shell2HTTP(app=app, executor=executor, base_url_prefix="/")


def callback(context, future):
    print(context, future.result().get("report", "NONE"))


def url_verification(f):
    @functools.wraps(f)
    def decorator(*args, **kwargs):
        print(request.args.get("url", ""))
        return f(*args, **kwargs)
    return decorator


shell2http.register_command(
    endpoint="ls", command_name="ls", callback_fn=callback, decorators=[url_verification])


if __name__ == "__main__":
    app.run(host="0.0.0.0")
