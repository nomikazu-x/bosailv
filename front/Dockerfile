# create nuxt-appコマンド成功確認済みのnode version
FROM node:16.14.2

ENV TZ Asia/Tokyo

WORKDIR /app

COPY package.json yarn.lock /app/
RUN yarn install

COPY . /app

CMD ["yarn", "dev", "-p", "4000"]
