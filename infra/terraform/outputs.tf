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

output "service_type" {
  description = "The type of the Kubernetes service"
  value       = var.service_type
}

output "service_port" {
  description = "The port of the Kubernetes service"
  value       = var.service_port
}

output "service_node_port" {
  description = "The NodePort of the Kubernetes service (if applicable)"
  value       = var.service_type == "NodePort" ? var.service_node_port : null
}

output "application_url" {
  description = "The URL to access the application"
  value       = var.service_type == "NodePort" ? "http://localhost:${var.service_node_port}" : var.ingress_enabled ? "http://${var.ingress_host}" : "Use 'kubectl port-forward' to access the application"
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