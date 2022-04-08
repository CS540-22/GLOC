from .app import app
import os

app.config.from_envvar(os.environ.get("SECRET_KEY"))
