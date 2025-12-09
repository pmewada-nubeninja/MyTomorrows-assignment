# Generate random passwords when variables are empty
resource "random_password" "secret_key" {
  length  = 32
  special = true
  count   = var.secret_key == "" ? 1 : 0
}

resource "random_password" "db_password" {
  length  = 24
  special = true
  count   = var.db_password == "" ? 1 : 0
}

# Create namespace
resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
  }
}

# Deploy the Helm chart
resource "helm_release" "my_tomorrows_app" {
  name         = var.release_name
  namespace    = kubernetes_namespace.app_namespace.metadata[0].name
  chart        = var.chart_path
  force_update = true

  set {
    name  = "replicaCount"
    value = var.app_replicas
  }

  set {
    name  = "image.repository"
    value = var.app_image_repository
  }

  set {
    name  = "image.tag"
    value = var.app_image_tag
  }

  set {

    name  = "image.pullPolicy"
    value = var.app_image_pullpolicy
  }

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "service.port"
    value = var.service_port
  }

  set {
    name  = "service.nodePort"
    value = var.service_node_port
  }

  set {
    name  = "ingress.enabled"
    value = var.ingress_enabled
  }

  set {
    name  = "ingress.hosts[0].host"
    value = var.ingress_host
  }

  set {
    name  = "ingress.hosts[0].paths[0].path"
    value = var.ingress_hosts_path
  }

  set {
    name  = "ingress.hosts[0].paths[0].pathType"
    value = var.ingress_hosts_path_type
  }

  set_sensitive {
    name  = "secrets.SECRET_KEY"
    value = var.secret_key != "" ? var.secret_key : random_password.secret_key[0].result
  }

  set_sensitive {
    name  = "secrets.DB_PASSWORD"
    value = var.db_password != "" ? var.db_password : random_password.db_password[0].result
  }

  set {
    name  = "configmap.API_BASE_URL"
    value = var.api_base_url
  }

  set {
    name  = "configmap.LOG_LEVEL"
    value = var.log_level
  }

  set {
    name  = "configmap.MAX_CONNECTIONS"
    value = var.max_connections
  }

  # Wait for deployment to be ready
  wait    = true
  timeout = 300

  depends_on = [kubernetes_namespace.app_namespace]
}