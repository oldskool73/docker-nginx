#!/bin/sh

docker build -t oldskool73/nginx:1.11 -f Dockerfile .
docker push oldskool73/nginx
