#!/bin/bash

source secrets.deploy

aws cloudformation update-stack \
  --stack-name presenter-webui-peline \
  --template-body file://provision/pipeline.yaml \
  --parameters \
    "ParameterKey=GithubRepo,ParameterValue=${GITHUB_REPO}" \
    "ParameterKey=GithubControlRepo,ParameterValue=${GITHUB_CONTROL_REPO}" \
    "ParameterKey=GithubUser,ParameterValue=${GITHUB_USER}" \
    "ParameterKey=GithubToken,ParameterValue=${GITHUB_TOKEN}" \
    "ParameterKey=PipelineRole,ParameterValue=${PIPELINE_SERVICE_ROLE}" \
    "ParameterKey=BuildRole,ParameterValue=${BUILD_SERVICE_ROLE}" \
    "ParameterKey=ArtifactStore,ParameterValue=${ARTIFACT_STORE}"
