FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

# Install basic dependencies with security updates
RUN microdnf update -y && microdnf install -y \
    curl \
    unzip \
    jq \
    less \
    bash \
    shadow-utils \
    && microdnf clean all

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Create non-root user for security (available for scripts that need it)
RUN useradd -m -s /bin/bash awsuser && \
    chown -R awsuser:awsuser /home/awsuser

# Keep root user for CI pipeline compatibility
# Scripts can switch to awsuser when needed: sudo -u awsuser command
WORKDIR /workspace

# Ensure proper shell configuration for CI compatibility
SHELL ["/bin/bash", "-c"]

ENTRYPOINT ["bash"]
