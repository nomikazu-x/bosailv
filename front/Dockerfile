# create nuxt-appコマンド成功確認済みのnode version
FROM node:16.13.1-alpine

# Dockerfile内で使用する変数名を指定
ARG WORKDIR
ARG CONTAINER_PORT
ARG API_URL

ENV HOME=/${WORKDIR} \
    # 以下でアプリケーションの中で使用する言語を明示
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    # 以下を指定しないとブラウザからhttp://localhost へアクセスすることができない
    HOST=0.0.0.0 \
    API_URL=${API_URL}

# 作業ディレクトリに移動
WORKDIR ${HOME}

# コンテナ公開用のポート番号を指定
EXPOSE ${CONTAINER_PORT}
