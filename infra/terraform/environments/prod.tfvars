# Production Environment Configuration
# Kubernetes Configuration
kubeconfig_path = "~/.kube/config"
kube_context    = "minikube"  # Assuming production uses minikube

# Environment Configuration
environment  = "prod"
namespace    = "my-app-prod"
release_name = "my-tomorrows-app"
chart_path   = "../helmchart"

# Application Configuration Overrides (optional - defaults from values-prod.yaml)
# app_replicas             = 3
# app_image_repository     = "cloudandparth/my-demo-app"
# app_image_tag            = "1.0"
# app_image_pull_policy    = "IfNotPresent"

# Service Configuration Overrides (optional - defaults from values-prod.yaml)
# service_type             = "LoadBalancer"
# service_port             = 80
# service_target_port      = 5000

# Ingress Configuration Overrides (optional - defaults from values-prod.yaml)
# ingress_enabled          = true
# ingress_class_name       = "nginx"
# ingress_host             = "my-app.example.com"
# ingress_hosts_path       = "/"
# ingress_hosts_path_type  = "Prefix"
# ingress_tls_enabled      = true
# ingress_tls_secret_name  = "my-app-tls"

# Resource Configuration Overrides (optional - defaults from values-prod.yaml)
# resource_limits_cpu      = "1000m"
# resource_limits_memory   = "1Gi"
# resource_requests_cpu    = "500m"
# resource_requests_memory = "512Mi"

# Autoscaling Overrides (optional - defaults from values-prod.yaml)
# autoscaling_enabled                    = true
# autoscaling_min_replicas               = 3
# autoscaling_max_replicas               = 10
# autoscaling_target_cpu_utilization     = 80
# autoscaling_target_memory_utilization  = 85

# Security Configuration Overrides (optional - defaults from values-prod.yaml)
# security_context_run_as_non_root         = true
# security_context_run_as_user             = 10001
# security_context_read_only_root_filesystem = true
# rbac_enabled                             = true
# network_policy_enabled                   = true

# Pod Disruption Budget Overrides (optional)
# pod_disruption_budget_enabled      = true
# pod_disruption_budget_min_available = "50%"

# Health Check Overrides (optional - for production tuning)
# liveness_probe_initial_delay  = 30
# liveness_probe_period         = 10
# readiness_probe_initial_delay = 5
# readiness_probe_period        = 5
# startup_probe_initial_delay   = 10
# startup_probe_period          = 10
# startup_probe_failure_threshold = 30

# Application Environment Variables (production-specific)
# app_env_variables = {
#   "ENVIRONMENT"      = "production"
#   "METRICS_ENABLED"  = "true"
#   "TRACING_ENABLED"  = "true"
# }

# Optional overrides for application configuration
# api_base_url    = "https://api.example.com"
# log_level       = "WARNING"
# max_connections = "200"

# Secrets (REQUIRED for production - set these!)
# secret_key  = "your-production-secret-key-here"
# db_password = "your-production-password-here"