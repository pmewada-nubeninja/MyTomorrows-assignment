# Terraform Configuration

This Terraform configuration deploys and manages multiple applications using an umbrella Helm chart approach. It provides a clean, modern multi-application deployment system with flexible configuration options and clear precedence hierarchies.

## Architecture Overview

The configuration uses a **pure multi-application approach** where:
- Each environment deploys multiple applications using a single Helm chart
- Applications can be configured individually or globally
- Configuration follows a clear three-tier precedence system
- All environments use the same deployment patterns

### Environment Progression
Applications scale from development to production with increasing complexity:
- **Development**: 2 applications (API + Worker)
- **Staging**: 3 applications (API + Admin + Worker)  
- **Production**: 4 applications (API + Admin + Worker + Monitoring)

## Configuration Precedence System

The configuration supports a **three-tier precedence hierarchy** for maximum flexibility:

### 1. Application-Level (Highest Precedence)
Individual application settings override all other configurations:
```hcl
applications = [
  {
    name         = "api-service"
    registry     = "my-private-registry.com"    # Overrides global and helm defaults
    tag_prefix   = "v2.0"                       # Overrides global and helm defaults
    # ... other config
  }
]
```

### 2. Global-Level (Medium Precedence)
Global settings apply to all applications unless overridden:
```hcl
global_image_overrides = {
  registry    = "company-registry.com"          # Applied if app doesn't specify
  tag_prefix  = "v1.5"                         # Applied if app doesn't specify
}
```

### 3. Helm Values (Default/Lowest Precedence)
Default values from `values-{env}.yaml` files serve as fallbacks.

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

## Multi-Application Configuration

```hcl
# Example with mixed precedence levels
global_image_overrides = {
  registry    = "dev-registry.company.com"
  tag_prefix  = "dev"
}

applications = [
  {
    name               = "my-tomorrows-api"
    image_repository   = "cloudandparth/my-demo-app"
    image_tag         = "2.0"
    # Uses global registry and tag_prefix
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
    registry          = "worker-registry.com"        # Overrides global registry
    tag_prefix        = "worker-v1"                  # Overrides global tag_prefix
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

### Application Configuration
- `applications`: List of application configurations with the following fields:
  - `name`: Application name (required)
  - `image_repository`: Override image repository (optional)
  - `image_tag`: Override image tag (optional)
  - `registry`: Application-level registry override (optional, highest precedence)
  - `tag_prefix`: Application-level tag prefix override (optional, highest precedence)
  - `replicas`: Override replica count (optional)
  - `enabled`: Enable/disable application (optional)
  - `env_variables`: Additional environment variables (optional)
  - `secrets`: Override secrets (optional)

### Global Configuration
- `manage_application_state`: Enable/disable applications via Terraform
- `global_image_overrides`: Global settings for all applications
  - `registry`: Global registry for all applications (medium precedence)
  - `tag_prefix`: Global tag prefix for all applications (medium precedence)
  - `pull_policy`: Global image pull policy

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
terraform output deployment_mode           # Always "multi-app"
terraform output managed_applications      # List of managed applications with precedence resolution
terraform output terraform_overrides_summary  # Summary of configuration overrides
```

### Example Output
```bash
# Shows effective configuration after precedence resolution
managed_applications = [
  {
    name = "my-tomorrows-api"
    registry = "dev-registry.company.com"      # From global config
    tag_prefix = "dev"                         # From global config
    # ... other fields
  },
  {
    name = "my-tomorrows-worker"
    registry = "worker-registry.com"           # From app-level override
    tag_prefix = "worker-v1"                   # From app-level override
    # ... other fields
  }
]
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

🔸 **Pure Multi-Application Architecture**: Clean, modern approach for deploying multiple applications  
🔸 **Three-Tier Precedence System**: Application > Global > Helm values configuration hierarchy  
🔸 **Environment Progression**: Structured scaling from dev (2 apps) to production (4 apps)  
🔸 **Flexible Application Management**: Individual application enable/disable and configuration  
🔸 **Registry Management**: Multi-level image registry and tag configuration  
🔸 **Production Ready**: Enterprise features scaling with environment complexity  

## Implementation Status

✅ **Clean Multi-Application Architecture**: No legacy code, pure multi-app approach  
✅ **Three-Tier Precedence System**: Application, global, and helm values precedence  
✅ **Environment Configurations**: Dev (2), Staging (3), Production (4) applications  
✅ **Advanced Registry Support**: Per-application and global registry management  
✅ **Application State Management**: Enable/disable applications via Terraform  
✅ **Security Features**: Production secrets management and security contexts  
✅ **Comprehensive Outputs**: Deployment information with precedence resolution  

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

This Terraform configuration provides a modern, enterprise-grade multi-application deployment system with:

- **Pure Multi-Application Architecture**: Clean, maintainable approach without legacy baggage
- **Three-Tier Precedence System**: Application > Global > Helm values configuration hierarchy
- **Environment-Specific Configurations**: Dev (2), Staging (3), Production (4) applications
- **Advanced Registry Management**: Per-application and global image registry configuration
- **Production-Ready Security**: Enterprise security features and secrets management
- **Flexible Application Control**: Individual application state management and configuration

The configuration scales seamlessly from simple development deployments to complex enterprise environments with clear, maintainable patterns and no backward compatibility complexity.