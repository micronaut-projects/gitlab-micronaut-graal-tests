#!/bin/sh

apt update && apt install -y curl jq

STACK_NAME=${STACK_NAME}-${CI_BUILD_ID}

# Deploy to AWS
echo "-- Uploading application..."
aws cloudformation package --template-file $CI_PROJECT_DIR/micronaut-aws-app-graal/sam-native.yaml --output-template-file $CI_PROJECT_DIR/micronaut-aws-app-graal/build/output-sam.yaml --s3-bucket $S3_BUCKET
sed -i 's/MicronautNativeServiceApi/MicronautNativeServiceApi'${CI_BUILD_ID}'/g' $CI_PROJECT_DIR/micronaut-aws-app-graal/build/output-sam.yaml

echo "-- Deploying application..."
aws cloudformation deploy --template-file $CI_PROJECT_DIR/micronaut-aws-app-graal/build/output-sam.yaml --stack-name $STACK_NAME --capabilities CAPABILITY_IAM

echo "-- Getting API endpoint..."
# Get API endpoint
API_ENDPOINT=`aws cloudformation describe-stacks --stack-name $STACK_NAME | jq -r '.Stacks[0] .Outputs[0] .OutputValue'`

echo "-- Testing..."
#RESPONSE=$(curl -s $API_ENDPOINT/jokes/nerdy | jq -r '.type')
#EXPECTED_RESPONSE='success'
#if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && aws cloudformation delete-stack --stack-name $STACK_NAME && exit 1; fi
#
#RESPONSE=$(curl -s $API_ENDPOINT/jokes/566)
#EXPECTED_RESPONSE='{"type":"success","factId":566,"value":"Chuck Norris could use anything in java.util.* to kill you, including the javadocs."}'
#if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && aws cloudformation delete-stack --stack-name $STACK_NAME && exit 1; fi

RESPONSE=$(curl -s $API_ENDPOINT/github/releases | jq -c '.[] | {name:.name} | select(.name | contains("Micronaut 3.7.0"))')
EXPECTED_RESPONSE='{"name":"Micronaut 3.7.0"}'
if [ "$RESPONSE" != "$EXPECTED_RESPONSE" ]; then echo $RESPONSE && aws cloudformation delete-stack --stack-name $STACK_NAME && exit 1; fi

# Cleanup
echo "-- Cleaning up environment..."
aws cloudformation delete-stack --stack-name $STACK_NAME
