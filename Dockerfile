FROM registry.access.redhat.com/ubi8/ubi

# Install basic dependencies
RUN dnf update -y && dnf install -y \
    curl \
    unzip \
    jq \
    less \
    && dnf clean all

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

SHELL ["/bin/bash", "-c"]

ENTRYPOINT ["bash"]
