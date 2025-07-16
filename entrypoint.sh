#!/bin/bash
set -euo pipefail

# AWS CLI Docker Image Entrypoint Script
# This script handles container startup and provides default behavior

# Function to setup environment
setup_environment() {
    # Set working directory
    cd /workspace
    
    # Check if we're running as non-root and switch if needed
    if [ "$(id -u)" = "0" ] && [ -n "${RUN_AS_USER:-}" ]; then
        exec gosu "$RUN_AS_USER" "$@"
    fi
}

# Main entrypoint logic
main() {
    # Setup environment
    setup_environment
    
    # If arguments are provided, execute them
    if [ $# -gt 0 ]; then
        exec "$@"
    else
        # Default behavior: start interactive shell
        exec /bin/bash
    fi
}

# Execute main function with all arguments
main "$@" 
