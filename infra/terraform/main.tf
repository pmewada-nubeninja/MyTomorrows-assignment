# Multi-Application Kubernetes Deployment
# This configuration supports deploying multiple applications using an umbrella Helm chart

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

  # Set application-level registry overrides (highest precedence)
  dynamic "set" {
    for_each = { for idx, app in var.applications : idx => app if app.registry != null }
    content {
      name  = "applications[${set.key}].image.registry"
      value = set.value.registry
    }
  }

  # Set application-level tag prefix overrides (highest precedence)
  dynamic "set" {
    for_each = { for idx, app in var.applications : idx => app if app.tag_prefix != null }
    content {
      name  = "applications[${set.key}].image.tagPrefix"
      value = set.value.tag_prefix
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