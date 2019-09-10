# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cache_store, namespace: 'cache', expire_after: 10.minutes.to_i
