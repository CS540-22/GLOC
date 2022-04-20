#!/bin/bash
source ./gloc_ui/.env
docker build --build-arg api_url=$API_URL -f ./cluster/docker/gloc_ui/Dockerfile -t bgreenb11/gloc-ui:arm . 
docker push bgreenb11/gloc-ui:arm