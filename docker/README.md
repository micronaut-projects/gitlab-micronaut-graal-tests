# Docker image for building native images

For building the GraalVM native images for the Micronaut test applications we use
a custom docker image `graalvm-builder` based on the official 
[GraalVM CE Dockerfile](https://github.com/oracle/docker-images/blob/master/GraalVM/CE/Dockerfile).

The only difference is that we install `git` and we don't install GraalVM itself because it is
compiled in the `build-graalvm` stage of the CI pipeline.

To build and push the `graalvm-builder` docker image:

```
docker login registry.gitlab.com

docker build -t registry.gitlab.com/micronaut-projects/micronaut-graal-tests/graalvm-builder .

docker push registry.gitlab.com/micronaut-projects/micronaut-graal-tests/graalvm-builder
```
