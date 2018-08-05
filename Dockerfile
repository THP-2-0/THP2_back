FROM ruby:2.5.1-alpine

RUN mkdir /app
WORKDIR /app

# First copy only the gemfile so we don't have to bundle install each time a random file change :)
COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock
COPY ./.ruby-version /app/.ruby-version

RUN apk add --no-cache git tzdata postgresql-dev openssh-client g++ make bash && \
  bundle install --without development test --deployment --jobs 20 --retry 5 && \
  apk del --no-cache git openssh-client g++ make

COPY ./config /app/config
COPY ./config.ru /app/config.ru
COPY ./lib /app/lib
COPY ./db /app/db
# Lol.
COPY ./app /app/app 
COPY ./Rakefile /app/Rakefile
COPY ./bin /app/bin
COPY ./public /app/public

COPY ./files_docker/entrypoint.sh /start.sh
RUN echo "echo \"PROD DOESN'T WAIT!\"" >> /wait_for_postgres.sh
RUN chmod +x /wait_for_postgres.sh && chmod +x /start.sh

ENV RAILS_ENV production
ENV RAKE_ENV production

EXPOSE 3000
ENTRYPOINT [ "/start.sh" ]
CMD bundle exec rails s -b 0.0.0.0
