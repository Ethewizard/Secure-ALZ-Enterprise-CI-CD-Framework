#!/bin/bash
set -e

echo "Starting Pre-deployment checks..."

# 1. Check if Terraform is installed
terraform -version

# 2. Check if we are in the right directory
if [ ! -f "providers.tf" ]; then
    echo "Error: providers.tf not found. Are you in the root of the repo?"
    exit 1
fi

# 3. Format Check (Ensures team code style)
terraform fmt -check

echo "Checks passed!"
