#!/bin/zsh

source ./.env

# aws login
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $ECR_REPOSITORY_URL

# nginxのイメージプッシュ
REPOSITORY_NAME=bosailv-backend-nginx
docker build -t $REPOSITORY_NAME:latest -f ./infra/web/Dockerfile .
docker tag $REPOSITORY_NAME:latest $ECR_REPOSITORY_URL/$REPOSITORY_NAME:latest
docker push $ECR_REPOSITORY_URL/$REPOSITORY_NAME:latest
