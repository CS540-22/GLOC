#!/bin/sh

exec python app/worker.py &
exec gunicorn --config app/gunicorn_conf.py app.wsgi:app