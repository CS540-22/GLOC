#!/bin/bash

docker build -f ./cluster/docker/gloc_ui/Dockerfile -t bgreenb11/gloc-ui:latest . 
docker push bgreenb11/gloc-ui:latest