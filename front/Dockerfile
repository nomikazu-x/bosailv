# create nuxt-appコマンド成功確認済みのnode version
FROM node:16.14.2-alpine3.15

ENV HOME=/usr/src/app \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    # 以下を指定しないとブラウザからhttp://localhost へアクセスすることができない
    HOST=0.0.0.0

# 作業ディレクトリに移動
WORKDIR ${HOME}

COPY ./ ./
RUN apk add --update python3 make g++
RUN yarn install

CMD ["yarn", "run", "dev"]
