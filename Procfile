web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -c ${RAILS_MAX_THREADS:5} -q default -q mailers
release: rails db:migrate
