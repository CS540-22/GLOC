# Deployment

Our project has a front-end and back-end that must communicate with each other. They communicate through http requests that deliver json for parameters and data. If both are not deployed properly, only limited functionality will be available.

For the immediate future, we would like to host our flutter front end on the cluster as well as the api. Once we make sure it is secure, we can expose it to the public internet. If someone didn't want to use our tool or wanted to run it themselves, below are some deployment options for the front-end and back-end.

## Front-end deployment options

### With repo clone
- Clone the repo and run the flutter app with `flutter run -d chrome`

### With docker image
- Pull and run the docker image `bgreenb3/gloc-ui:latest`

## Back-end deployment (WIP)

### Run the API 
1) Clone the repo
2) Go to the api directory
3) Supply values for the environment variables REDIS_HOST, REDIS_AUTH, FLASK_HOST, and SECRET_KEY
4) REDIS_HOST=Your redis instance
5) REDIS_AUTH=Your redis masterauth/requirepass password
6) FLASK_HOST=Ip address to run your Flask app on
7) SECRET_KEY=Your Flask app's secret key
8) Install the dependencies with `pip install -r requirements.txt` or `pipenv install`
9) Run the Flask app with the `cloc.sh` script

### (Optional) Deploy a Redis server in a k8s cluster 
1) Clone the repo and go to cluster/k8s/redis/
2) Replace the masterauth/requirepass in `redis-config.yaml` with your own redis password if desired
3) Run and apply all .yaml files in cluster/k8s/redis with `kubectl -f apply <each file here>`

