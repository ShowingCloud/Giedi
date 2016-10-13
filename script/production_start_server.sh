#!/bin/bash

set -x

sidekiqctl stop tmp/pids/sidekiq.pid 60
thin -p 3290 -e production stop
thin -d -p 3290 -e production --tag "SSO V1" start
sidekiq -C config/sidekiq.yml -d -e production --tag "SSO V1"
