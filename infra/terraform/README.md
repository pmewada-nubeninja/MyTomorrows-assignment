# Terraform Configuration

This Terraform configuration supports deploying and managing multiple applications using the umbrella Helm chart. It provides flexible deployment options for both single and multi-application scenarios with structured, maintainable approach.

## Architecture & Deployment Modes

The configuration supports flexible multi-application deployment with:

### Single Unified Approach
Each environment file can deploy any number of applications (1 to N) using the same configuration structure.

### Environment Progression
Applications scale from development to production with increasing complexity and enterprise features.

## Configuration Structure

All configuration files follow a consistent three-section structure:

1. **Global Configuration** - Environment settings, registries, global overrides
2. **Application Specific Configuration** - Individual application definitions  
3. **Legacy Configuration** - Backward compatibility settings

## Environment Files

### Current Environment Structure
```
environments/
├── dev.tfvars                 # Development (2 applications)
├── staging.tfvars             # Staging (3 applications) 
└── prod.tfvars                # Production (4 applications)
```

### Environment Specifications

| Environment | Applications | Registry | Tag Prefix | Use Case |
|-------------|-------------|----------|------------|----------|
| Development | 2 | docker.io | 1.0 | Local development |
| Staging | 3 | docker.io | 1.2 | Pre-production testing |
| Production | 4 | prod-registry.mytomorrows.com | 2.0 | Live production |

## Quick Start

### Deploy to Development
```bash
cd infra/terraform
terraform init
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"
```

### Environment-Specific Deployments
```bash
# Development (2 applications)
terraform apply -var-file="environments/dev.tfvars"

# Staging (3 applications)
terraform apply -var-file="environments/staging.tfvars"

# Production (4 applications)
terraform apply -var-file="environments/prod.tfvars"
```

## Environment Configurations

### Development Environment (dev.tfvars)
- **Applications**: 2 (API, Worker)
- **Registry**: docker.io
- **Tag Prefix**: 1.0
- **Replicas**: Low (1-2) for development
- **Logging**: DEBUG level
- **Features**: Basic development setup

### Staging Environment (staging.tfvars)
- **Applications**: 3 (API, Admin, Worker)
- **Registry**: docker.io
- **Tag Prefix**: 1.2
- **Replicas**: Moderate (2-3) for load testing
- **Logging**: INFO level
- **Features**: Admin panel for validation

### Production Environment (prod.tfvars)
- **Applications**: 4 (API, Admin, Worker, Monitor)
- **Registry**: prod-registry.mytomorrows.com
- **Tag Prefix**: 2.0
- **Replicas**: High (2-5) for availability
- **Logging**: WARN level for performance
- **Features**: Monitoring and enterprise features

## Multi-Application Setup

```hcl
applications = [
  {
    name               = "my-tomorrows-api"
    image_repository   = "cloudandparth/my-demo-app"
    image_tag         = "2.0"
    replicas          = 3
    enabled           = true
    env_variables = {
      "LOG_LEVEL"       = "DEBUG"
      "API_BASE_URL"    = "https://dev-api.example.com"
    }
    secrets = {
      "SECRET_KEY"  = "your-secret-key"
      "DB_PASSWORD" = "your-db-password"  
    }
  },
  {
    name               = "my-tomorrows-worker"
    image_repository   = "cloudandparth/my-demo-app"
    image_tag         = "2.0"
    replicas          = 2
    enabled           = true
    env_variables = {
      "QUEUE_URL"    = "redis://redis.my-app-dev.svc.cluster.local:6379"
    }
  }
]
```

## Available Variables

### Core Variables
- `environment`: Environment name (dev, staging, prod)
- `namespace`: Kubernetes namespace
- `release_name`: Helm release name
- `chart_path`: Path to Helm chart

### Multi-Application Variables
- `applications`: List of application configurations
- `manage_application_state`: Enable/disable applications via Terraform
- `global_image_overrides`: Global settings for all applications

## Use Cases

### Enable/Disable Applications
```hcl
# Enable API but disable worker
applications = [
  {
    name    = "my-tomorrows-api"
    enabled = true
    # ... other config
  },
  {
    name    = "my-tomorrows-worker" 
    enabled = false  # Disable worker
    # ... other config
  }
]

manage_application_state = true  # Required to manage enabled state
```

### Update Single Application
```hcl
# Update only the API application
applications = [
  {
    name             = "my-tomorrows-api"
    image_tag       = "3.0"  # New version
    replicas        = 5      # Scale up
    # Leave other apps using Helm defaults
  }
]
```

### Global Image Registry
```hcl
global_image_overrides = {
  registry    = "your-registry.azurecr.io"
  tag_prefix  = "v2.1"
  pull_policy = "IfNotPresent"
}
```

