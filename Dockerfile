FROM alpine:edge

ARG PLATFORM=linux_amd64
ARG TF_VERSION=1.3.7
ARG TFLINT_VERSION=0.44.1
ARG TFLINT_AWS_RULESET_VERSION=0.21.1

ARG TF_DIST_FILENAME="terraform_${TF_VERSION}_${PLATFORM}.zip"
ARG TF_DIST_CHECKSUM_FILENAME="terraform_${TF_VERSION}_SHA256SUMS"

LABEL org.opencontainers.image.description="Hashicorp Packer with Ansible" \
      org.opencontainers.image.authors="ThinkingLabs (hello@thinkinglabs.io)" \
      org.opencontainers.image.url="https://github.com/thinkinglabs/docker-terraform" \
      org.opencontainers.image.source="git@github.com:thinkinglabs/docker-terraform.git" \
      org.opencontainers.image.licenses="MIT"

COPY .tflint.hcl.source /root/

RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_DIST_FILENAME} \
  && wget https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_DIST_CHECKSUM_FILENAME} \
  && set -o pipefail && grep ${PLATFORM} ${TF_DIST_CHECKSUM_FILENAME} | sha256sum -c - \
  && unzip ${TF_DIST_FILENAME} -d /usr/local/bin \
  && rm ${TF_DIST_FILENAME} ${TF_DIST_CHECKSUM_FILENAME} \
  && wget https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_${PLATFORM}.zip \
  && wget https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/checksums.txt \
  && set -o pipefail && grep ${PLATFORM} checksums.txt | sha256sum -c - \
  && unzip tflint_${PLATFORM}.zip -d /usr/local/bin \
  && rm tflint_${PLATFORM}.zip checksums.txt \
  && apk update && apk --no-cache add make gettext bash \
  && envsubst < /root/.tflint.hcl.source > /root/.tflint.hcl \
  && tflint --init \
  && apk del gettext
