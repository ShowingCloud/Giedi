#!/bin/bash

set -x

thin stop
thin -d -p 3160 --tag "Domelab Testing" start
