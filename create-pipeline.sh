#!/bin/bash

content-bucket() {
  aws cloudformation describe-stacks \
    --stack-name engineer-site \
    --query 'Stacks[0].Outputs[?OutputKey==`"ContentStore"`]  | [0].OutputValue' \
    --output text
}


source secrets.deploy

aws cloudformation create-stack \
  --stack-name presenter-webui-peline \
  --template-body file://provision/pipeline.yaml \
  --parameters \
    "ParameterKey=GithubRepo,ParameterValue=${GITHUB_REPO}" \
    "ParameterKey=GithubUser,ParameterValue=${GITHUB_USER}" \
    "ParameterKey=GithubToken,ParameterValue=${GITHUB_TOKEN}" \
    "ParameterKey=PipelineRole,ParameterValue=${PIPELINE_SERVICE_ROLE}" \
    "ParameterKey=BuildRole,ParameterValue=${BUILD_SERVICE_ROLE}" \
    "ParameterKey=ArtifactStore,ParameterValue=${ARTIFACT_STORE}"
