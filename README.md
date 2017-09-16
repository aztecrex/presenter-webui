# Easy Presenter - Web UI

Part of the demo for "Functional and Serverless on AWS"

## Continuous Delivery

The application is continually delivered and can be viewed on the [live site](https://present.banjocreek.io).

## Build

Build is based on Node and NPM. Local versions of the Purescript compiler, build tooling (Pulp), and dependency manager (Bower) are installed as part of prep.

- install node and npm
- `./prep.sh` prepare node and purescript environment
- `./test.sh` to run unit tests
- `./run.sh` to run webpack dev server
- `./build.sh` to build static site; results in `./build/`


