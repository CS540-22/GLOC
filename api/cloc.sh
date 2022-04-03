#!/bin/sh

exec gunicorn --config app/gunicorn_conf.py app.wsgi:app