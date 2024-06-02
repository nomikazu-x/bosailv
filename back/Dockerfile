FROM amd64/ruby:3.0.0

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y build-essential default-mysql-client vim openssl ca-certificates libxml2-dev libxslt1-dev ruby clang make binutils

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . /app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
