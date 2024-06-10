#!/bin/bash
source /etc/environment

role_session_name="logCollectionSession"

response=$(aws sts assume-role \
    --role-session-name "$role_session_name" \
    --role-arn "$ROLE_ARN" \
    --output text \
    --query "Credentials.[AccessKeyId, SecretAccessKey, SessionToken]" \
    --duration-seconds 900)

local error_code=${?}

if [[ $error_code -ne 0 ]]; then
aws_cli_error_log $error_code
errecho "ERROR: AWS reports create-role operation failed.\n$response"
return 1
fi

echo "$response"

export AWS_ACCESS_KEY_ID=$(echo $response | awk '{print $1}')
export AWS_SECRET_ACCESS_KEY=$(echo $response | awk '{print $2}')
export AWS_SESSION_TOKEN=$(echo $response | awk '{print $3}')


TODAY=$(date +%Y-%m-%d_%H-%M-%S)

TODAYS_S3_PREFIX="$AWS_S3_BUCKET_NAME/$TODAY/"

echo "Storing todays logs at $TODAYS_S3_PREFIX"

ls -al /var/log/

aws --version

aws s3 cp "/var/log/" "s3://$TODAYS_S3_PREFIX" --recursive  --include "*.log"

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN