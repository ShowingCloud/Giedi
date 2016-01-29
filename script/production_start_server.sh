#!/bin/bash

set -x

thin -p 3250 -e production stop
thin -d -p 3250 -e production --tag "Domelab Production" start