## Terraform Outputs

The configuration provides detailed outputs about your deployment:

```bash
terraform output deployment_mode           # single-app-legacy or multi-app
terraform output managed_applications      # List of managed applications
terraform output terraform_overrides_summary  # Summary of overrides
```

## Security Best Practices

### Production Secrets Management
```hcl
applications = [
  {
    name = "my-tomorrows-api"
    secrets = {
      "SECRET_KEY"  = var.api_secret_from_vault  # Use Terraform variables
      "DB_PASSWORD" = var.db_password_from_vault
    }
  }
]
```

## Access Patterns

### Development (NodePort)
- **Single App**: `http://localhost:30080`
- **Multi App**: `http://localhost:30080` (API), worker runs in background
- **Health check**: `curl http://localhost:30080/health`

### Staging/Production (ClusterIP + Ingress)
- Port-forward: `kubectl port-forward svc/<service-name> 8080:80 -n <namespace>`
- Access via configured ingress domains

## Key Features

🔸 **Unified Configuration**: Single approach for deploying 1 to N applications per environment  
🔸 **Environment Progression**: Structured deployment from dev (2 apps) to production (4 apps)  
🔸 **Flexible Application Management**: Enable/disable applications, update individually  
🔸 **Global Configuration**: Apply settings across all applications  
🔸 **Production Ready**: Enterprise features scaling with environment complexity  

## Implementation Status

✅ **Multi-Application Architecture**: Unified approach for 1-N applications per environment  
✅ **Environment Configurations**: Dev (2), Staging (3), Production (4) applications  
✅ **Global Registry Support**: Centralized image registry management  
✅ **Application State Management**: Enable/disable applications via Terraform  
✅ **Security Features**: Production secrets management and security contexts  
✅ **Terraform Outputs**: Comprehensive deployment information  

## Troubleshooting

### Check Application Status
```bash
# View deployment summary
terraform output managed_applications

# Check Helm release
terraform output release_status
```

### Validate Configuration
```bash
# Plan deployment to see changes
terraform plan -var-file="environments/your-config.tfvars"

# Validate Helm templates
helm template ../helmchart -f ../helmchart/values-dev.yaml
```

### Common Issues

1. **Application not found**: Ensure application names match those in your Helm values files
2. **Image pull errors**: Check image repository and tag configurations  
3. **Secret errors**: Verify secret names match Helm template expectations
4. **Chart not found**: Ensure `chart_path` points to the correct Helm chart location
5. **Namespace issues**: Verify Kubernetes context and permissions

## Application Management

### Deploy Single Application
```hcl
# To deploy only one application, simply define one in the array
applications = [
  {
    name               = "my-tomorrows-api"
    image_repository   = "cloudandparth/my-demo-app"
    image_tag         = "1.0"
    replicas          = 1
    enabled           = true
  }
]
```

### Deploy Multiple Applications  
```hcl
# Define multiple applications in the same structure
applications = [
  {
    name = "my-tomorrows-api"
    # ... config
  },
  {
    name = "my-tomorrows-worker"
    # ... config
  }
]
```

## File Structure

```
terraform/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Variable definitions
├── outputs.tf              # Output definitions
├── provider.tf             # Provider configuration
├── environments/
│   ├── dev.tfvars         # Development environment (2 applications)
│   ├── staging.tfvars     # Staging environment (3 applications)
│   └── prod.tfvars        # Production environment (4 applications)
└── README.md               # This documentation
```

## Deployment Examples

### Development with 2 Applications
```bash
terraform apply -var-file="environments/dev.tfvars"
# Deploys: API service + Worker service
# Access: http://localhost:30080
```

### Staging with 3 Applications
```bash
terraform apply -var-file="environments/staging.tfvars"
# Deploys: API + Admin Dashboard + Worker
# Access: Via ingress (configure DNS)
```

### Production with 4 Applications
```bash
terraform apply -var-file="environments/prod.tfvars"
# Deploys: API + Admin + Worker + Monitoring
# Access: Production domains with TLS
```

## Cleanup

```bash
# For specific environment
terraform destroy -var-file="environments/dev.tfvars"

# Complete cleanup
terraform destroy
```

## Summary

This Terraform configuration provides enterprise-grade multi-application management with:
- Support for 1 to N applications per environment using unified configuration approach
- Environment-specific configurations: Dev (2), Staging (3), Production (4) applications
- Global configuration management across applications
- Production-ready security and monitoring features
- Flexible application state management (enable/disable individual apps)

The configuration scales seamlessly from simple single-application deployments to complex multi-application enterprise environments.