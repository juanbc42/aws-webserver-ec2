#!/bin/sh
aws secretsmanager create-secret --name "github-deploy-key" --description "GitHub deploy key for EC2 clones" --secret-string "$(cat aws_id_ed25519)" --region us-east-1
