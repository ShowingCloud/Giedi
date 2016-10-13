#!/bin/bash

set -x

sidekiqctl stop tmp/pids/sidekiq.pid 60
thin stop
thin -d -p 3180 --tag "SSO V1 Staging" start
sidekiq -C config/sidekiq.yml -d --tag "SSO V1 Staging"
