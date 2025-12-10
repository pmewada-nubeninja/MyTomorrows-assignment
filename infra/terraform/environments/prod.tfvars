# Multi-Application Production Environment Configuration
# Example: Managing 4 applications with enterprise configurations

# ==========================================
# GLOBAL CONFIGURATION
# ==========================================

# Core deployment settings
environment   = "prod"
release_name  = "my-app-prod"
namespace     = "my-app-prod"
chart_path    = "../helmchart"

# Manage application state via Terraform in production
manage_application_state = true

# Production registry configuration
global_image_overrides = {
  registry    = "prod-registry.mytomorrows.com"
  tag_prefix  = "2.0"                      # Production major version
  pull_policy = "IfNotPresent"              # More efficient for production
}

# ==========================================
# APPLICATION SPECIFIC CONFIGURATION
# ==========================================

applications = [
  # Main API Service
  {
    name               = "my-tomorrows-api"
    image_repository   = "prod-registry.mytomorrows.com/my-tomorrows-api"
    image_tag         = "2.0.15"                    # Stable production version
    replicas          = 5                          # High availability
    enabled           = true
    env_variables = {
      "LOG_LEVEL"       = "WARN"
      "API_BASE_URL"    = "https://api.mytomorrows.com"
      "MAX_CONNECTIONS" = "100"                    # High connection limit
      "CACHE_TTL"       = "7200"                   # 2 hours cache
      "METRICS_ENABLED" = "true"
      "ENV"             = "production"
    }
    secrets = {
      "SECRET_KEY"      = "prod-api-secret-key-vault-2024"
      "DB_PASSWORD"     = "prod-database-password-vault"
      "JWT_SECRET"      = "prod-jwt-signing-key-vault"
    }
  },
  
  # Admin Panel
  {
    name               = "my-tomorrows-admin"
    image_repository   = "prod-registry.mytomorrows.com/my-tomorrows-admin"
    image_tag         = "2.0.8"
    replicas          = 3                          # Admin HA
    enabled           = true
    env_variables = {
      "LOG_LEVEL"       = "WARN"
      "ADMIN_BASE_URL"  = "https://admin.mytomorrows.com"
      "SESSION_TIMEOUT" = "1800"                  # 30 minutes
      "AUDIT_ENABLED"   = "true"
      "ENV"             = "production"
    }
    secrets = {
      "ADMIN_SECRET"    = "prod-admin-master-key-vault"
      "SESSION_KEY"     = "prod-session-encryption-vault"
    }
  },
  
  # Background Worker
  {
    name               = "my-tomorrows-worker"
    image_repository   = "prod-registry.mytomorrows.com/my-tomorrows-worker"
    image_tag         = "2.0.12"
    replicas          = 4                          # Multiple workers
    enabled           = true
    env_variables = {
      "LOG_LEVEL"       = "INFO"
      "QUEUE_URL"       = "redis://redis.my-app-prod.svc.cluster.local:6379"
      "BATCH_SIZE"      = "200"                   # Large batch size for efficiency
      "WORKER_TIMEOUT"  = "600"                   # 10 minutes timeout
      "SERVICE_NAME"    = "production-worker"
      "ENV"             = "production"
    }
    secrets = {
      "WORKER_SECRET"   = "prod-worker-auth-key-vault"
      "QUEUE_PASSWORD"  = "prod-redis-cluster-password"
    }
  },
  
  # Monitoring Service
  {
    name               = "my-tomorrows-monitor"
    image_repository   = "prod-registry.mytomorrows.com/my-tomorrows-monitor"
    image_tag         = "2.1.5"                    # Latest monitoring version
    replicas          = 2                          # HA monitoring
    enabled           = true
    env_variables = {
      "LOG_LEVEL"           = "INFO"
      "METRICS_INTERVAL"    = "30"                # 30 seconds
      "ALERT_WEBHOOK"       = "https://alerts.mytomorrows.com/webhook"
      "HEALTH_CHECK_URL"    = "https://api.mytomorrows.com/health"
      "PROMETHEUS_URL"      = "https://metrics.mytomorrows.com"
      "ENV"                 = "production"
    }
    secrets = {
      "MONITOR_TOKEN"   = "prod-monitoring-api-token-vault"
      "ALERT_WEBHOOK"   = "prod-alerting-webhook-secret"
    }
  }
]

# ==========================================
# LEGACY CONFIGURATION (Backward Compatibility)
# ==========================================

app_image_repository = ""  # Not used when applications list is provided
app_image_tag        = ""  # Not used when applications list is provided
app_replicas         = null
app_env_variables    = {}