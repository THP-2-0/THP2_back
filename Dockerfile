FROM ruby:2.5.1

RUN apt-get update && apt-get install -y \
      postgresql-client \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

# First copy only the gemfile so we don't have to bundle install each time a random file change :)
COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock
COPY ./.ruby-version /app/.ruby-version
RUN bundle install

COPY ./config /app/config
COPY ./config.ru /app/config.ru
COPY ./lib /app/lib
COPY ./db /app/db
# Lol.
COPY ./app /app/app 
COPY ./Rakefile /app/Rakefile
COPY ./Procfile /app/Procfile
COPY ./Guardfile /app/Guardfile
COPY ./bin /app/bin
COPY ./public /app/public
COPY ./spec /app/spec

COPY ./.rspec /app/.rspec
COPY ./.rubocop.yml /app/.rubocop.yml

COPY ./files_docker/entrypoint.sh /start.sh
COPY ./files_docker/wait_for_postgres.sh /wait_for_postgres.sh
RUN chmod +x /wait_for_postgres.sh && chmod +x /start.sh

ENTRYPOINT [ "/start.sh" ]
CMD rails s
