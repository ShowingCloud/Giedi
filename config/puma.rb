threads 0,16
workers 1
preload_app!

environment 'production'
daemonize
pidfile '/var/www/rails/dome/intro/production/tmp/pids/puma.pid'
state_path '/var/www/rails/dome/intro/production/tmp/pids/puma.state'
stdout_redirect '/var/www/rails/dome/intro/production/log/stdout', '/var/www/rails/dome/intro/production/log/stderr', true

bind 'tcp://0.0.0.0:3280'
tag 'Domelab Intro Production'
