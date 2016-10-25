#!/bin/bash

set -x

sidekiqctl stop tmp/pids/sidekiq.pid 60
thin -p 3260 -e production stop
thin -d -p 3260 -e production --tag "Domelab Production" start
sidekiq -C config/sidekiq.yml -d -e production --tag "Domelab Production"
