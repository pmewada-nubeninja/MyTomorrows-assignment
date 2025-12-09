# Terraform Helm Deployment - Multi-Environment

This Terraform configuration deploys the MyTomorrows application using Helm across multiple environments (dev, staging, prod) with environment-specific configurations.

## Features

- **Multi-Environment Support**: Deploy to dev, staging, or production environments
- **Environment-Specific Values**: Uses Helm values files for each environment
- **No Hard-Coding**: All configuration is parameterized and environment-specific
- **Automatic Secret Generation**: Generates secure random passwords when not provided
- **Flexible Overrides**: Option to override specific values via Terraform variables

## Prerequisites

- Terraform >= 1.0
- Kubectl configured with access to your Kubernetes cluster
- Helm provider configured
- MyTomorrows Helm chart in `../helmchart`

## Usage

### Deploy to Development Environment

```bash
terraform init
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"
```

### Deploy to Staging Environment

```bash
terraform plan -var-file="environments/staging.tfvars"
terraform apply -var-file="environments/staging.tfvars"
```

### Deploy to Production Environment

```bash
# First, set production secrets in environments/prod.tfvars
terraform plan -var-file="environments/prod.tfvars"
terraform apply -var-file="environments/prod.tfvars"
```

## Environment Files

### `environments/dev.tfvars`
- Uses `values-dev.yaml` from Helm chart
- NodePort service for easy local access
- Ingress disabled
- Debug logging enabled

### `environments/staging.tfvars`
- Uses `values-staging.yaml` from Helm chart
- More restrictive security settings
- Moderate resource limits

### `environments/prod.tfvars`
- Uses `values-prod.yaml` from Helm chart
- Maximum security settings
- Production resource limits
- **Requires manual secret configuration**

## Configuration Structure

```
terraform/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── outputs.tf              # Output definitions
├── provider.tf             # Provider configuration
├── environments/
│   ├── dev.tfvars         # Development environment
│   ├── staging.tfvars     # Staging environment
│   └── prod.tfvars        # Production environment
└── README.md              # This file
```

## Key Variables

| Variable | Description | Required |
|----------|-------------|-----------|
| `environment` | Environment name (dev/staging/prod) | Yes |
| `namespace` | Kubernetes namespace | Yes |
| `release_name` | Helm release name | Yes |
| `chart_path` | Path to Helm chart | Yes |
| `secret_key` | Application secret (auto-generated if empty) | No |
| `db_password` | Database password (auto-generated if empty) | No |

## Access Patterns

### Development (NodePort)
- Direct access via `http://localhost:30080`
- Health check: `curl http://localhost:30080/health`

### Staging/Production (ClusterIP + Ingress)
- Port-forward: `kubectl port-forward svc/my-tomorrows-app 8080:80 -n <namespace>`
- Access via: `http://localhost:8080`

## Security Notes

- **Development**: Uses auto-generated secrets, suitable for local development
- **Production**: Requires manual secret configuration in `prod.tfvars`
- All secrets are marked as sensitive in Terraform
- Environment-specific security policies applied via Helm values

## Cleanup

```bash
# For specific environment
terraform destroy -var-file="environments/dev.tfvars"

# Or for all environments
terraform destroy
```

## Troubleshooting

1. **Chart not found**: Ensure `chart_path` points to the correct Helm chart location
2. **Namespace issues**: Verify Kubernetes context and permissions
3. **Values file errors**: Check that environment-specific values files exist
4. **Secret generation**: If secrets aren't auto-generated, check Terraform random provider

## Migration from Legacy Configuration

This configuration replaces individual Terraform variables with environment-specific Helm values files, providing:
- Better separation of concerns
- Environment-specific configurations
- Reduced duplication
- Easier maintenance