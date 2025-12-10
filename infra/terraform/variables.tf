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
    registry         = optional(string)          # Override registry for this app (highest precedence)
    tag_prefix       = optional(string)          # Override tag prefix for this app (highest precedence)
    replicas         = optional(number)          # Override replica count
    enabled          = optional(bool)            # Enable/disable application
    env_variables    = optional(map(string), {}) # Additional env vars
    secrets          = optional(map(string), {}) # Override secrets
  }))
  default = []
}

