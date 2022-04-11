import os

bind = f"{os.environ.get('FLASK_HOST')}:5000"
loglevel = "info"
errorlog = "-"
accesslog = "-"
worker_tmp_dir = "/dev/shm"
graceful_timeout = 120
timeout = 120
keepalive = 5
threads = 4
workers = 4
