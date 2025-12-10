output "namespace" {
  description = "The Kubernetes namespace where the application is deployed"
  value       = kubernetes_namespace.app_namespace.metadata[0].name
}

output "release_name" {
  description = "The Helm release name"
  value       = helm_release.my_tomorrows_app.name
}

output "release_status" {
  description = "The status of the Helm release"
  value       = helm_release.my_tomorrows_app.status
}

output "release_version" {
  description = "The version of the Helm release"
  value       = helm_release.my_tomorrows_app.version
}

output "environment" {
  description = "The environment this deployment is for"
  value       = var.environment
}

output "chart_path" {
  description = "The path to the Helm chart used"
  value       = var.chart_path
}

output "values_file" {
  description = "The values file used for this environment"
  value       = "values-${var.environment}.yaml"
}

output "access_instructions" {
  description = "Instructions to access the application"
  value = var.environment == "dev" ? {
    method = "NodePort"
    url    = "http://localhost:30080"
    commands = [
      "curl http://localhost:30080/health",
      "curl http://localhost:30080/",
      "curl http://localhost:30080/config"
    ]
    } : {
    method = "kubectl port-forward"
    url    = "http://localhost:8080 (after port-forward)"
    commands = [
      "kubectl port-forward svc/my-tomorrows-app 8080:80 -n ${kubernetes_namespace.app_namespace.metadata[0].name}",
      "curl http://localhost:8080/health",
      "curl http://localhost:8080/"
    ]
  }
}



# ==========================================
# MULTI-APPLICATION DEPLOYMENT INFO
# ==========================================

output "managed_applications" {
  description = "List of applications managed by Terraform"
  value = [
    for idx, app in var.applications : {
      index        = idx
      name         = app.name
      image        = app.image_repository != null ? "${app.image_repository}:${app.image_tag}" : "using-helm-default"
      enabled      = app.enabled
      registry     = app.registry != null ? app.registry : (var.global_image_overrides.registry != null ? var.global_image_overrides.registry : "using-helm-default")
      tag_prefix   = app.tag_prefix != null ? app.tag_prefix : (var.global_image_overrides.tag_prefix != null ? var.global_image_overrides.tag_prefix : "using-helm-default")
      replicas     = app.replicas
      env_count    = length(app.env_variables)
      secret_count = length(app.secrets)
    }
  ]
}

output "terraform_overrides_summary" {
  description = "Summary of Terraform overrides applied"
  value = {
    total_applications     = length(var.applications)
    managing_app_state     = var.manage_application_state
    global_registry        = var.global_image_overrides.registry
    total_env_overrides    = sum([for app in var.applications : length(app.env_variables)])
    total_secret_overrides = sum([for app in var.applications : length(app.secrets)])
  }
}