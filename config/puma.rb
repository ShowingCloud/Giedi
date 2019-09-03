threads 0,16
workers 1
preload_app!

environment 'production'
daemonize
pidfile '/var/www/rails/dome/sso/v1/tmp/pids/puma.pid'
state_path '/var/www/rails/dome/sso/v1/tmp/pids/puma.state'
stdout_redirect '/var/www/rails/dome/sso/v1/log/stdout', '/var/www/rails/dome/sso/v1/log/stderr', true

bind 'tcp://0.0.0.0:3290'
tag 'SSO v1'
