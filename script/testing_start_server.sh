#!/bin/bash

set -x

thin stop
thin -d -p 3170 --tag "Domelab Intro Testing" start
