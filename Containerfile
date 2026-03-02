FROM registry.redhat.io/ubi10@sha256:f573194e8e5231f1c9340c497e1f8d9aa9dbb42b2849e60341e34f50eec9477e

LABEL name="konflux-signing" \
    description="An image for signing and verifying software artifacts" \
    maintainers="The Collective team"

RUN dnf update -y \
    && dnf clean all
