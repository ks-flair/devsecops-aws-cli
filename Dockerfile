FROM registry.access.redhat.com/ubi8/ubi:latest

# Install basic dependencies with security updates
RUN dnf update -y && dnf install -y \
    curl \
    unzip \
    jq \
    less \
    bash \
    && dnf clean all

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Create non-root user for security (available for scripts that need it)
RUN useradd -m -s /bin/bash awsuser && \
    chown -R awsuser:awsuser /home/awsuser

# Security hardening: Remove unnecessary files and set proper permissions
RUN find /tmp -type f -delete 2>/dev/null || true && \
    find /var/tmp -type f -delete 2>/dev/null || true && \
    chmod 755 /home/awsuser && \
    chmod 700 /home/awsuser/.bashrc 2>/dev/null || true

# Keep root user for CI pipeline compatibility
# Scripts can switch to awsuser when needed: sudo -u awsuser command
WORKDIR /workspace

# Ensure proper shell configuration for GitLab CI compatibility
RUN ln -sf /bin/bash /bin/sh && \
    chmod +x /bin/bash /bin/sh

# Copy and setup entrypoint script
COPY images/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
