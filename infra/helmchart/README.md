# Multi-Application Umbrella Helm Chart

A production-ready umbrella Helm chart for deploying multiple applications with shared infrastructure patterns across different environments.

## Overview

| Property | Value |
|----------|-------|
| **Chart Version** | `0.2.0` |
| **Applications Supported** | 2-4 applications |
| **Environments** | Development, Staging, Production |
| **Security Standard** | Pod Security Standards (Restricted) |
| **Kubernetes Version** | `1.24+` |

## Chart Structure

```
helmchart/
├── Chart.yaml                 # Chart metadata
├── values.yaml               # Base template
├── values-dev.yaml           # Dev environment (2 apps, NodePort)
├── values-staging.yaml       # Staging (3 apps, Nginx Ingress)
├── values-prod.yaml          # Production (4 apps, AWS ALB)
└── templates/
    ├── deployment.yaml       # Application deployments
    ├── service.yaml         # Kubernetes services  
    ├── ingress.yaml         # Ingress configuration
    ├── configmap.yaml       # Application configuration
    ├── secret.yaml          # Sensitive data management
    ├── hpa.yaml             # Horizontal Pod Autoscaler
    ├── networkpolicy.yaml   # Network security
    └── rbac.yaml           # Role-based access control
```

## Environment Configurations

### Development (values-dev.yaml)
- **Applications**: 2 (API + Admin)
- **Access**: NodePort (localhost:30080, 30081)
- **Features**: Debug logging, single replicas
- **Security**: Basic Pod Security Standards

```bash
helm install dev-apps . -f values-dev.yaml
curl http://localhost:30080/health
```

### Staging (values-staging.yaml)  
- **Applications**: 3 (API + Admin + Worker)
- **Access**: Nginx Ingress with LoadBalancer
- **Features**: SSL/TLS, autoscaling (2-5 replicas)
- **Security**: Network policies, enhanced monitoring

```bash
helm install staging-apps . -f values-staging.yaml
curl https://staging-api.mytomorrows.com/health
```

### Production (values-prod.yaml)
- **Applications**: 4 (API + Admin + Worker + Monitoring)
- **Access**: AWS ALB with Certificate Manager
- **Features**: Full HA, strict autoscaling (3-10 replicas)
- **Security**: Restricted Pod Security, comprehensive policies

```bash
helm install prod-apps . -f values-prod.yaml
curl https://api.mytomorrows.com/health
```

## Key Features

### Multi-Application Architecture
```yaml
applications:
  - name: "api-service"
    enabled: true
    image:
      repository: "mytomorrows/api"
      tag: "v1.0.0"
    service:
      port: 80
      targetPort: 8080
    autoscaling:
      enabled: true
      minReplicas: 2
      maxReplicas: 10
```

### Security-First Design
- **Pod Security Standards**: Restricted enforcement
- **Network Policies**: Ingress/egress traffic control
- **RBAC**: Minimal service account permissions
- **Security Contexts**: Non-root, read-only filesystem

### Production Features
- **Health Checks**: Liveness, readiness, startup probes
- **Autoscaling**: CPU/memory-based HPA
- **High Availability**: Pod Disruption Budgets
- **Monitoring**: Prometheus metrics, structured logging

## Quick Deployment

```bash
# 1. Development
helm install dev . -f values-dev.yaml

# 2. Staging
helm install staging . -f values-staging.yaml

# 3. Production
helm install prod . -f values-prod.yaml

# 4. Verify deployment
kubectl get pods,svc,ingress
helm test <release-name>
```

## Configuration Management

### Global Settings
```yaml
global:
  environment: "production"
  registry: "docker.io"
  namespace: "my-app"
```

### Per-Application Customization
```yaml
applications:
  - name: "custom-app"
    image:
      repository: "myapp/service"
      tag: "v2.0.0"
    resources:
      requests:
        cpu: 200m
        memory: 256Mi
    config:
      LOG_LEVEL: "DEBUG"
    secrets:
      API_KEY: "base64encodedkey"
```

## Validation & Testing

```bash
# Template validation
helm template test . -f values-prod.yaml --dry-run

# Resource validation
helm lint . -f values-prod.yaml

# Connectivity tests
helm test <release-name>

# Health checks
kubectl get pods | grep -v Running
```

## Architecture Highlights

🔸 **Multi-Environment**: Progressive deployment from dev to production  
🔸 **Security**: Defense-in-depth with Pod Security Standards  
🔸 **Scalability**: Horizontal Pod Autoscaling with resource management  
🔸 **Reliability**: Health checks, disruption budgets, monitoring  
🔸 **Flexibility**: Per-application customization with global defaults  

## Production Readiness Checklist

✅ **Infrastructure**: Kubernetes 1.24+, Ingress Controller, Metrics Server  
✅ **Security**: Pod Security Standards, Network Policies, RBAC  
✅ **Monitoring**: Prometheus metrics, health endpoints  
✅ **Deployment**: Environment-specific configurations  
✅ **Validation**: Template testing, resource validation  

---

**Chart Version**: 0.2.0 | **Status**: Production Ready | **Applications**: 2-4 per environment