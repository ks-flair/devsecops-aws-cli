FROM registry.access.redhat.com/ubi8/ubi-minimal

# Install basic dependencies
RUN microdnf update -y && microdnf install -y \
    bash \
    curl \
    less \
    && microdnf clean all

# Install unzip (manually, if missing from repos)
RUN curl -LO https://github.com/kuba--/unzip/releases/download/v6.0/unzip-6.0-1.x86_64.rpm && \
    microdnf install -y unzip-6.0-1.x86_64.rpm && \
    rm unzip-6.0-1.x86_64.rpm

# Install jq (manually, if missing from repos)
RUN curl -L -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod +x /usr/bin/jq

# Install groff (not available in minimal, skip unless essential)

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

SHELL ["/bin/bash", "-c"]

ENTRYPOINT ["bash"]
