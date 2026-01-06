#!/usr/bin/env bash 
set -euo pipefail
export AWS_REGION="${AWS_REGION:-us-east-1}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-$AWS_REGION}"

export LAST_IP=$(aws ec2 describe-instances --region $AWS_REGION --filters "Name=tag:Name,Values=ai_test_machine_001" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].{PublicIP:PublicIpAddress}" --output text)
#check if there's a public ip for the instance: 
if [[ -z "${LAST_IP}" || "${LAST_IP}" == "None" ]]; then
  echo "ERROR: Could not find a Public IP for ai_test_machine_001 in region $AWS_REGION" >&2
  exit 1
fi

ssh -i "$HOME/.ssh/id_rsa.pem" "ec2-user@${LAST_IP}"
