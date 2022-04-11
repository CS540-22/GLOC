import os
import redis
from rq import Worker, Queue, Connection

listen = ['default']
redis_host = os.environ.get("REDIS_HOST")

conn = redis.Redis(host=redis_host, port=6379, db=0,
                   password=os.environ.get("REDIS_AUTH"))

if __name__ == '__main__':
    with Connection(conn):
        worker = Worker(list(map(Queue, listen)))
        worker.work()
