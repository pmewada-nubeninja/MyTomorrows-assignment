variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = "docker-desktop"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
}

variable "release_name" {
  description = "Helm release name"
  type        = string
}

variable "chart_path" {
  description = "Path to the Helm chart"
  type        = string
}

# Application Configuration Variables
variable "app_replicas" {
  description = "Number of application replicas"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "app_image_repository" {
  description = "Docker image repository for the application"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "app_image_tag" {
  description = "Docker image tag for the application"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "app_image_pull_policy" {
  description = "Docker image pull policy for the application"
  type        = string
  default     = ""  # Use Helm values file default if not specified

  validation {
    condition     = var.app_image_pull_policy == "" || contains(["Always", "IfNotPresent", "Never"], var.app_image_pull_policy)
    error_message = "Image pull policy must be one of: Always, IfNotPresent, Never."
  }
}

# Service Configuration Variables
variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = ""  # Use Helm values file default if not specified

  validation {
    condition     = var.service_type == "" || contains(["ClusterIP", "NodePort", "LoadBalancer"], var.service_type)
    error_message = "Service type must be one of: ClusterIP, NodePort, LoadBalancer."
  }
}

variable "service_port" {
  description = "Service port"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "service_target_port" {
  description = "Service target port (port on the container)"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "service_node_port" {
  description = "NodePort for the service (only used when service_type is NodePort)"
  type        = number
  default     = null  # Use Helm values file default if not specified

  validation {
    condition     = var.service_node_port == null || (var.service_node_port >= 30000 && var.service_node_port <= 32767)
    error_message = "NodePort must be between 30000 and 32767."
  }
}

# Ingress Configuration Variables
variable "ingress_enabled" {
  description = "Enable ingress"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "ingress_class_name" {
  description = "Ingress class name"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "ingress_host" {
  description = "Ingress host"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "ingress_hosts_path" {
  description = "Ingress host path"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "ingress_hosts_path_type" {
  description = "Ingress host path type"
  type        = string
  default     = ""  # Use Helm values file default if not specified

  validation {
    condition     = var.ingress_hosts_path_type == "" || contains(["Prefix", "ImplementationSpecific", "Exact"], var.ingress_hosts_path_type)
    error_message = "Ingress host path type must be one of: Prefix, ImplementationSpecific, Exact."
  }
}

variable "ingress_tls_enabled" {
  description = "Enable TLS for ingress"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "ingress_tls_secret_name" {
  description = "TLS secret name for ingress"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

# Resource Configuration Variables
variable "resource_limits_cpu" {
  description = "CPU resource limits"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "resource_limits_memory" {
  description = "Memory resource limits"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "resource_requests_cpu" {
  description = "CPU resource requests"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "resource_requests_memory" {
  description = "Memory resource requests"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

# Health Check Configuration Variables
variable "liveness_probe_enabled" {
  description = "Enable liveness probe"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "liveness_probe_path" {
  description = "Liveness probe HTTP path"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "liveness_probe_port" {
  description = "Liveness probe port"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "liveness_probe_initial_delay" {
  description = "Liveness probe initial delay seconds"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "liveness_probe_period" {
  description = "Liveness probe period seconds"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "readiness_probe_enabled" {
  description = "Enable readiness probe"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "readiness_probe_path" {
  description = "Readiness probe HTTP path"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "readiness_probe_port" {
  description = "Readiness probe port"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "readiness_probe_initial_delay" {
  description = "Readiness probe initial delay seconds"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "readiness_probe_period" {
  description = "Readiness probe period seconds"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "startup_probe_enabled" {
  description = "Enable startup probe"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "startup_probe_path" {
  description = "Startup probe HTTP path"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "startup_probe_port" {
  description = "Startup probe port"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "startup_probe_initial_delay" {
  description = "Startup probe initial delay seconds"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "startup_probe_period" {
  description = "Startup probe period seconds"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "startup_probe_failure_threshold" {
  description = "Startup probe failure threshold"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

# Autoscaling Configuration Variables
variable "autoscaling_enabled" {
  description = "Enable horizontal pod autoscaling"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "autoscaling_min_replicas" {
  description = "Minimum number of replicas for autoscaling"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "autoscaling_max_replicas" {
  description = "Maximum number of replicas for autoscaling"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "autoscaling_target_cpu_utilization" {
  description = "Target CPU utilization percentage for autoscaling"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "autoscaling_target_memory_utilization" {
  description = "Target memory utilization percentage for autoscaling"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

# Security Configuration Variables
variable "security_context_run_as_non_root" {
  description = "Run container as non-root user"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "security_context_run_as_user" {
  description = "User ID to run the container"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "security_context_run_as_group" {
  description = "Group ID to run the container"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "security_context_fs_group" {
  description = "File system group ID"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "security_context_allow_privilege_escalation" {
  description = "Allow privilege escalation"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "security_context_read_only_root_filesystem" {
  description = "Mount root filesystem as read-only"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "security_context_capabilities_drop" {
  description = "List of capabilities to drop"
  type        = list(string)
  default     = []  # Use Helm values file default if not specified
}

variable "security_context_capabilities_add" {
  description = "List of capabilities to add"
  type        = list(string)
  default     = []  # Use Helm values file default if not specified
}

# Network Policy Configuration Variables
variable "network_policy_enabled" {
  description = "Enable network policy"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "network_policy_ingress_enabled" {
  description = "Enable ingress rules in network policy"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "network_policy_egress_enabled" {
  description = "Enable egress rules in network policy"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

# RBAC Configuration Variables
variable "rbac_enabled" {
  description = "Enable RBAC resources"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

# Pod Disruption Budget Variables
variable "pod_disruption_budget_enabled" {
  description = "Enable Pod Disruption Budget"
  type        = bool
  default     = null  # Use Helm values file default if not specified
}

variable "pod_disruption_budget_min_available" {
  description = "Minimum available pods in PDB"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

variable "pod_disruption_budget_max_unavailable" {
  description = "Maximum unavailable pods in PDB"
  type        = string
  default     = ""  # Use Helm values file default if not specified
}

# Application Configuration Variables
variable "app_container_port" {
  description = "Container port for the application"
  type        = number
  default     = null  # Use Helm values file default if not specified
}

variable "app_env_variables" {
  description = "Additional environment variables for the application"
  type        = map(string)
  default     = {}  # Use Helm values file default if not specified
}

variable "secret_key" {
  description = "Application secret key (leave empty to auto-generate)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "db_password" {
  description = "Database password (leave empty to auto-generate)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "api_base_url" {
  description = "API base URL (optional override)"
  type        = string
  default     = ""
}

variable "log_level" {
  description = "Application log level (optional override)"
  type        = string
  default     = ""

  validation {
    condition     = var.log_level == "" || contains(["DEBUG", "INFO", "WARNING", "ERROR"], var.log_level)
    error_message = "Log level must be one of: DEBUG, INFO, WARNING, ERROR."
  }
}

variable "max_connections" {
  description = "Maximum database connections (optional override)"
  type        = string
  default     = ""
}