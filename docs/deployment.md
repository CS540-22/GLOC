# Deployment

Our project has a front-end and back-end that must communicate with each other. They communicate through http requests that deliver json for parameters and data. If both are not deployed properly, only limited functionality will be available.

## Front-end deployment options

### With repo clone
- Clone the repo and run the flutter app with `flutter run -d chrome`

### With docker image
- Pull and run the docker image `bgreenb3/gloc-ui:latest`

## Back-end deployment (WIP)

### Run the API 
1) Clone the repo
2) Go to the api directory
3) Replace the REDIS_HOST env var with your own redis instance
4) Provide your own redis password or remove the variable from the api's redis connection if not using a password
5) Provide the FLASK_HOST env var to tell flask which host ip to run on
6) Provide your own SECRET_KEY for flask
7) Run the flask app with the `cloc.sh` script

### (Optional) Deploy a Redis server in a k8s cluster 
1) Clone the repo and go to cluster/k8s/redis/
2) Replace the masterauth/requirepass in `redis-config.yaml` with your own redis password if desired
3) Run and apply all .yaml files in cluster/k8s/redis with `kubectl -f apply <each file here>`

