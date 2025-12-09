# Staging Environment Configuration
# Kubernetes Configuration
kubeconfig_path = "~/.kube/config"
kube_context    = "docker-desktop"

# Environment Configuration
environment  = "staging"
namespace    = "my-app-staging"
release_name = "my-tomorrows-app"
chart_path   = "../helmchart"

# Application Configuration Overrides (optional - defaults from values-staging.yaml)
# app_replicas             = 2
# app_image_repository     = "cloudandparth/my-demo-app"
# app_image_tag            = "1.0"
# app_image_pull_policy    = "IfNotPresent"

# Service Configuration Overrides (optional - defaults from values-staging.yaml)
# service_type             = "ClusterIP"
# service_port             = 80
# service_target_port      = 5000

# Ingress Configuration Overrides (optional - defaults from values-staging.yaml)
# ingress_enabled          = true
# ingress_class_name       = "nginx"
# ingress_host             = "my-app-staging.local"
# ingress_hosts_path       = "/"
# ingress_hosts_path_type  = "Prefix"

# Resource Configuration Overrides (optional - defaults from values-staging.yaml)
# resource_limits_cpu      = "500m"
# resource_limits_memory   = "512Mi"
# resource_requests_cpu    = "250m"
# resource_requests_memory = "256Mi"

# Autoscaling Overrides (optional - defaults from values-staging.yaml)
# autoscaling_enabled                    = true
# autoscaling_min_replicas               = 2
# autoscaling_max_replicas               = 5
# autoscaling_target_cpu_utilization     = 70
# autoscaling_target_memory_utilization  = 80

# Security Configuration Overrides (optional - defaults from values-staging.yaml)
# security_context_run_as_non_root = true
# security_context_run_as_user     = 10001
# rbac_enabled                     = true
# network_policy_enabled           = true

# Pod Disruption Budget Overrides (optional)
# pod_disruption_budget_enabled      = true
# pod_disruption_budget_min_available = "50%"

# Optional overrides for application configuration
# api_base_url    = "https://staging-api.example.com"
# log_level       = "INFO"
# max_connections = "75"

# Secrets (leave empty to auto-generate for staging)
# secret_key  = ""
# db_password = ""