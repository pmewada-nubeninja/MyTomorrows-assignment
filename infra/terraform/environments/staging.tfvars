# Multi-Application Staging Environment Configuration
# Example: Managing 3 applications via Terraform

# ==========================================
# GLOBAL CONFIGURATION
# ==========================================

# Core deployment settings
environment   = "staging"
release_name  = "my-app-staging"
namespace     = "my-app-staging"
chart_path    = "../helmchart"

# Manage application enabled/disabled state via Terraform
manage_application_state = true

global_image_overrides = {
  registry    = "docker.io"                # Staging registry
  tag_prefix  = "1.2"                      # Staging tag prefix
  pull_policy = "Always"                   # Always pull for staging testing
}

# ==========================================
# APPLICATION SPECIFIC CONFIGURATION
# ==========================================
applications = [
  {
    name               = "my-tomorrows-api"      # Must match name in values-staging.yaml
    enabled            = true                    # Ensure it's enabled
    image_repository   = "docker.io/my-tomorrows-api"
    image_tag          = "1.2.5"                 # Staging version
    replicas           = 3                       # Higher replicas for staging load testing
    env_variables = {
      "DEBUG"           = "false"
      "LOG_LEVEL"       = "INFO"
      "API_BASE_URL"    = "https://staging-api.mytomorrows.com"
      "MAX_CONNECTIONS" = "25"                  # Moderate connections for staging
      "ENV"             = "staging"
    }
    secrets = {
      "SECRET_KEY"  = "staging-api-secret-key-2024"
      "DB_PASSWORD" = "staging-db-password-secure"
    }
  },
  {
    name               = "my-tomorrows-admin"     # Admin panel for staging
    image_repository   = "docker.io/my-tomorrows-admin"
    image_tag          = "1.1.8"                 # Admin staging version
    replicas           = 2                       # Admin panel replicas
    enabled            = true                    # Enable admin in staging
    env_variables = {
      "LOG_LEVEL"       = "INFO"
      "ADMIN_BASE_URL"  = "https://staging-admin.mytomorrows.com"
      "SESSION_TIMEOUT" = "3600"               # 1 hour sessions
      "ENV"             = "staging"
    }
    secrets = {
      "ADMIN_SECRET"    = "staging-admin-secret-key"
      "SESSION_KEY"     = "staging-session-encryption-key"
    }
  },
  {
    name               = "my-tomorrows-worker"        # Background worker
    image_repository   = "docker.io/my-tomorrows-worker"
    image_tag          = "1.0.12"                      # Worker staging version
    replicas           = 2                             # Multiple workers for staging
    enabled            = true                          # Enable worker in staging
    env_variables = {
      "LOG_LEVEL"    = "INFO"
      "QUEUE_URL"    = "redis://redis.my-app-staging.svc.cluster.local:6379"
      "SERVICE_NAME" = "staging-background-worker"
      "BATCH_SIZE"   = "50"                         # Moderate batch size
      "ENV"          = "staging"
    }
    secrets = {
      "WORKER_SECRET"   = "staging-worker-secret-key"
      "QUEUE_PASSWORD"  = "staging-redis-password"
    }
  }
]