#!/bin/sh
# change the aws profile accordingly
aws s3api create-bucket --bucket $BUCKET_NAME --region $AWS_REGION --profile los-ai;
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled --profile los-ai;
