from .app import app
import os

app.config["SECRET_KEY"] = os.environ.get("SECRET_KEY")
