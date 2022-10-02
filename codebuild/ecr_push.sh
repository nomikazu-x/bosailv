#!/bin/zsh

source ./.env

# aws login
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $ECR_REPOSITORY_URL

# codebuildのイメージプッシュ
REPOSITORY_NAME=bosailv-codebuild
docker build -t $REPOSITORY_NAME:latest -f Dockerfile
docker tag $REPOSITORY_NAME:latest $ECR_REPOSITORY_URL/$REPOSITORY_NAME:latest
docker push $ECR_REPOSITORY_URL/$REPOSITORY_NAME:latest
