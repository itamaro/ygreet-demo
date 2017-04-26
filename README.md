YGreet Demo Project
===================

Demo project for comparing and contrasting 3 different approaches for building a microservices-based stack:

1. "Clean-plain-Docker approach" - just use Dockerfile and raw docker commands.
2. Google Container Builder
3. YABT (aka YBT)

The application itself is simple enough -
a stack of two services - a Python OpenAPI service ("user facing API"),
that "fans out" using gRPC to a backend service written in C++,
so the user can be greeted from both services.

## How to build

1. Clean-plain-Docker

cd into the `plaindocker` dir, and run `./build.sh`.

2. Google Container Builder

cd into `containerbuilder` dir, and run `gcloud container builds submit --config cloudbuild.unified.yaml .`.

The `unified` YAML builds both the builder images and app images,
and is a rather long process.
Since the builder images don't change often, it is useful to separate the flows,
and rebuild the builder images only when needed:

```
# build builder images
gcloud container builds submit --config cloudbuild.builder.yaml .
# build app images
gcloud container builds submit --config cloudbuild.app.yaml .
```

3. YABT

Install YABT (requires Python >= 3.4) - `pip3 install ybt`, cd into `withybt` directory, and run `make`.

This builds both builder images and app images.
As with the container builder, the builder images take a while to build,
and don't change often, so it can be useful so build and cache them using
`ybt build :builders --project-id $PROJECT_ID --build-base-images --push`
(the `--push` flag also pushes the cached images to `gcr.io`,
so other developers can use the cached images without rebuilding them).
With cached builder images, build and push just the app images using
`ybt build --project-id $PROJECT_ID --push`
(this command will fail if it is unable to find / fetch cached build images).

Note: probably need to run `gcloud docker -a` before all these commands.

## How to run the stack

1. Running locally

The top-level directory contains a `docker-compose` file that works based on local images named `cppgreet-svc` and `pygreet-svc`.

The "clean-plain-Docker" build and the YBT build both create such local images, so after building these, it is possible to use the docker compose as is, by running `docker-compose up` in the top-level dir.

The Google Container Builder runs remotely, and the resulting images are stored in Google's Docker registry, so in order to run these locally, you'll need to pull and retag them:

```
PROJECT_ID="$(gcloud config get-value project)"
gcloud docker -a
docker pull gcr.io/$PROJECT_ID/cppgreet-svc
docker pull gcr.io/$PROJECT_ID/pygreet-svc
docker tag gcr.io/$PROJECT_ID/cppgreet-svc:latest cppgreet-svc:latest
docker tag gcr.io/$PROJECT_ID/pygreet-svc:latest pygreet-svc:latest
```

2. Running on k8s / GKE

Assuming you have a k8s / GKE cluster set up, and `kubectl` configured to work with that cluster, you can simply run `./build-and-deploy.sh` from the `containerbuilder` dir to build using Google Container Builder and deploy the resulting images to this k8s cluster (YMMV).

You can do the same with the images built using the other methods by retagging the images and pushing them, and modifying `containerbuilder/k8s-app.yaml` accordingly and running `kubectl create -f containerbuilder/k8s-app.yaml`.

An example of a deployed stack can be seen [here](http://35.184.68.83:5000/ui/).

## TODO

- get Container Builder team's input on how I used it for the project (is this the best way to do that?)
- write up summary of experience with different approaches (describe ideal scenario, how each appraoch diverges from ideal, specific pain points, pro's and con's, ...)
