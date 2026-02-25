FROM registry.redhat.io/ubi10@sha256:b9e5730d0b6dba45e82c15fb8f49c6082e01cdcb5e4f6ba96535dab42a4d2cf0

LABEL name="konflux-signing" \
    description="An image for signing and verifying software artifacts" \
    maintainers="The Collective team"

RUN dnf update -y \
    && dnf clean all
