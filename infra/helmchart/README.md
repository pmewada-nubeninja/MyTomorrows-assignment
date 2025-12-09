# Umbrella Helm Chart Template

This is a reusable umbrella Helm chart template designed for deploying applications across multiple environments with consistent configuration patterns.

## 🎯 Features

- **Multi-Environment Support**: Deploy to dev, staging, and production with environment-specific configurations
- **Reusable Templates**: Common Kubernetes resources that can be customized per environment
- **Security Best Practices**: Built-in security contexts, network policies, and RBAC
- **Auto-scaling**: HPA configuration with environment-specific scaling policies
- **Health Checks**: Comprehensive liveness, readiness, and startup probes
- **Monitoring Ready**: Built-in support for Prometheus monitoring
- **Production Ready**: Pod disruption budgets, resource limits, and backup configurations

## 📁 Structure

```
infra/helmchart/
├── Chart.yaml                    # Chart metadata
├── values.yaml                   # Default values template
├── values-dev.yaml              # Development environment overrides
├── values-staging.yaml          # Staging environment overrides  
├── values-prod.yaml            # Production environment overrides
├── templates/
│   ├── _helpers.tpl            # Template helpers
│   ├── configmap.yaml          # Configuration management
│   ├── deployment.yaml         # Application deployment
│   ├── service.yaml           # Service configuration
│   ├── ingress.yaml           # Ingress configuration
│   ├── secret.yaml            # Secrets management
│   ├── serviceaccount.yaml    # RBAC service account
│   ├── namespace.yaml         # Namespace creation
│   ├── hpa.yaml              # Horizontal Pod Autoscaler
│   └── tests/
│       └── test-connection.yaml
└── README.md                   # This file
```

## 🚀 Quick Start

### Prerequisites

- Kubernetes cluster (v1.19+)
- Helm 3.x
- Docker registry access

### 1. Customize for Your Application

Update the default values in `values.yaml`:

```yaml
application:
  name: "your-app-name"
  version: "1.0.0"

image:
  repository: "your-registry/your-app"
```

### 2. Deploy to Development

```bash
# Deploy to development environment
helm upgrade --install my-app . \\
  --namespace my-app-dev \\
  --create-namespace \\
  --values values-dev.yaml

# Verify deployment
kubectl get pods -n my-app-dev
kubectl get svc -n my-app-dev
```

### 3. Deploy to Staging

```bash
# Deploy to staging environment
helm upgrade --install my-app . \\
  --namespace my-app-staging \\
  --create-namespace \\
  --values values-staging.yaml

# Check autoscaling
kubectl get hpa -n my-app-staging
```

### 4. Deploy to Production

```bash
# Deploy to production environment
helm upgrade --install my-app . \\
  --namespace my-app-prod \\
  --create-namespace \\
  --values values-prod.yaml

# Verify high availability
kubectl get pods -n my-app-prod
kubectl get pdb -n my-app-prod
```

## 🔧 Environment-Specific Configurations

### Development (`values-dev.yaml`)
- **Replicas**: 1 (resource efficient)
- **Resources**: Low CPU/memory limits
- **Image Pull**: Always (for latest development builds)
- **Logging**: DEBUG level
- **Autoscaling**: Disabled
- **Security**: Basic security context

### Staging (`values-staging.yaml`)
- **Replicas**: 2 (medium availability)
- **Resources**: Medium CPU/memory limits
- **Image Pull**: IfNotPresent
- **Logging**: INFO level
- **Autoscaling**: Enabled (2-5 replicas)
- **Security**: Enhanced security with network policies
- **TLS**: Staging certificates

### Production (`values-prod.yaml`)
- **Replicas**: 3 (high availability)
- **Resources**: High CPU/memory limits
- **Image Pull**: IfNotPresent with specific tags
- **Logging**: ERROR level only
- **Autoscaling**: Aggressive (3-10 replicas)
- **Security**: Strict security context + network policies
- **TLS**: Production certificates
- **Monitoring**: Full monitoring stack
- **Backup**: Automated backup configuration

## 🛠️ Customization

### Adding New Environments

1. Create a new values file (e.g., `values-test.yaml`)
2. Override the necessary values:

