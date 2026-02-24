#!/bin/bash

echo "Starting Pre-deployment checks..."

# 1. Check Terraform version
terraform -version

# 2. Check if we are in the right directory
if [ ! -f "providers.tf" ]; then
    echo "Error: providers.tf not found. Are you in the root of the repo?"
    exit 1
fi

# 3. Auto-format
terraform fmt -write=true

echo "Checks passed!"
