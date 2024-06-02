FROM ruby:3.0.0-alpine

# 必要なパッケージをダウンロード
ENV RUNTIME_PACKAGES="linux-headers libxml2-dev make gcc libc-dev nodejs tzdata mysql-dev mysql-client git yarn imagemagick gcompat" \
    DEV_PACKAGES="build-base curl-dev" \
    HOME=/app \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

# 作業ディレクトリに移動
WORKDIR ${HOME}

# ホスト(自分のパソコン上にあるファイル)から必要ファイルをDocker上にコピー
COPY Gemfile* ./

# apkはAlpine Linuxのコマンド
RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install -j4 && \
    apk del build-dependencies && \
    rm -rf /usr/local/bundle/cache/* \
    /usr/local/share/.cache/* \
    /var/cache/* \
    /tmp/* \
    /usr/lib/mysqld* \
    /usr/bin/mysql*

# ローカルにある全てのファイルをイメージにコピー
COPY . .
