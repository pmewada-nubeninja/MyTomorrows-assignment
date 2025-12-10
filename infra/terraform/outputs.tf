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

output "secret_generation_info" {
  description = "Information about secret generation (non-sensitive)"
  value = {
    secret_key_auto_generated  = length(random_password.secret_key) > 0
    db_password_auto_generated = length(random_password.db_password) > 0
    secret_key_source          = length(random_password.secret_key) > 0 ? "auto-generated" : "user-provided"
    db_password_source         = length(random_password.db_password) > 0 ? "auto-generated" : "user-provided"
  }
}

# ==========================================
# MULTI-APPLICATION DEPLOYMENT INFO
# ==========================================

output "deployment_mode" {
  description = "Whether using single-app (legacy) or multi-app mode"
  value       = length(var.applications) > 0 ? "multi-app" : "single-app-legacy"
}

output "managed_applications" {
  description = "List of applications managed by Terraform"
  value = length(var.applications) > 0 ? [
    for idx, app in var.applications : {
      index        = idx
      name         = app.name
      enabled      = app.enabled
      image        = app.image_repository != null ? "${app.image_repository}:${app.image_tag}" : "using-helm-default"
      replicas     = app.replicas
      env_count    = length(app.env_variables)
      secret_count = length(app.secrets)
    }
    ] : [
    {
      index        = 0
      name         = "legacy-first-app"
      enabled      = true
      image        = var.app_image_repository != "" ? "${var.app_image_repository}:${var.app_image_tag}" : "using-helm-default"
      replicas     = var.app_replicas
      env_count    = length(var.app_env_variables)
      secret_count = 2 # SECRET_KEY and DB_PASSWORD
    }
  ]
}

output "terraform_overrides_summary" {
  description = "Summary of Terraform overrides applied"
  value = {
    total_applications     = length(var.applications) > 0 ? length(var.applications) : 1
    managing_app_state     = var.manage_application_state
    global_registry        = var.global_image_overrides.registry
    total_env_overrides    = length(var.applications) > 0 ? sum([for app in var.applications : length(app.env_variables)]) : length(var.app_env_variables)
    total_secret_overrides = length(var.applications) > 0 ? sum([for app in var.applications : length(app.secrets)]) : 2
    legacy_overrides_count = length(var.applications) == 0 ? (
      (var.app_image_repository != "" ? 1 : 0) +
      (var.app_image_tag != "" ? 1 : 0) +
      (var.app_replicas != null ? 1 : 0) +
      (var.api_base_url != "" ? 1 : 0) +
      (var.log_level != "" ? 1 : 0) +
      (var.max_connections != "" ? 1 : 0)
    ) : 0
  }
}