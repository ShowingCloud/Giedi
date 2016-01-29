#!/bin/bash

set -x

thin stop
thin -d -p 3150 --tag "Domelab Testing" start
