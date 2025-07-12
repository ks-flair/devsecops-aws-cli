FROM registry.access.redhat.com/ubi8/ubi-minimal

# Install dependencies
RUN microdnf update -y && microdnf install -y \
    bash \
    curl \
    unzip \
    jq \
    groff \
    less \
    && microdnf clean all

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Set default shell to bash
SHELL ["/bin/bash", "-c"]

ENTRYPOINT ["bash"]
