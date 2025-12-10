# Generate random passwords when variables are empty
resource "random_password" "secret_key" {
  length  = 32
  special = true
  count   = var.secret_key == "" ? 1 : 0
}

resource "random_password" "db_password" {
  length  = 24
  special = true
  count   = var.db_password == "" ? 1 : 0
}

# Create namespace
resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

# Deploy the Helm chart
resource "helm_release" "my_tomorrows_app" {
  name         = var.release_name
  namespace    = kubernetes_namespace.app_namespace.metadata[0].name
  chart        = var.chart_path
  force_update = true

  # Use environment-specific values file
  values = [
    file("${var.chart_path}/values-${var.environment}.yaml")
  ]

  # ========================================
  # DYNAMIC MULTI-APPLICATION CONFIGURATION
  # ========================================

  # Configure each application in the list
  dynamic "set" {
    for_each = { for idx, app in var.applications : idx => app if app.image_repository != null }
    content {
      name  = "applications[${set.key}].image.repository"
      value = set.value.image_repository
    }
  }

  dynamic "set" {
    for_each = { for idx, app in var.applications : idx => app if app.image_tag != null }
    content {
      name  = "applications[${set.key}].image.tag"
      value = set.value.image_tag
    }
  }

  dynamic "set" {
    for_each = { for idx, app in var.applications : idx => app if app.replicas != null }
    content {
      name  = "applications[${set.key}].replicaCount"
      value = set.value.replicas
    }
  }

  # Manage application enabled/disabled state
  dynamic "set" {
    for_each = var.manage_application_state ? { for idx, app in var.applications : idx => app if app.enabled != null } : {}
    content {
      name  = "applications[${set.key}].enabled"
      value = set.value.enabled
    }
  }

  # Set environment variables for each application
  dynamic "set" {
    for_each = flatten([
      for idx, app in var.applications : [
        for env_key, env_value in app.env_variables : {
          app_index = idx
          env_key   = env_key
          env_value = env_value
        }
      ]
    ])
    content {
      name  = "applications[${set.value.app_index}].config.${set.value.env_key}"
      value = set.value.env_value
    }
  }

  # Set sensitive values (secrets) for each application
  dynamic "set_sensitive" {
    for_each = flatten([
      for idx, app in var.applications : [
        for secret_key, secret_value in app.secrets : {
          app_index    = idx
          secret_key   = secret_key
          secret_value = secret_value
        }
      ]
    ])
    content {
      name  = "applications[${set_sensitive.value.app_index}].secrets.${set_sensitive.value.secret_key}"
      value = set_sensitive.value.secret_value
    }
  }

  # ========================================
  # LEGACY SINGLE-APP SUPPORT (Backward Compatibility)
  # ========================================

  # Override sensitive values for first application (legacy support)
  set_sensitive {
    name  = "applications[0].secrets.SECRET_KEY"
    value = var.secret_key != "" ? var.secret_key : (length(random_password.secret_key) > 0 ? random_password.secret_key[0].result : "")
  }

  set_sensitive {
    name  = "applications[0].secrets.DB_PASSWORD"
    value = var.db_password != "" ? var.db_password : (length(random_password.db_password) > 0 ? random_password.db_password[0].result : "")
  }

  # Legacy image configuration for first application
  dynamic "set" {
    for_each = var.app_image_repository != "" && length(var.applications) == 0 ? [1] : []
    content {
      name  = "applications[0].image.repository"
      value = var.app_image_repository
    }
  }

  dynamic "set" {
    for_each = var.app_image_tag != "" && length(var.applications) == 0 ? [1] : []
    content {
      name  = "applications[0].image.tag"
      value = var.app_image_tag
    }
  }

  dynamic "set" {
    for_each = var.app_replicas != null && length(var.applications) == 0 ? [1] : []
    content {
      name  = "applications[0].replicaCount"
      value = var.app_replicas
    }
  }

  # Legacy environment-specific configuration overrides
  dynamic "set" {
    for_each = var.api_base_url != "" && length(var.applications) == 0 ? [1] : []
    content {
      name  = "applications[0].config.API_BASE_URL"
      value = var.api_base_url
    }
  }

  dynamic "set" {
    for_each = var.log_level != "" && length(var.applications) == 0 ? [1] : []
    content {
      name  = "applications[0].config.LOG_LEVEL"
      value = var.log_level
    }
  }

  dynamic "set" {
    for_each = var.max_connections != "" && length(var.applications) == 0 ? [1] : []
    content {
      name  = "applications[0].config.MAX_CONNECTIONS"
      value = var.max_connections
    }
  }

  # Legacy additional environment variables for first application
  dynamic "set" {
    for_each = length(var.applications) == 0 ? var.app_env_variables : {}
    content {
      name  = "applications[0].config.${set.key}"
      value = set.value
    }
  }

  # ========================================
  # GLOBAL CONFIGURATION OVERRIDES
  # ========================================

  # Apply global image registry override
  dynamic "set" {
    for_each = var.global_image_overrides.registry != null ? [1] : []
    content {
      name  = "global.registry"
      value = var.global_image_overrides.registry
    }
  }

  # Apply global image tag prefix
  dynamic "set" {
    for_each = var.global_image_overrides.tag_prefix != null ? [1] : []
    content {
      name  = "global.imageTag"
      value = var.global_image_overrides.tag_prefix
    }
  }

  # Wait for deployment to be ready
  wait    = true
  timeout = 300

  depends_on = [kubernetes_namespace.app_namespace]
}