#!/bin/bash

set -x

thin -p 3280 -e production stop
thin -d -p 3280 -e production --tag "Domelab Intro Production" start
