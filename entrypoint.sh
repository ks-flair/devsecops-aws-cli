#!/bin/bash
set -euo pipefail

# AWS CLI Docker Image Entrypoint Script
# This script handles container startup and provides default behavior

log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1"
}

log_warn() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] $1" >&2
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" >&2
}

# Function to check if AWS CLI is available
check_aws_cli() {
    if command -v aws &> /dev/null; then
        log_info "AWS CLI is available: $(aws --version)"
        return 0
    else
        log_error "AWS CLI is not available"
        return 1
    fi
}

# Function to check required tools
check_required_tools() {
    local tools=("curl" "unzip" "jq" "bash")
    local missing_tools=()
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -eq 0 ]; then
        log_info "All required tools are available"
        return 0
    else
        log_error "Missing required tools: ${missing_tools[*]}"
        return 1
    fi
}

# Function to setup environment
setup_environment() {
    log_info "Setting up container environment..."
    
    # Set working directory
    cd /workspace
    
    # Check if we're running as non-root and switch if needed
    if [ "$(id -u)" = "0" ] && [ -n "${RUN_AS_USER:-}" ]; then
        log_info "Switching to user: $RUN_AS_USER"
        exec gosu "$RUN_AS_USER" "$@"
    fi
    
    log_info "Environment setup complete"
}

# Main entrypoint logic
main() {
    log_info "Starting AWS CLI container..."
    
    # Check required tools
    if ! check_required_tools; then
        exit 1
    fi
    
    # Check AWS CLI
    if ! check_aws_cli; then
        log_warn "AWS CLI check failed, but continuing..."
    fi
    
    # Setup environment
    setup_environment
    
    # If arguments are provided, execute them
    if [ $# -gt 0 ]; then
        log_info "Executing command: $*"
        exec "$@"
    else
        # Default behavior: start interactive shell
        log_info "No command provided, starting interactive shell"
        exec /bin/bash
    fi
}

# Execute main function with all arguments
main "$@" 
