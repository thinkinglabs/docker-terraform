# docker-terraform

Alpine based Docker images with [Hashicorp Terraform](https://www.packer.io/).

All images contain:

- `tflint`: for linting Terraform configurations
- `make`: for using a Makefile to bootstrap Terraform

The image is primarily implemented for use as an image resource for a
[Concourse](https://concourse-ci.org) task.
Therefore, no `ENTRYPOINT` is defined and the container runs as root.

Concourse has some issues running tasks as non-root users, i.e.
[Concourse tasks ran as non-root users can not create files inside output directories](https://github.com/concourse/concourse/issues/403).
