#!/bin/zsh

source ./.env

# aws login
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $ECR_REPOSITORY_URL

# nginxのイメージプッシュ
GIT_COMMIT_ID=$(git log --format="%H" -n 1)
REPOSITORY_NAME=bosailv-backend-nginx
docker build -t $REPOSITORY_NAME:$GIT_COMMIT_ID -f ./infra/web/Dockerfile.prod .
docker tag $REPOSITORY_NAME:$GIT_COMMIT_ID $ECR_REPOSITORY_URL/$REPOSITORY_NAME:$GIT_COMMIT_ID
docker push $ECR_REPOSITORY_URL/$REPOSITORY_NAME:$GIT_COMMIT_ID
