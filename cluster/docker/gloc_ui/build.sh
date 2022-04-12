#!/bin/bash

docker build -f ./cluster/docker/gloc_ui/Dockerfile -t bgreenb11/gloc-ui:arm . 
docker push bgreenb11/gloc-ui:arm