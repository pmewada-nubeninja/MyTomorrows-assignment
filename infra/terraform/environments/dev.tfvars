# Multi-Application Development Environment Configuration
# Example: Managing 2 applications via Terraform

# ==========================================
# GLOBAL CONFIGURATION
# ==========================================

# Core deployment settings
environment   = "dev"
release_name  = "my-app-dev"
namespace     = "my-app-dev"
chart_path    = "../helmchart"

# Manage application enabled/disabled state via Terraform
manage_application_state = true

global_image_overrides = {
  registry    = "docker.io"            # Optional: override global registry
  tag_prefix  = "1.0"                  # Optional: global tag prefix
  pull_policy = "IfNotPresent"         # Optional: global pull policy
}

# ==========================================
# APPLICATION SPECIFIC CONFIGURATION
# ==========================================
applications = [
  {
    name               = "my-tomorrows-api"      # Must match name in values-dev.yaml
    enabled            = true                    # Ensure it's enabled
    image_repository   = "cloudandparth/my-demo-app"
    image_tag          = "1.0"                   # Override to newer version
    replicas           = 1                       # Scale up for testing
    env_variables = {
      "DEBUG"           = "true"
      "LOG_LEVEL"       = "DEBUG"
      "API_BASE_URL"    = "https://dev-api.example.com"
      "MAX_CONNECTIONS" = "15"                  # Override default
    }
    secrets = {
      "SECRET_KEY"  = "new-api-secret-key-dev"
      "DB_PASSWORD" = "new-db-password-dev"
    }
  },
  {
    name               = "my-tomorrows-worker"        # Second application
    image_repository   = "cloudandparth/my-demo-app"
    image_tag          = "1.0"                        # Same image, different config
    replicas           = 2                            # Enable worker with 2 replicas
    enabled            = true                         # Enable worker in dev
    env_variables = {
      "LOG_LEVEL"    = "INFO"
      "QUEUE_URL"    = "redis://redis.my-app-dev.svc.cluster.local:6379"
      "SERVICE_NAME" = "background-worker-v2"
    }
    secrets = {
      "WORKER_SECRET"   = "new-worker-secret-dev"
      "QUEUE_PASSWORD"  = "new-queue-password-dev"
    }
  }
]