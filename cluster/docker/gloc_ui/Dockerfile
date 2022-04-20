# Based on https://github.com/edwardinubuntu/flutter-web-dockerfile/blob/master/Dockerfile
FROM debian:latest AS build-env

RUN apt update 
RUN apt install -y curl wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 git
RUN apt clean

RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v

RUN flutter upgrade
RUN flutter config --enable-web

RUN mkdir /app/
COPY ./gloc_ui /app/
WORKDIR /app/

ARG api_url

RUN flutter build web --dart-define=API_URL=$api_url  

# Build the runtime image
FROM --platform=aarch64 nginx:stable-alpine
# FROM nginx:stable-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html