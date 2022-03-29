# create nuxt-appコマンド成功確認済みのnode version
FROM node:16.13.1-alpine

ENV HOME=/app \
    # 以下でアプリケーションの中で使用する言語を明示
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    # 以下を指定しないとブラウザからhttp://localhost へアクセスすることができない
    HOST=0.0.0.0 \
    API_URL=${API_URL}

# 作業ディレクトリに移動
WORKDIR ${HOME}

# コンテナ公開用のポート番号を指定
EXPOSE 3000
