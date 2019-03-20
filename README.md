# Micronaut Graal tests #

This repository allows continuous integration of GraalVM master branch and Micronaut test applications.

Everytime the pipeline is executed, GraalVM is built from master branch and it is used to build native-images in the different Micronaut test applications available at https://github.com/micronaut-graal-tests.

The pipeline schedule is done in this project: https://gitlab.com/micronaut-projects/micronaut-graal-tests-scheduler/.
