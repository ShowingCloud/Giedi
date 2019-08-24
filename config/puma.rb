threads 0,16
workers 3
preload_app!

environment 'production'
daemonize
pidfile '/var/www/rails/dome/domelab/production/tmp/pids/puma.pid'
state_path '/var/www/rails/dome/domelab/production/tmp/pids/puma.state'
stdout_redirect '/var/www/rails/dome/domelab/production/log/stdout', '/var/www/rails/dome/domelab/production/log/stderr', true

bind 'tcp://0.0.0.0:3260'
tag 'Domelab Production'
