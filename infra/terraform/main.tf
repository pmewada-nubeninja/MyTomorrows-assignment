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

  # Override sensitive values
  set_sensitive {
    name  = "app.secrets.SECRET_KEY"
    value = var.secret_key != "" ? var.secret_key : random_password.secret_key[0].result
  }

  set_sensitive {
    name  = "app.secrets.DB_PASSWORD"
    value = var.db_password != "" ? var.db_password : random_password.db_password[0].result
  }

  # Application Configuration Overrides
  dynamic "set" {
    for_each = var.app_replicas != null ? [1] : []
    content {
      name  = "replicaCount"
      value = var.app_replicas
    }
  }

  dynamic "set" {
    for_each = var.app_image_repository != "" ? [1] : []
    content {
      name  = "image.repository"
      value = var.app_image_repository
    }
  }

  dynamic "set" {
    for_each = var.app_image_tag != "" ? [1] : []
    content {
      name  = "image.tag"
      value = var.app_image_tag
    }
  }

  dynamic "set" {
    for_each = var.app_image_pull_policy != "" ? [1] : []
    content {
      name  = "image.pullPolicy"
      value = var.app_image_pull_policy
    }
  }

  dynamic "set" {
    for_each = var.app_container_port != null ? [1] : []
    content {
      name  = "app.containerPort"
      value = var.app_container_port
    }
  }

  # Service Configuration Overrides
  dynamic "set" {
    for_each = var.service_type != "" ? [1] : []
    content {
      name  = "service.type"
      value = var.service_type
    }
  }

  dynamic "set" {
    for_each = var.service_port != null ? [1] : []
    content {
      name  = "service.port"
      value = var.service_port
    }
  }

  dynamic "set" {
    for_each = var.service_target_port != null ? [1] : []
    content {
      name  = "service.targetPort"
      value = var.service_target_port
    }
  }

  dynamic "set" {
    for_each = var.service_node_port != null ? [1] : []
    content {
      name  = "service.nodePort"
      value = var.service_node_port
    }
  }

  # Ingress Configuration Overrides
  dynamic "set" {
    for_each = var.ingress_enabled != null ? [1] : []
    content {
      name  = "ingress.enabled"
      value = var.ingress_enabled
    }
  }

  dynamic "set" {
    for_each = var.ingress_class_name != "" ? [1] : []
    content {
      name  = "ingress.className"
      value = var.ingress_class_name
    }
  }

  dynamic "set" {
    for_each = var.ingress_host != "" ? [1] : []
    content {
      name  = "ingress.hosts[0].host"
      value = var.ingress_host
    }
  }

  dynamic "set" {
    for_each = var.ingress_hosts_path != "" ? [1] : []
    content {
      name  = "ingress.hosts[0].paths[0].path"
      value = var.ingress_hosts_path
    }
  }

  dynamic "set" {
    for_each = var.ingress_hosts_path_type != "" ? [1] : []
    content {
      name  = "ingress.hosts[0].paths[0].pathType"
      value = var.ingress_hosts_path_type
    }
  }

  # Resource Configuration Overrides
  dynamic "set" {
    for_each = var.resource_limits_cpu != "" ? [1] : []
    content {
      name  = "resources.limits.cpu"
      value = var.resource_limits_cpu
    }
  }

  dynamic "set" {
    for_each = var.resource_limits_memory != "" ? [1] : []
    content {
      name  = "resources.limits.memory"
      value = var.resource_limits_memory
    }
  }

  dynamic "set" {
    for_each = var.resource_requests_cpu != "" ? [1] : []
    content {
      name  = "resources.requests.cpu"
      value = var.resource_requests_cpu
    }
  }

  dynamic "set" {
    for_each = var.resource_requests_memory != "" ? [1] : []
    content {
      name  = "resources.requests.memory"
      value = var.resource_requests_memory
    }
  }

  # Liveness Probe Overrides
  dynamic "set" {
    for_each = var.liveness_probe_path != "" ? [1] : []
    content {
      name  = "livenessProbe.httpGet.path"
      value = var.liveness_probe_path
    }
  }

  dynamic "set" {
    for_each = var.liveness_probe_port != null ? [1] : []
    content {
      name  = "livenessProbe.httpGet.port"
      value = var.liveness_probe_port
    }
  }

  dynamic "set" {
    for_each = var.liveness_probe_initial_delay != null ? [1] : []
    content {
      name  = "livenessProbe.initialDelaySeconds"
      value = var.liveness_probe_initial_delay
    }
  }

  dynamic "set" {
    for_each = var.liveness_probe_period != null ? [1] : []
    content {
      name  = "livenessProbe.periodSeconds"
      value = var.liveness_probe_period
    }
  }

  # Readiness Probe Overrides
  dynamic "set" {
    for_each = var.readiness_probe_path != "" ? [1] : []
    content {
      name  = "readinessProbe.httpGet.path"
      value = var.readiness_probe_path
    }
  }

  dynamic "set" {
    for_each = var.readiness_probe_port != null ? [1] : []
    content {
      name  = "readinessProbe.httpGet.port"
      value = var.readiness_probe_port
    }
  }

  dynamic "set" {
    for_each = var.readiness_probe_initial_delay != null ? [1] : []
    content {
      name  = "readinessProbe.initialDelaySeconds"
      value = var.readiness_probe_initial_delay
    }
  }

  dynamic "set" {
    for_each = var.readiness_probe_period != null ? [1] : []
    content {
      name  = "readinessProbe.periodSeconds"
      value = var.readiness_probe_period
    }
  }

  # Startup Probe Overrides
  dynamic "set" {
    for_each = var.startup_probe_path != "" ? [1] : []
    content {
      name  = "startupProbe.httpGet.path"
      value = var.startup_probe_path
    }
  }

  dynamic "set" {
    for_each = var.startup_probe_port != null ? [1] : []
    content {
      name  = "startupProbe.httpGet.port"
      value = var.startup_probe_port
    }
  }

  dynamic "set" {
    for_each = var.startup_probe_initial_delay != null ? [1] : []
    content {
      name  = "startupProbe.initialDelaySeconds"
      value = var.startup_probe_initial_delay
    }
  }

  dynamic "set" {
    for_each = var.startup_probe_period != null ? [1] : []
    content {
      name  = "startupProbe.periodSeconds"
      value = var.startup_probe_period
    }
  }

  dynamic "set" {
    for_each = var.startup_probe_failure_threshold != null ? [1] : []
    content {
      name  = "startupProbe.failureThreshold"
      value = var.startup_probe_failure_threshold
    }
  }

  # Autoscaling Configuration Overrides
  dynamic "set" {
    for_each = var.autoscaling_enabled != null ? [1] : []
    content {
      name  = "autoscaling.enabled"
      value = var.autoscaling_enabled
    }
  }

  dynamic "set" {
    for_each = var.autoscaling_min_replicas != null ? [1] : []
    content {
      name  = "autoscaling.minReplicas"
      value = var.autoscaling_min_replicas
    }
  }

  dynamic "set" {
    for_each = var.autoscaling_max_replicas != null ? [1] : []
    content {
      name  = "autoscaling.maxReplicas"
      value = var.autoscaling_max_replicas
    }
  }

  dynamic "set" {
    for_each = var.autoscaling_target_cpu_utilization != null ? [1] : []
    content {
      name  = "autoscaling.targetCPUUtilizationPercentage"
      value = var.autoscaling_target_cpu_utilization
    }
  }

  dynamic "set" {
    for_each = var.autoscaling_target_memory_utilization != null ? [1] : []
    content {
      name  = "autoscaling.targetMemoryUtilizationPercentage"
      value = var.autoscaling_target_memory_utilization
    }
  }

  # Security Context Overrides
  dynamic "set" {
    for_each = var.security_context_run_as_non_root != null ? [1] : []
    content {
      name  = "securityContext.runAsNonRoot"
      value = var.security_context_run_as_non_root
    }
  }

  dynamic "set" {
    for_each = var.security_context_run_as_user != null ? [1] : []
    content {
      name  = "securityContext.runAsUser"
      value = var.security_context_run_as_user
    }
  }

  dynamic "set" {
    for_each = var.security_context_run_as_group != null ? [1] : []
    content {
      name  = "securityContext.runAsGroup"
      value = var.security_context_run_as_group
    }
  }

  dynamic "set" {
    for_each = var.security_context_fs_group != null ? [1] : []
    content {
      name  = "podSecurityContext.fsGroup"
      value = var.security_context_fs_group
    }
  }

  dynamic "set" {
    for_each = var.security_context_allow_privilege_escalation != null ? [1] : []
    content {
      name  = "securityContext.allowPrivilegeEscalation"
      value = var.security_context_allow_privilege_escalation
    }
  }

  dynamic "set" {
    for_each = var.security_context_read_only_root_filesystem != null ? [1] : []
    content {
      name  = "securityContext.readOnlyRootFilesystem"
      value = var.security_context_read_only_root_filesystem
    }
  }

  # Network Policy Overrides
  dynamic "set" {
    for_each = var.network_policy_enabled != null ? [1] : []
    content {
      name  = "networkPolicy.enabled"
      value = var.network_policy_enabled
    }
  }

  # RBAC Overrides
  dynamic "set" {
    for_each = var.rbac_enabled != null ? [1] : []
    content {
      name  = "rbac.create"
      value = var.rbac_enabled
    }
  }

  # Pod Disruption Budget Overrides
  dynamic "set" {
    for_each = var.pod_disruption_budget_enabled != null ? [1] : []
    content {
      name  = "podDisruptionBudget.enabled"
      value = var.pod_disruption_budget_enabled
    }
  }

  dynamic "set" {
    for_each = var.pod_disruption_budget_min_available != "" ? [1] : []
    content {
      name  = "podDisruptionBudget.minAvailable"
      value = var.pod_disruption_budget_min_available
    }
  }

  dynamic "set" {
    for_each = var.pod_disruption_budget_max_unavailable != "" ? [1] : []
    content {
      name  = "podDisruptionBudget.maxUnavailable"
      value = var.pod_disruption_budget_max_unavailable
    }
  }

  # Environment-specific configuration overrides
  dynamic "set" {
    for_each = var.api_base_url != "" ? [1] : []
    content {
      name  = "app.config.API_BASE_URL"
      value = var.api_base_url
    }
  }

  dynamic "set" {
    for_each = var.log_level != "" ? [1] : []
    content {
      name  = "app.config.LOG_LEVEL"
      value = var.log_level
    }
  }

  dynamic "set" {
    for_each = var.max_connections != "" ? [1] : []
    content {
      name  = "app.config.MAX_CONNECTIONS"
      value = var.max_connections
    }
  }

  # Additional environment variables
  dynamic "set" {
    for_each = var.app_env_variables
    content {
      name  = "env.${set.key}"
      value = set.value
    }
  }

  # Wait for deployment to be ready
  wait    = true
  timeout = 300

  depends_on = [kubernetes_namespace.app_namespace]
}