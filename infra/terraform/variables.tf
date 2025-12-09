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

variable "app_replicas" {
  description = "Number of application replicas"
  type        = number
  default     = 1
}

variable "app_image_repository" {
  description = "Docker image repository for the application"
  type        = string
  default     = "mytms"
}

variable "app_image_tag" {
  description = "Docker image tag for the application"
  type        = string
  default     = "1.0"
}

variable "app_image_pullpolicy" {
  description = "Docker image pull policy for the application"
  type        = string
  default     = "Never"

  validation {
    condition     = contains(["Always", "IfNotPresent", "Never"], var.app_image_pullpolicy)
    error_message = "Image pull policy must be one of: Always, IfNotPresent, Never."
  }
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "NodePort"

  validation {
    condition     = contains(["ClusterIP", "NodePort", "LoadBalancer"], var.service_type)
    error_message = "Service type must be one of: ClusterIP, NodePort, LoadBalancer."
  }
}

variable "service_port" {
  description = "Service port"
  type        = number
  default     = 8080
}

variable "service_node_port" {
  description = "NodePort for the service (only used when service_type is NodePort)"
  type        = number
  default     = 30090

  validation {
    condition     = var.service_node_port >= 30000 && var.service_node_port <= 32767
    error_message = "NodePort must be between 30000 and 32767."
  }
}

variable "ingress_enabled" {
  description = "Enable ingress"
  type        = bool
  default     = false
}

variable "ingress_host" {
  description = "Ingress host"
  type        = string
  default     = "my-tomorrows.local"
}

variable "ingress_hosts_path" {
  description = "Ingress host"
  type        = string
}

variable "ingress_hosts_path_type" {
  description = "Ingress host path type"
  type        = string
  default     = "Prefix"

  validation {
    condition     = contains(["Prefix", "ImplementationSpecific", "Exact"], var.ingress_hosts_path_type)
    error_message = "Ingress host path type must be one of: Prefix, ImplementationSpecific, Exact."
  }
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
  description = "API base URL"
  type        = string
  default     = "https://api.example.com"
}

variable "log_level" {
  description = "Application log level"
  type        = string
  default     = "INFO"

  validation {
    condition     = contains(["DEBUG", "INFO", "WARNING", "ERROR"], var.log_level)
    error_message = "Log level must be one of: DEBUG, INFO, WARNING, ERROR."
  }
}

variable "max_connections" {
  description = "Maximum database connections"
  type        = string
  default     = "100"
}