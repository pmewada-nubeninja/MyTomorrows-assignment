# Development Environment Configuration
# Kubernetes Configuration
kubeconfig_path = "~/.kube/config"
kube_context    = "docker-desktop"

# Environment Configuration
environment  = "dev"
namespace    = "my-app-dev"
release_name = "my-tomorrows-app"
chart_path   = "../helmchart"

# Application Configuration Overrides (optional - defaults from values-dev.yaml)
# app_replicas             = 1
# app_image_repository     = "cloudandparth/my-demo-app"
# app_image_tag            = "1.0"
# app_image_pull_policy    = "Always"
# app_container_port       = 5000

# Service Configuration Overrides (optional - defaults from values-dev.yaml)
# service_type             = "NodePort"
# service_port             = 80
# service_target_port      = 5000
# service_node_port        = 30080

# Ingress Configuration Overrides (optional - defaults from values-dev.yaml)
# ingress_enabled          = false
# ingress_class_name       = "nginx"
# ingress_host             = "my-app-dev.local"
# ingress_hosts_path       = "/"
# ingress_hosts_path_type  = "Prefix"

# Resource Configuration Overrides (optional - defaults from values-dev.yaml)
# resource_limits_cpu      = "200m"
# resource_limits_memory   = "256Mi"
# resource_requests_cpu    = "100m"
# resource_requests_memory = "128Mi"

# Health Check Overrides (optional - defaults from values-dev.yaml)
# liveness_probe_path      = "/health"
# liveness_probe_port      = 5000
# readiness_probe_path     = "/health"
# readiness_probe_port     = 5000
# startup_probe_path       = "/health"
# startup_probe_port       = 5000

# Security Configuration Overrides (optional - defaults from values-dev.yaml)
# security_context_run_as_non_root = true
# security_context_run_as_user     = 10001
# security_context_run_as_group    = 10001
# rbac_enabled                     = true
# network_policy_enabled           = true

# Application Environment Variables (optional - additional to values file)
# app_env_variables = {
#   "CUSTOM_VAR1" = "value1"
#   "CUSTOM_VAR2" = "value2"
# }

# Optional overrides for application configuration
# api_base_url    = "https://dev-api.example.com"
# log_level       = "DEBUG"
# max_connections = "50"

# Secrets (leave empty to auto-generate for dev)
# secret_key  = ""
# db_password = ""