```yaml
global:
  environment: "test"
  namespace: "my-app-test"

replicaCount: 1
# ... other overrides
```

### Adding New Applications

1. Fork this chart or use it as a template
2. Update `values.yaml` with your application specifics
3. Modify environment-specific files as needed

### Custom Configuration

Override any default value by specifying it in your environment files:

```yaml
# Custom resource limits
resources:
  limits:
    cpu: 2000m
    memory: 2Gi
  requests:
    cpu: 1000m
    memory: 1Gi

# Custom health check paths
livenessProbe:
  httpGet:
    path: /custom-health
    port: 8080
```

## 📊 Monitoring Integration

### Prometheus Integration

The chart includes ServiceMonitor configuration for Prometheus:

```yaml
monitoring:
  enabled: true
  serviceMonitor:
    enabled: true
    namespace: "monitoring"
    interval: "30s"
    path: "/metrics"
```

### Grafana Dashboards

Compatible with standard Kubernetes and application dashboards.

## 🔒 Security Features

- **Non-root containers**: All containers run as non-root user
- **Read-only filesystem**: Root filesystem is read-only
- **Security contexts**: Comprehensive security contexts applied
- **Network policies**: Ingress/egress traffic control
- **RBAC**: Minimal required permissions
- **Secret management**: Kubernetes secrets for sensitive data

## 🔄 CI/CD Integration

### GitLab CI Example

```yaml
stages:
  - deploy-dev
  - deploy-staging
  - deploy-prod

deploy-dev:
  stage: deploy-dev
  script:
    - helm upgrade --install my-app ./infra/helmchart \\
        --namespace my-app-dev \\
        --values ./infra/helmchart/values-dev.yaml
  only:
    - develop

deploy-prod:
  stage: deploy-prod
  script:
    - helm upgrade --install my-app ./infra/helmchart \\
        --namespace my-app-prod \\
        --values ./infra/helmchart/values-prod.yaml
  only:
    - main
  when: manual
```

### GitHub Actions Example

```yaml
name: Deploy Application

on:
  push:
    branches: [main, develop]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to Development
        if: github.ref == 'refs/heads/develop'
        run: |
          helm upgrade --install my-app ./infra/helmchart \\
            --values ./infra/helmchart/values-dev.yaml
            
      - name: Deploy to Production
        if: github.ref == 'refs/heads/main'
        run: |
          helm upgrade --install my-app ./infra/helmchart \\
            --values ./infra/helmchart/values-prod.yaml
```

## 🧪 Testing

### Helm Template Testing

```bash
# Validate templates
helm template my-app . --values values-dev.yaml
helm template my-app . --values values-prod.yaml

# Lint chart
helm lint .

# Dry run deployment
helm upgrade --install my-app . \\
  --values values-dev.yaml \\
  --dry-run
```

### Kubernetes Testing

```bash
# Run chart tests
helm test my-app

# Check pod status
kubectl get pods -l app.kubernetes.io/name=my-tomorrows-app

# Check configuration
kubectl describe configmap my-app-config
```

## 🔍 Troubleshooting

### Common Issues

1. **Image Pull Errors**
   - Check image repository and tag
   - Verify image pull secrets if using private registry

2. **Health Check Failures**
   - Verify health endpoint is accessible
   - Check port configuration
   - Review probe timing settings

3. **Resource Limits**
   - Monitor pod resource usage
   - Adjust limits in environment-specific values

4. **Networking Issues**
   - Check service and ingress configuration
   - Verify network policies if enabled

### Debugging Commands

```bash
# Pod logs
kubectl logs -l app.kubernetes.io/name=my-tomorrows-app

# Describe resources
kubectl describe deployment my-app
kubectl describe service my-app
kubectl describe ingress my-app

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 📈 Best Practices

1. **Use specific image tags in production**
2. **Set appropriate resource limits**
3. **Enable monitoring and logging**
4. **Implement proper health checks**
5. **Use secrets for sensitive data**
6. **Regular security updates**
7. **Test deployments in staging first**

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Test your changes across environments
4. Update documentation
5. Submit a pull request

## 📝 License

This umbrella chart template is provided under the MIT License.