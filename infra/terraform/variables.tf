# ==========================================
# GLOBAL CONFIGURATION
# ==========================================

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

# Global application management
variable "manage_application_state" {
  description = "Whether to manage application enabled/disabled state via Terraform"
  type        = bool
  default     = false
}

variable "global_image_overrides" {
  description = "Global image settings to apply to all applications"
  type = object({
    registry    = optional(string)
    tag_prefix  = optional(string)
    pull_policy = optional(string)
  })
  default = {}
}

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

# ==========================================
# APPLICATION SPECIFIC CONFIGURATION
# ==========================================

# Multi-Application Management Configuration
variable "applications" {
  description = "List of applications to deploy and manage via Terraform overrides"
  type = list(object({
    name             = string                    # Application name (must match Helm values)
    image_repository = optional(string)          # Override image repository
    image_tag        = optional(string)          # Override image tag
    replicas         = optional(number)          # Override replica count
    enabled          = optional(bool)            # Enable/disable application
    env_variables    = optional(map(string), {}) # Additional env vars
    secrets          = optional(map(string), {}) # Override secrets
  }))
  default = []
}

# Legacy single-app variables (kept for backward compatibility)
variable "app_image_repository" {
  description = "Docker image repository for the first application (legacy)"
  type        = string
  default     = "" # Use Helm values file default if not specified
}

variable "app_image_tag" {
  description = "Docker image tag for the first application (legacy)"
  type        = string
  default     = "" # Use Helm values file default if not specified
}

variable "app_replicas" {
  description = "Number of replicas for first application (legacy)"
  type        = number
  default     = null # Use Helm values file default if not specified
}

# Environment-specific overrides (optional)
variable "app_env_variables" {
  description = "Additional environment variables for the application"
  type        = map(string)
  default     = {} # Use Helm values file default if not specified
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