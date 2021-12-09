#!/bin/sh

apt update && apt install -y curl jq

STACK_NAME=${STACK_NAME}-${CI_BUILD_ID}

# Deploy to AWS
echo "-- Uploading application..."
aws cloudformation package --template-file $CI_PROJECT_DIR/micronaut-function-aws-graal/sam-native.yaml --output-template-file $CI_PROJECT_DIR/micronaut-function-aws-graal/build/output-sam.yaml --s3-bucket $S3_BUCKET
sed -i 's/MicronautNativeServiceApi/MicronautNativeServiceApi'${CI_BUILD_ID}'/g' $CI_PROJECT_DIR/micronaut-function-aws-graal/build/output-sam.yaml

echo "-- Deploying application..."
aws cloudformation deploy --template-file $CI_PROJECT_DIR/micronaut-function-aws-graal/build/output-sam.yaml --stack-name $STACK_NAME --capabilities CAPABILITY_IAM

echo "-- Getting API endpoint..."
# Get API endpoint
API_ENDPOINT=`aws cloudformation describe-stacks --stack-name $STACK_NAME | jq -r '.Stacks[0] .Outputs[0] .OutputValue'`

echo "-- Testing..."
#RESPONSE=$(curl -s -X POST -H 'Content-Type:application/json' -d '{"category":"foo"}' $API_ENDPOINT | jq -r '.type')
#EXPECTED_RESPONSE='success'
#if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && aws cloudformation delete-stack --stack-name $STACK_NAME && exit 1; fi

RESPONSE=$(curl -X POST -H 'Content-Type:application/json' -d '{"micronautVersion":"2.5.0"}' $API_ENDPOINT)
EXPECTED_RESPONSE='{"name":"Micronaut 3.2.0","url":"https://api.github.com/repos/micronaut-projects/micronaut-core/releases/53949281"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && aws cloudformation delete-stack --stack-name $STACK_NAME && exit 1; fi

# Cleanup
echo "-- Cleaning up environment..."
aws cloudformation delete-stack --stack-name $STACK_NAME
