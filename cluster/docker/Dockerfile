FROM python:3.9-slim

RUN apt update && apt upgrade -y && apt install -y git cloc

RUN mkdir /app

COPY api/requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /tmp/requirements.txt

COPY api/ /app

EXPOSE 5000

RUN chmod +x ./app/cloc.sh

ARG secret_key

ENV SECRET_KEY=$secret_key

CMD ["sh", "./app/cloc.sh"]