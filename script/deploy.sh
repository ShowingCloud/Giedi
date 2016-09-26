#!/bin/bash
openssl aes-256-cbc -k $DEPLOY_KEY -in config/deploy_id_rsa_enc_travis -d -a -out config/deploy_id_rsa
bundle exec mina deploy -v
