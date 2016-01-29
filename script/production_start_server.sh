#!/bin/bash

set -x

thin -p 3260 -e production stop
thin -d -p 3260 -e production --tag "Domelab Production" start
