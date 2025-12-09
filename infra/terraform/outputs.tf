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
    method   = "NodePort"
    url      = "http://localhost:30080"
    commands = [
      "curl http://localhost:30080/health",
      "curl http://localhost:30080/",
      "curl http://localhost:30080/config"
    ]
  } : {
    method   = "kubectl port-forward"
    url      = "http://localhost:8080 (after port-forward)"
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