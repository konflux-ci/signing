FROM quay.io/konflux-ci/task-runner@sha256:d9feec6f2ce9b10cfb76b45ea14f83b5ed9f231de7d6083291550aebe8eb09ea AS golang
FROM registry.redhat.io/ubi10@sha256:b9e5730d0b6dba45e82c15fb8f49c6082e01cdcb5e4f6ba96535dab42a4d2cf0

LABEL name="konflux-signing" \
    description="An image for signing and verifying software artifacts" \
    maintainers="The Collective team"


# setup certificates
RUN curl -sf https://certs.corp.redhat.com/certs/Current-IT-Root-CAs.pem \
    -o /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt && \
    /usr/bin/update-ca-trust

RUN curl -k -o /etc/yum.repos.d/rcm-tools-rhel-10-baseos.repo \
    https://download.devel.redhat.com/rel-eng/RCMTOOLS/rcm-tools-rhel-10-baseos.repo && cat /etc/yum.repos.d/rcm-tools-rhel-10-baseos.repo


RUN dnf update -y \
    && dnf install -y  \
    rh-signing-client \
    rh-signing-client-stage \
    python3-pip \
    && dnf clean all

RUN pip install --no-cache-dir uv==0.10.6

COPY --from=golang /usr/local/bin/oras /usr/bin/oras

WORKDIR /app

COPY pyproject.toml uv.lock README.md /app/
RUN uv sync --frozen --no-install-project --no-dev

COPY signing /app/signing
RUN uv sync --frozen --no-dev

ENV PATH="/app/.venv/bin:$PATH"
