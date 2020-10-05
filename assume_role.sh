#!/bin/bash

# Remove existing credentials
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset AWS_SECURITY_TOKEN
unset AWS_PROFILE


# Check if root account or role based account
if [[ $(aws configure get source_profile --profile $1) ]]; then
    base_profile=$(aws configure get source_profile --profile $1)
    role=$(aws configure get role_arn --profile $1)
else
    export AWS_PROFILE=$1
    return
fi

# Find current root account ID and username
export AWS_PROFILE=$base_profile
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
AWS_ACCOUNT_USERNAME=$(aws sts get-caller-identity --output text --query Arn | cut -d/ -f2)

# Get MFA from the user
read -p 'MFA: ' AWS_MFA_CODE

# Switch to new Role
CRED=$(aws sts assume-role --role-arn $role --role-session-name mfacli --serial-number arn:aws:iam::$AWS_ACCOUNT_ID:mfa/$AWS_ACCOUNT_USERNAME --token-code $AWS_MFA_CODE --query '[Credentials.SessionToken,Credentials.AccessKeyId,Credentials.SecretAccessKey]' --output text)
CRED=${CRED//$'\t'/ }

# Set new creds in Environmental Variables for use with AWS CLI
unset AWS_PROFILE
export AWS_ACCESS_KEY_ID=$(echo $CRED | cut -d " " -f 2)
export AWS_SECRET_ACCESS_KEY=$(echo $CRED | cut -d " " -f 3)
export AWS_SESSION_TOKEN=$(echo $CRED | cut -d " " -f 1)