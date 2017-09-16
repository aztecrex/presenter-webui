# Easy Presenter - Web UI

Part of the demo for "Functional and Serverless on AWS"

## Continuous Delivery

The application is continually delivered using AWS CodePipeline and CodeBuild.

`buildspec.yml` contains the build specification for AWS CodeBuild.

The most recent deployment is available on the [live site](https://present.banjocreek.io).

## Build and Publish

Build is based on Node and NPM. Local versions of the Purescript compiler, build tooling (Pulp), and dependency manager (Bower) are installed as part of prep.

- install node and npm
- `./prep.sh` prepare node and purescript environment
- `./test.sh` to run unit tests
- `./run.sh` to run webpack dev server
- `./build.sh` to build static site; results in `./build/`
- `./publish.sh` to publish static site to origin bucket (see provisioning)

## Provisioning

The site is deployed to AWS S3 and delivered from that origin through AWS CloudFront. Provisioning templatesa are provided. Provisioning tooling is WIP

- `provision/runtime.yaml` provision runtime services S3, CloudFront, Route 53, etc.
- `provision/pipeline.yaml` provision the continuous delivery pipeline
