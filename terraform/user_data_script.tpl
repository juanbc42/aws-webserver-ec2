Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
 - rightscale_userdata
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - [scripts-user, always]
 - keys-to-console
 - phone-home
 - final-message

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
set -euo pipefail
set -x

# Configure IPv4-only
grep -q "precedence ::ffff:0:0/96 100" /etc/gai.conf || echo "precedence ::ffff:0:0/96 100" >> /etc/gai.conf

# Update & install dependencies
dnf -y update
dnf -y install git python3 python3-pip

# Configure env vars to get secrets
export REGION="${tf_region}"
export SECRET_NAME="${tf_secret_name}"

# Configure General env vars
export USER="ec2-user"
export HOME_DIR="/home/$USER"
export KEY_PATH="$HOME_DIR/.ssh/id_ed25519"
export SSH_CONFIG_PATH="$HOME_DIR/.ssh/config"
export KNOWN_HOSTS_PATH="$HOME_DIR/.ssh/known_hosts"
export GIT_REPO="${tf_git_repo}"

# Prepare ssh folder
install -d -m 700 -o "$USER" -g "$USER" "$HOME_DIR/.ssh"

# Gets secret and save it to key path
aws configure set region "$REGION"
aws secretsmanager get-secret-value --secret-id "$SECRET_NAME" --region "$REGION" --query 'SecretString' --output text > "$KEY_PATH"
chown "$USER":"$USER" "$KEY_PATH"
chmod 600 "$KEY_PATH"

--//
