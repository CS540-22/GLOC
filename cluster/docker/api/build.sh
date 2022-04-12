#!/bin/bash
source ./api/.env
docker build --build-arg secret_key=$SECRET_KEY --build-arg redis_auth=$REDIS_AUTH --build-arg redis_host=$REDIS_HOST --build-arg flask_host=$FLASK_HOST -f ./cluster/docker/api/Dockerfile -t bgreenb11/flask-cloc-api:redis . --platform=aarch64
docker push bgreenb11/flask-cloc-api:redis