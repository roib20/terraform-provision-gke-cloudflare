#!/bin/sh

# Default values
TF_BIN=""
AUTO_APPROVE=""

# Detect available binaries if not overridden
detect_default_binary() {
    if command -v tofu >/dev/null 2>&1; then
        TF_BIN="tofu"
    elif command -v terraform >/dev/null 2>&1; then
        TF_BIN="terraform"
    else
        echo "Error: Neither 'tofu' nor 'terraform' is installed or in PATH, and no binary was provided via -tf_binary."
        exit 1
    fi
}

# Parse flags
while [ $# -gt 0 ]; do
    case "$1" in
        -auto-approve)
            AUTO_APPROVE="$1"
            ;;
        -tf_binary)
            shift
            if [ -z "$1" ]; then
                echo "Error: -tf_binary requires an argument."
                exit 1
            fi
            if [ ! -x "$1" ] && ! command -v "$1" >/dev/null 2>&1; then
                echo "Error: Specified Terraform binary '$1' is not executable or not found in PATH."
                exit 1
            fi
            TF_BIN="$1"
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Fallback to detected binary if none provided
[ -z "$TF_BIN" ] && detect_default_binary

# Define tf alias
tf() {
    "$TF_BIN" "$@"
}

# Enable required GCP services
gcloud services enable container.googleapis.com

# Initialize Terraform/Tofu
tf init

# Apply GCP-specific module
tf apply -target=module.gcp "$AUTO_APPROVE"

# Extract Terraform variables
PROJECT_ID=$(echo "var.project_id" | tf console -var-file terraform.tfvars |
    sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")

ZONE=$(echo "var.zone" | tf console -var-file terraform.tfvars |
    sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")

REGION=$(echo "var.region" | tf console -var-file terraform.tfvars |
    sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")

# Get cluster credentials
gcloud container clusters get-credentials "$PROJECT_ID-gke" --zone "$ZONE" || \
gcloud container clusters get-credentials "$PROJECT_ID-gke" --region "$REGION"

# Fetch Cloudflare secrets
/bin/sh get-cloudflare-secret.sh

# Apply Helm releases
tf apply -target=module.helm_releases "$AUTO_APPROVE"

# Apply everything else
tf apply "$AUTO_APPROVE"

exit 0
