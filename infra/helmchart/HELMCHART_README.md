# 🚀 Multi-Application Umbrella Helm Chart

## 🎯 Overview

This is a **production-ready, enterprise-grade umbrella Helm chart** designed for deploying and managing multiple applications with shared infrastructure components across different environments. Built for scalability, security, and operational excellence.

### ✨ Key Features

| Feature | Description | Production Ready |
|---------|-------------|------------------|
| **🔄 Multi-App Deployment** | Deploy 2+ applications with a single chart | ✅ |
| **🌍 Environment Management** | Dev (2 apps), Staging (3 apps), Production (4 apps) | ✅ |
| **🔐 Security-First Design** | RBAC, NetworkPolicy, Pod Security Standards | ✅ |
| **📈 Auto-Scaling** | HPA with CPU/memory metrics per application | ✅ |
| **🛡️ High Availability** | Pod Disruption Budgets, health checks, monitoring | ✅ |
| **☁️ Cloud Integration** | AWS ALB, nginx ingress, cert-manager support | ✅ |
| **🔧 Per-App Customization** | Individual resources, configs, ingress, scaling | ✅ |
| **📊 Observability** | Prometheus metrics, structured logging, health endpoints | ✅ |

## 📊 Chart Specifications

| Property | Value | Details |
|----------|-------|---------|
| **Chart Version** | 0.2.0 | Production umbrella chart |
| **App Version** | 2.0.0 | Multi-application support |
| **Chart Type** | Application | Umbrella chart for multiple apps |
| **Kubernetes Resources** | 13 templates | Complete application lifecycle |
| **Environment Configs** | 5 values files | Dev, staging, production + samples |
| **Security Standards** | Restricted | Pod Security Standards enforced |

## 📁 Chart Architecture

```
📦 multi-app-umbrella-chart/
├── 📋 Chart.yaml                        # Chart metadata and versioning
├── 🔧 values.yaml                       # Default values and documentation
├── 📖 values-complete-sample.yaml       # Complete configuration reference
├── 🔨 values-dev.yaml                   # Development (2 apps) - NodePort
├── 🔄 values-staging.yaml               # Staging (3 apps) - Nginx + LB  
├── 🏭 values-production.yaml            # Production (4 apps) - AWS ALB + TLS
├── 📚 MULTI_APP_README.md               # Detailed usage and migration guide
├── 🛡️ SECURITY.md                       # Security best practices
└── 📂 templates/
    ├── 🔧 _helpers.tpl                  # Template helper functions
    ├── 🏠 namespace.yaml                # Dedicated namespace creation
    ├── 👤 serviceaccount.yaml           # Service account for all pods
    ├── 🔐 rbac.yaml                     # Role-based access control
    ├── 🌐 networkpolicy.yaml            # Network security policies
    ├── 📦 deployment.yaml               # Application deployments (per app)
    ├── 🔗 service.yaml                  # Kubernetes services (per app)
    ├── 📝 configmap.yaml                # Configuration maps (per app)
    ├── 🔒 secret.yaml                   # Application secrets (per app)
    ├── 🌍 ingress.yaml                  # Ingress rules (per app)
    ├── 📈 hpa.yaml                      # Horizontal Pod Autoscaler (per app)
    ├── 🛡️ poddisruptionbudget.yaml      # Pod disruption budget
    ├── 📋 NOTES.txt                     # Multi-environment deployment instructions
    └── 🧪 tests/
        └── test-connection.yaml         # Connection tests (per app)
```

## 🚀 Quick Start Guide

### 🔨 Development Environment (2 Applications)
```bash
# Deploy API service + Admin dashboard with local NodePort access
helm install dev-apps . -f values-dev.yaml

# Access applications locally
curl http://localhost:30080/health    # API service health check
curl http://localhost:30081/         # Admin dashboard
```

### 🔄 Staging Environment (3 Applications)  
```bash
# Deploy API + Admin + Worker with LoadBalancer and nginx ingress
helm install staging-apps . -f values-staging.yaml

# Access via ingress (configure DNS)
curl https://staging-api.mytomorrows.com/health
curl https://staging-admin.mytomorrows.com/
```

### 🏭 Production Environment (4 Applications)
```bash
# Deploy full suite: API + Admin + Worker + Monitoring with AWS ALB
helm install prod-apps . -f values-production.yaml

# Production endpoints with TLS
curl https://api.mytomorrows.com/health
curl https://admin.mytomorrows.com/
curl https://monitoring.mytomorrows.com/metrics
```

## 🏗️ Multi-Application Architecture

### 📊 Environment Overview

| Environment | Apps | Access Method | Key Features |
|-------------|------|---------------|--------------|
| **🔨 Development** | 2 | `NodePort (30080, 30081)` | Debug logging, single replicas, local testing |
| **🔄 Staging** | 3 | `Nginx Ingress + LoadBalancer` | SSL/TLS, autoscaling, pre-production testing |
| **🏭 Production** | 4 | `AWS ALB + Certificate Manager` | HA, monitoring, strict security, performance tuning |

### ⚙️ Configuration Hierarchy

The chart follows a **three-tier configuration pattern** for maximum flexibility:

```yaml
# 🌐 1. GLOBAL CONFIGURATION (Environment-wide settings)
global:
  environment: "production"                # Environment identifier
  registry: "docker.io"                   # Default image registry
  namespace: "my-app"                      # Target Kubernetes namespace
  clusterDomain: "cluster.local"          # Kubernetes cluster domain
  monitoring:
    enabled: true                          # Global monitoring toggle
    scrapeInterval: "30s"                  # Prometheus scrape interval

# 🎯 2. DEFAULT APP CONFIGURATION (Shared across all applications)
defaultApp:
  replicaCount: 1                          # Default replica count
  image:
    pullPolicy: IfNotPresent               # Image pull policy
  service:
    type: ClusterIP                        # Default service type
    port: 80                               # Default service port
  security:
    securityContext:
      runAsUser: 10001                     # Non-root user ID
      runAsNonRoot: true                   # Enforce non-root execution
      readOnlyRootFilesystem: true         # Read-only filesystem
      allowPrivilegeEscalation: false      # Prevent privilege escalation
      capabilities:
        drop: ["ALL"]                      # Drop all capabilities
  resources:
    requests:
      cpu: 100m                            # Minimum CPU request
      memory: 128Mi                        # Minimum memory request
    limits:
      cpu: 200m                            # Maximum CPU limit
      memory: 256Mi                        # Maximum memory limit

# 🚀 3. INDIVIDUAL APPLICATIONS (Application-specific overrides)
applications:
  - name: "api-service"                    # Application identifier
    enabled: true                          # Enable/disable deployment
    image:
      repository: "mytomorrows/api"        # Application image
      tag: "v1.2.3"                       # Specific image tag
    service:
      type: ClusterIP                      # Override service type
      port: 80                             # Application port
      targetPort: 8080                     # Container target port
    app:
      containerPort: 8080                  # Container listening port
      healthCheck:
        enabled: true                      # Enable health checks
        liveness:
          path: "/health"                  # Liveness probe path
          initialDelaySeconds: 30          # Initial delay before probe
        readiness:
          path: "/ready"                   # Readiness probe path
          initialDelaySeconds: 5           # Initial delay before probe
    config:                                # Environment variables
      API_URL: "https://api.example.com"
      LOG_LEVEL: "INFO"
      CACHE_TTL: "3600"
    secrets:                               # Sensitive data (base64 encoded)
      DB_PASSWORD: "base64encodedpassword"
      API_KEY: "base64encodedapikey"
    ingress:
      enabled: true                        # Enable ingress
      host: "api.mytomorrows.com"          # Domain name
      path: "/api"                         # URL path
      tls:
        enabled: true                      # Enable TLS
        secretName: "api-tls-cert"         # Certificate secret
    autoscaling:
      enabled: true                        # Enable HPA
      minReplicas: 3                       # Minimum replicas
      maxReplicas: 10                      # Maximum replicas
      targetCPUUtilizationPercentage: 70   # CPU scaling threshold
      targetMemoryUtilizationPercentage: 80 # Memory scaling threshold
    resources:                             # Resource overrides
      requests:
        cpu: 200m                          # Application-specific CPU
        memory: 256Mi                      # Application-specific memory
      limits:
        cpu: 500m                          # Application-specific CPU limit
        memory: 512Mi                      # Application-specific memory limit
```

## 🌍 Environment Configurations

### 🔨 Development Environment (`values-dev.yaml`)

**Purpose**: Local development and testing with simplified access patterns.

```bash
# Deploy development environment
helm install dev-apps . -f values-dev.yaml

# Features enabled:
# ✅ NodePort services (30080, 30081) for local access
# ✅ Debug logging levels
# ✅ Single replica deployments
# ✅ Development image tags
# ✅ Simplified security contexts
# ✅ Local storage for testing

# Access applications locally:
curl http://localhost:30080/health    # api-service health check
curl http://localhost:30081/         # admin-dashboard main page

# Applications deployed:
# 1. api-service       -> NodePort 30080
# 2. admin-dashboard   -> NodePort 30081
```

### 🔄 Staging Environment (`values-staging.yaml`)

**Purpose**: Pre-production testing with production-like infrastructure.

```bash
# Deploy staging environment
helm install staging-apps . -f values-staging.yaml

# Features enabled:
# ✅ Nginx Ingress Controller with LoadBalancer
# ✅ SSL/TLS termination with Let's Encrypt
# ✅ Horizontal Pod Autoscaling (HPA)
# ✅ Multiple replicas for high availability
# ✅ Resource limits and monitoring
# ✅ Network policies for security

# Access via ingress (configure DNS to point to LoadBalancer IP):
curl https://staging-api.mytomorrows.com/health
curl https://staging-admin.mytomorrows.com/
curl https://staging-worker.mytomorrows.com/status

# Applications deployed:
# 1. api-service       -> staging-api.mytomorrows.com/api
# 2. admin-dashboard   -> staging-admin.mytomorrows.com/
# 3. worker-service    -> staging-worker.mytomorrows.com/status
```

### 🏭 Production Environment (`values-production.yaml`)

**Purpose**: Full production deployment with enterprise-grade features.

```bash
# Deploy production environment
helm install prod-apps . -f values-production.yaml

# Features enabled:
# ✅ AWS Application Load Balancer (ALB) integration
# ✅ AWS Certificate Manager for TLS
# ✅ Advanced autoscaling with multiple metrics
# ✅ Pod Disruption Budgets for availability
# ✅ Enhanced security with Pod Security Standards
# ✅ Comprehensive monitoring and observability
# ✅ Resource quotas and network policies

# Production endpoints with full TLS:
curl https://api.mytomorrows.com/health
curl https://admin.mytomorrows.com/
curl https://worker.mytomorrows.com/status  
curl https://monitoring.mytomorrows.com/metrics

# Applications deployed:
# 1. api-service       -> api.mytomorrows.com/api
# 2. admin-dashboard   -> admin.mytomorrows.com/
# 3. worker-service    -> worker.mytomorrows.com/status
# 4. monitoring-service -> monitoring.mytomorrows.com/metrics
```

### 📊 Environment Comparison

| Feature | Development | Staging | Production |
|---------|-------------|---------|------------|
| **Applications** | 2 (API + Admin) | 3 (+ Worker) | 4 (+ Monitoring) |
| **Access Method** | NodePort (local) | Nginx Ingress | AWS ALB |
| **TLS/SSL** | ❌ Disabled | ✅ Let's Encrypt | ✅ AWS ACM |
| **Autoscaling** | ❌ Single replica | ✅ 2-5 replicas | ✅ 3-10 replicas |
| **Resource Limits** | 🔸 Minimal | 🔸 Moderate | ✅ Strict |
| **Security Policies** | 🔸 Basic | ✅ Network Policies | ✅ Full Security |
| **Monitoring** | ❌ Basic logs | 🔸 Basic metrics | ✅ Full observability |
| **Health Checks** | ✅ Enabled | ✅ Enabled | ✅ Enhanced |
| **Pod Disruption Budget** | ❌ Disabled | ✅ Enabled | ✅ Strict |
| **Image Strategy** | `latest` tags | Version tags | Immutable tags |
# - Resource limits and HPA
# - Production image tags
# - Enhanced security settings
```

## 🔧 Application Features & Capabilities

### 📦 Per-Application Resources

Each enabled application automatically receives a complete Kubernetes deployment stack:

| Resource Type | Purpose | Per-App Customization |
|---------------|---------|----------------------|
| **🚀 Deployment** | Pod orchestration with replicas, health checks | ✅ Images, resources, env vars, scaling |
| **🔗 Service** | Internal/external connectivity | ✅ Type (ClusterIP/NodePort/LoadBalancer), ports |
| **📝 ConfigMap** | Non-sensitive configuration | ✅ Environment variables, config files |
| **🔒 Secret** | Sensitive data (base64 encoded) | ✅ Database passwords, API keys, certificates |
| **🌍 Ingress** | External HTTP(S) access | ✅ Hostnames, paths, TLS, annotations |
| **📈 HPA** | Horizontal Pod Autoscaler | ✅ Min/max replicas, CPU/memory thresholds |
| **🧪 Test Pod** | Connectivity validation | ✅ Custom test commands and endpoints |

### 🏥 Health Monitoring & Probes

Comprehensive health check configuration for each application:

```yaml
app:
  healthCheck:
    enabled: true
    liveness:                              # Liveness Probe (restart unhealthy pods)
      httpGet:
        path: "/health"                    # Health endpoint
        port: 8080                         # Container port
        httpHeaders:                       # Custom headers if needed
          - name: "Custom-Header"
            value: "HealthCheck"
      initialDelaySeconds: 30              # Wait before first check
      periodSeconds: 10                    # Check interval
      timeoutSeconds: 5                    # Timeout per check
      failureThreshold: 3                  # Failures before restart
      successThreshold: 1                  # Successes to recover
    readiness:                             # Readiness Probe (traffic routing)
      httpGet:
        path: "/ready"                     # Readiness endpoint
        port: 8080
      initialDelaySeconds: 5               # Initial delay
      periodSeconds: 5                     # Check frequency
      timeoutSeconds: 3                    # Timeout per check
      failureThreshold: 3                  # Failures before marking unready
    startup:                               # Startup Probe (slow-starting apps)
      httpGet:
        path: "/startup"                   # Startup endpoint
        port: 8080
      initialDelaySeconds: 10              # Initial delay
      periodSeconds: 10                    # Check interval
      timeoutSeconds: 5                    # Per-check timeout
      failureThreshold: 30                 # Max failures (30*10s = 5min)
```

### ⚡ Resource Management & Performance

Precise resource allocation per application:

```yaml
resources:
  requests:                                # Guaranteed resources
    cpu: 200m                             # 0.2 CPU cores minimum
    memory: 256Mi                          # 256 MB RAM minimum
    ephemeral-storage: 1Gi                 # Local storage minimum
  limits:                                  # Maximum allowed resources
    cpu: 1000m                            # 1.0 CPU cores maximum
    memory: 1Gi                           # 1 GB RAM maximum
    ephemeral-storage: 5Gi                # Local storage maximum

# Quality of Service (QoS) Classes:
# - Guaranteed: requests == limits (highest priority)
# - Burstable:  requests < limits (medium priority)  
# - BestEffort: no requests/limits (lowest priority)
```

### 🔄 Advanced Autoscaling

Multi-metric horizontal pod autoscaling:

```yaml
autoscaling:
  enabled: true                            # Enable HPA
  minReplicas: 3                          # Minimum pod count
  maxReplicas: 20                         # Maximum pod count
  targetCPUUtilizationPercentage: 70      # CPU scaling threshold
  targetMemoryUtilizationPercentage: 80   # Memory scaling threshold
  
  # Advanced metrics (requires metrics-server and custom metrics)
  behavior:                               # Scaling behavior control
    scaleDown:
      stabilizationWindowSeconds: 300     # Wait 5min before scale down
      policies:
        - type: Percent
          value: 10                       # Scale down max 10% of pods
          periodSeconds: 60              # Per minute
        - type: Pods  
          value: 2                       # Scale down max 2 pods
          periodSeconds: 60              # Per minute
    scaleUp:
      stabilizationWindowSeconds: 60      # Wait 1min before scale up
      policies:
        - type: Percent
          value: 50                      # Scale up max 50% of pods
          periodSeconds: 60              # Per minute
        - type: Pods
          value: 4                       # Scale up max 4 pods  
          periodSeconds: 60              # Per minute
```

### 🌐 Advanced Ingress Configuration

Production-ready ingress with multiple features:

```yaml
ingress:
  enabled: true
  className: "nginx"                      # Ingress controller class
  host: "api.mytomorrows.com"             # Primary hostname
  path: "/api"                           # URL path prefix
  pathType: "Prefix"                     # Path matching type
  
  # TLS/SSL Configuration
  tls:
    enabled: true                         # Enable HTTPS
    secretName: "api-tls-cert"           # Certificate secret name
    
  # Advanced annotations
  annotations:
    # SSL/TLS Configuration
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    
    # Performance & Caching
    nginx.ingress.kubernetes.io/proxy-buffer-size: "8k"
    nginx.ingress.kubernetes.io/proxy-buffers-number: "8"
    nginx.ingress.kubernetes.io/client-max-body-size: "50m"
    
    # Security Headers
    nginx.ingress.kubernetes.io/configuration-snippet: |
      more_set_headers "X-Frame-Options: DENY";
      more_set_headers "X-Content-Type-Options: nosniff";
      more_set_headers "X-XSS-Protection: 1; mode=block";
      more_set_headers "Strict-Transport-Security: max-age=31536000";
    
    # Rate Limiting
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/rate-limit-window: "1m"
    
    # Load Balancing
    nginx.ingress.kubernetes.io/load-balance: "ewma"
    nginx.ingress.kubernetes.io/upstream-hash-by: "$binary_remote_addr"
```

### 📊 Configuration & Secrets Management

Flexible environment configuration:

```yaml
# 📝 ConfigMap - Non-sensitive configuration
config:
  # Application settings
  LOG_LEVEL: "INFO"                       # Logging verbosity
  API_TIMEOUT: "30s"                      # API request timeout
  CACHE_TTL: "3600"                       # Cache time-to-live
  
  # Database configuration  
  DB_HOST: "postgresql.database.svc.cluster.local"
  DB_PORT: "5432"
  DB_NAME: "application_db"
  DB_SSL_MODE: "require"
  
  # External service URLs
  REDIS_URL: "redis://redis.cache.svc.cluster.local:6379"
  ELASTICSEARCH_URL: "http://elasticsearch.logging.svc.cluster.local:9200"
  
  # Feature flags
  ENABLE_DEBUG_MODE: "false"
  ENABLE_METRICS: "true"
  ENABLE_TRACING: "true"

# 🔒 Secrets - Sensitive data (base64 encoded)
secrets:
  DB_PASSWORD: "cG9zdGdyZXNxbF9wYXNzd29yZA=="    # postgresql_password
  API_KEY: "YWJjZGVmZ2hpams="                    # abcdefghijk  
  JWT_SECRET: "c3VwZXJfc2VjcmV0X2tleQ=="          # super_secret_key
  TLS_CERT: "LS0tLS1CRUdJTi..."                  # TLS certificate
  TLS_KEY: "LS0tLS1CRUdJTi..."                   # TLS private key
```

## 📝 Usage Examples & Patterns

### 🚀 Basic Multi-Application Deployment

```bash
# 1. Clone repository and navigate to chart
git clone <your-repository>
cd infra/helmchart

# 2. Review available configurations
ls values-*.yaml
# Output: values.yaml values-complete-sample.yaml values-dev.yaml values-staging.yaml values-production.yaml

# 3. Deploy to development environment
helm install dev-apps . -f values-dev.yaml

# 4. Verify deployment
kubectl get pods,svc -n my-app-dev
kubectl get ingress -n my-app-dev

# 5. Run connection tests
helm test dev-apps

# 6. Check application logs
kubectl logs -l app.kubernetes.io/instance=dev-apps -n my-app-dev
```

### 🔄 Environment Progression Workflow

```bash
# Development → Staging → Production deployment pattern

# 1. Start with development
helm install dev-release . -f values-dev.yaml

# 2. Test and validate in dev
curl http://localhost:30080/health
helm test dev-release

# 3. Deploy to staging when ready
helm install staging-release . -f values-staging.yaml

# 4. Run staging tests
curl https://staging-api.mytomorrows.com/health  
helm test staging-release

# 5. Deploy to production with specific image versions
helm install prod-release . -f values-production.yaml \
  --set applications[0].image.tag=v1.2.3 \
  --set applications[1].image.tag=v2.1.0 \
  --set applications[2].image.tag=v1.5.2 \
  --set applications[3].image.tag=v3.0.1
```

### ⚡ Dynamic Application Management

```bash
# Add a new application to existing deployment
helm upgrade dev-apps . -f values-dev.yaml \
  --set applications[2].name=new-service \
  --set applications[2].enabled=true \
  --set applications[2].image.repository=mytomorrows/newapp \
  --set applications[2].image.tag=v1.0.0 \
  --set applications[2].service.port=8080

# Temporarily disable an application (zero-downtime)
helm upgrade prod-apps . -f values-production.yaml \
  --set applications[1].enabled=false

# Scale specific application independently  
helm upgrade prod-apps . -f values-production.yaml \
  --set applications[0].autoscaling.maxReplicas=20 \
  --set applications[0].resources.limits.cpu=2000m \
  --set applications[0].resources.limits.memory=2Gi

# Update configuration without restart
helm upgrade staging-apps . -f values-staging.yaml \
  --set applications[0].config.LOG_LEVEL=DEBUG \
  --set applications[0].config.CACHE_TTL=1800
```

### 🔧 Custom Configuration Examples

#### Adding New Application to Existing Environment

```yaml
# Add to values-production.yaml applications array:
applications:
  # ... existing apps ...
  - name: "notification-service"
    enabled: true
    image:
      repository: "mytomorrows/notifications"
      tag: "v1.0.0"
    service:
      type: ClusterIP
      port: 80
      targetPort: 3000
    app:
      containerPort: 3000
      healthCheck:
        enabled: true
        liveness:
          path: "/health"
        readiness:
          path: "/ready"
    config:
      SMTP_HOST: "smtp.mytomorrows.com"
      NOTIFICATION_QUEUE: "notifications"
    secrets:
      SMTP_PASSWORD: "base64encodedpassword"
    ingress:
      enabled: true
      host: "notifications.mytomorrows.com"
      path: "/api/notifications"
    autoscaling:
      enabled: true
      minReplicas: 2
      maxReplicas: 8
      targetCPUUtilizationPercentage: 75
    resources:
      requests:
        cpu: 100m
        memory: 256Mi
      limits:
        cpu: 500m
        memory: 512Mi
```

#### Environment-Specific Overrides

```bash
# Override specific values for emergency scaling
helm upgrade prod-apps . -f values-production.yaml \
  --set applications[0].autoscaling.maxReplicas=50 \
  --set applications[0].resources.limits.cpu=4000m \
  --set applications[0].resources.limits.memory=8Gi \
  --set applications[0].autoscaling.targetCPUUtilizationPercentage=60

# Deploy with custom registry for air-gapped environments  
helm install secure-apps . -f values-production.yaml \
  --set global.registry=harbor.internal.com \
  --set applications[0].image.repository=harbor.internal.com/myapp/api \
  --set applications[1].image.repository=harbor.internal.com/myapp/admin

# Deploy with specific namespace and custom ingress
helm install tenant-apps . -f values-production.yaml \
  --set global.namespace=tenant-production \
  --set applications[0].ingress.host=api-tenant.mytomorrows.com \
  --set applications[1].ingress.host=admin-tenant.mytomorrows.com
```

## 🛡️ Security Features & Best Practices

This chart implements **defense-in-depth security** with multiple layers of protection:

### 🔐 Pod Security Standards

```yaml
# Enforced security contexts for all applications
security:
  podSecurityStandard: "restricted"      # Kubernetes Pod Security Standard
  securityContext:
    runAsUser: 10001                     # Non-root user ID  
    runAsGroup: 10001                    # Non-root group ID
    runAsNonRoot: true                   # Prevent root execution
    readOnlyRootFilesystem: true         # Immutable root filesystem
    allowPrivilegeEscalation: false      # Prevent privilege escalation
    seccompProfile:                      # Secure computing mode
      type: RuntimeDefault
    capabilities:
      drop: ["ALL"]                      # Drop all Linux capabilities
      add: []                           # No additional capabilities
```

### 🌐 Network Security Policies

```yaml
# Ingress traffic control
networkPolicy:
  ingress:
    enabled: true
    allowedSources:                      # Whitelist approach
      - namespaceSelector:
          matchLabels:
            name: "ingress-nginx"        # Allow ingress controller
      - namespaceSelector:
          matchLabels:
            name: "monitoring"           # Allow monitoring namespace
      - podSelector:                     # Allow same-namespace communication
          matchLabels:
            app.kubernetes.io/part-of: "my-app"
    denyAll: true                        # Deny all other ingress traffic

# Egress traffic control  
  egress:
    enabled: true
    allowedDestinations:                 # Explicit allowed destinations
      - namespaceSelector:
          matchLabels:
            name: "kube-system"          # Allow DNS resolution
        ports:
          - protocol: UDP
            port: 53
      - namespaceSelector:
          matchLabels:
            name: "database"             # Allow database access
        ports:
          - protocol: TCP
            port: 5432
```

### 👤 RBAC (Role-Based Access Control)

```yaml
# Minimal service account permissions
serviceAccount:
  create: true
  automountServiceAccountToken: false   # Disable automatic token mounting
  annotations:
    # EKS IAM role association (if using AWS)
    eks.amazonaws.com/role-arn: "arn:aws:iam::ACCOUNT:role/MyAppRole"

rbac:
  create: true
  rules:                                # Minimal required permissions only
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["get", "list"]            # Read-only pod access
    - apiGroups: [""]  
      resources: ["configmaps"]
      verbs: ["get", "list"]            # Read-only configmap access
    # No write permissions - follows principle of least privilege
```

### 🔒 Secrets Management

```yaml
# Secure secrets handling
secrets:
  create: true
  type: "Opaque"                        # Generic secret type
  annotations:
    # External secrets integration (if using external-secrets-operator)
    external-secrets.io/backend: "vault"
    external-secrets.io/key: "secret/myapp"
  
# Best practices for secrets:
# 1. Use external secret management (Vault, AWS Secrets Manager, etc.)  
# 2. Enable encryption at rest in etcd
# 3. Use separate secrets per environment
# 4. Rotate secrets regularly
# 5. Avoid logging secret values
```

### 🛡️ Image Security

```yaml
image:
  # Security scanning and compliance
  registry: "harbor.internal.com"       # Private/secure registry
  repository: "mytomorrows/api"  
  tag: "v1.2.3-sha256"                  # Immutable, signed tags
  pullPolicy: Always                    # Always verify image signatures
  
  # Image pull secrets for private registries
  pullSecrets:
    - name: "harbor-registry-secret"
    
# Security policies:
# ✅ Base images scanned for vulnerabilities
# ✅ Images signed with cosign/notary  
# ✅ No latest tags in production
# ✅ Distroless or minimal base images
# ✅ Regular base image updates
```

## 🧪 Validation & Testing

### 📋 Pre-Deployment Validation

```bash
# 1. Helm template validation
helm template test-release . -f values-production.yaml --dry-run

# 2. Kubernetes resource validation
helm template test-release . -f values-production.yaml | kubectl apply --dry-run=client -f -

# 3. Helm lint checks
helm lint . -f values-production.yaml

# 4. Security policy validation (if using OPA Gatekeeper)
helm template test-release . -f values-production.yaml | conftest verify --policy security-policies/

# 5. Resource requirements validation
kubectl describe limitrange -n my-app-production
kubectl describe resourcequota -n my-app-production
```

### 🔍 Template Debugging

```bash
# Debug specific templates
helm template debug-release . -f values-dev.yaml \
  --show-only templates/deployment.yaml

# Debug with custom values
helm template debug-release . -f values-staging.yaml \
  --set applications[0].image.tag=debug-v1.0 \
  --set applications[0].config.LOG_LEVEL=DEBUG

# Validate specific applications only
helm template debug-release . -f values-production.yaml \
  --show-only templates/deployment.yaml \
  --show-only templates/service.yaml \
  --show-only templates/ingress.yaml
```

### 🧪 Comprehensive Testing Suite

```bash
# 1. Connectivity tests (built into chart)
helm test my-release

# 2. Application health checks
kubectl get pods -n my-app-production | grep -v Running
for app in api-service admin-dashboard worker-service monitoring-service; do
  kubectl exec -n my-app-production deployment/$app -- curl -f http://localhost:8080/health
done

# 3. Ingress connectivity
curl -k https://api.mytomorrows.com/health
curl -k https://admin.mytomorrows.com/health  

# 4. Autoscaling validation
kubectl get hpa -n my-app-production
kubectl top pods -n my-app-production

# 5. Security validation
kubectl auth can-i --list --as=system:serviceaccount:my-app-production:my-app
kubectl get networkpolicies -n my-app-production
```

### 📊 Performance Testing

```bash
# Load testing with Apache Bench
ab -n 1000 -c 10 https://api.mytomorrows.com/api/health

# Monitor scaling behavior during load test
watch kubectl get hpa,pods -n my-app-production

# Resource utilization monitoring
kubectl top pods -n my-app-production --sort-by=cpu
kubectl top pods -n my-app-production --sort-by=memory
```

## 🚨 Troubleshooting Guide

### ❗ Common Issues & Solutions

#### 1. **Image Pull Errors**
```bash
# Symptoms: 
# - Pods stuck in "ImagePullBackOff" status
# - Error: "Failed to pull image"

# Debugging:
kubectl describe pod <pod-name> -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp

# Solutions:
# ✅ Verify image tag exists: docker manifest inspect <image>:<tag>
# ✅ Check image pull secrets: kubectl get secrets -n <namespace>
# ✅ Test registry connectivity: kubectl run test --image=<image> --rm -it -- /bin/sh
```

#### 2. **Ingress Configuration Issues**
```bash
# Symptoms:
# - 404/502/503 errors via ingress
# - DNS resolution problems

# Debugging:
kubectl describe ingress -n <namespace>
kubectl get endpoints -n <namespace>
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller

# Solutions:  
# ✅ Verify ingress class: kubectl get ingressclass
# ✅ Check DNS records point to LoadBalancer IP
# ✅ Validate TLS certificates: kubectl describe secret <tls-secret>
```

#### 3. **Resource Constraints**
```bash
# Symptoms:
# - Pods in "Pending" status  
# - "Insufficient cpu/memory" events

# Debugging:
kubectl describe pod <pending-pod> -n <namespace>
kubectl describe node <node-name>
kubectl get limitrange,resourcequota -n <namespace>

# Solutions:
# ✅ Adjust resource requests/limits in values file
# ✅ Scale cluster nodes if needed
# ✅ Review resource quotas and limits
```

#### 4. **Autoscaling Not Working**
```bash
# Symptoms:
# - HPA shows "Unknown" metrics
# - No scaling despite high CPU/memory

# Debugging:  
kubectl describe hpa -n <namespace>
kubectl top pods -n <namespace>
kubectl logs -n kube-system deployment/metrics-server

# Solutions:
# ✅ Ensure metrics-server is running: kubectl get deployment metrics-server -n kube-system
# ✅ Verify resource requests are set (required for HPA)
# ✅ Check HPA target values are realistic
```

#### 5. **Secret/ConfigMap Issues**
```bash
# Symptoms:
# - Application environment variables missing
# - Authentication failures

# Debugging:
kubectl get configmap,secret -n <namespace>
kubectl describe configmap <app-name>-config -n <namespace>
kubectl exec -it deployment/<app-name> -n <namespace> -- env | grep -i <variable>

# Solutions:
# ✅ Verify base64 encoding for secrets: echo <value> | base64
# ✅ Check configmap/secret naming matches deployment
# ✅ Validate environment variable names
```

### 🔧 Advanced Debugging Commands

```bash
# Application debugging
kubectl get all,ingress,networkpolicy,pdb -n <namespace>
kubectl events -n <namespace> --for deployment/<app-name>
kubectl logs deployment/<app-name> -n <namespace> --previous

# Security debugging
kubectl auth can-i --list --as=system:serviceaccount:<namespace>:<serviceaccount>
kubectl get networkpolicy -n <namespace> -o yaml

# Performance debugging  
kubectl top nodes
kubectl top pods -n <namespace> --sort-by=cpu
kubectl describe limitrange -n <namespace>

# Networking debugging
kubectl get endpoints -n <namespace>
kubectl run debug --image=nicolaka/netshoot --rm -it -- /bin/bash
# Inside debug pod: nslookup <service-name>.<namespace>.svc.cluster.local
```

### 📞 Support & Escalation

For complex issues requiring escalation:

1. **Gather comprehensive diagnostic information:**
   ```bash
   kubectl get all -n <namespace> -o yaml > cluster-state.yaml
   helm get values <release-name> > current-values.yaml  
   kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp > events.log
   ```

2. **Document the issue with:**
   - Environment (dev/staging/production)
   - Exact error messages and timestamps
   - Steps to reproduce
   - Recent changes to configuration
   - Impact assessment (users affected, services down)

3. **Contact support channels:**
   - Internal DevOps team for infrastructure issues
   - Application teams for service-specific problems  
   - Security team for compliance/security concerns

## 📚 Documentation & Resources

### 📖 Comprehensive Documentation Suite

| Document | Purpose | Audience |
|----------|---------|----------|
| **[MULTI_APP_README.md](./MULTI_APP_README.md)** | Detailed usage guide and migration instructions | Developers, DevOps |
| **[values-complete-sample.yaml](./values-complete-sample.yaml)** | Complete configuration reference with examples | Configuration managers |
| **[SECURITY.md](./SECURITY.md)** | Security considerations and compliance guide | Security teams, auditors |
| **[templates/NOTES.txt](./templates/NOTES.txt)** | Runtime deployment instructions | Operations teams |
| **[templates/tests/](./templates/tests/)** | Built-in connectivity tests | QA, monitoring |

### 🔗 Integration Documentation

#### Monitoring Stack Integration
```yaml
# Prometheus monitoring annotations (automatically applied)
annotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "8080"  
  prometheus.io/path: "/metrics"

# Grafana dashboard import IDs:
# - Kubernetes Pod Monitoring: 6417
# - Nginx Ingress: 9614  
# - Application Overview: 1860
```

#### Logging Stack Integration
```yaml
# Fluentd/Fluent Bit log collection (automatically configured)
labels:
  app.kubernetes.io/name: "{{ .Values.applications.name }}"
  app.kubernetes.io/instance: "{{ .Release.Name }}"
  app.kubernetes.io/version: "{{ .Chart.AppVersion }}"
  
# Log aggregation fields:
# - namespace: Kubernetes namespace
# - pod_name: Pod identifier  
# - container_name: Container identifier
# - app_name: Application name from values
```

#### Service Mesh Integration
```yaml
# Istio service mesh compatibility
annotations:
  sidecar.istio.io/inject: "true"           # Enable Istio sidecar
  traffic.sidecar.istio.io/includeInboundPorts: "*"
  traffic.sidecar.istio.io/excludeOutboundPorts: "443"

# Linkerd service mesh compatibility  
annotations:
  linkerd.io/inject: enabled                # Enable Linkerd proxy
```

## 🔄 Migration Guide

### 📈 Migrating from Single Application Charts

#### Step 1: Assess Current Configuration
```bash
# Extract current chart values
helm get values <current-release> > legacy-values.yaml

# Review current resources
kubectl get all -l app.kubernetes.io/instance=<current-release> -o yaml > legacy-resources.yaml
```

#### Step 2: Convert to Multi-App Structure
```yaml
# Legacy single-app structure:
image:
  repository: myapp/api
  tag: v1.0
service:
  port: 80
ingress:
  host: api.example.com

# Convert to multi-app structure:
applications:
  - name: api-service              # <-- Add name and wrap in array
    enabled: true                  # <-- Add enabled flag
    image:                         # <-- Move under applications[0]
      repository: myapp/api
      tag: v1.0  
    service:
      port: 80
    ingress:
      host: api.example.com
```

#### Step 3: Test Migration  
```bash
# 1. Deploy to test environment first
helm install migration-test . -f converted-values.yaml --dry-run

# 2. Deploy to separate namespace for validation
helm install migration-test . -f converted-values.yaml \
  --set global.namespace=migration-test

# 3. Compare resources
kubectl diff -f legacy-resources.yaml -f new-resources.yaml
```

#### Step 4: Production Migration
```bash
# Zero-downtime migration strategy:

# 1. Deploy new chart in parallel namespace
helm install new-app-prod . -f values-production.yaml \
  --set global.namespace=new-app-production

# 2. Update ingress/load balancer to point to new namespace  
kubectl patch ingress api-ingress -p '{"spec":{"backend":{"service":{"namespace":"new-app-production"}}}}'

# 3. Monitor application health and metrics
kubectl get pods -n new-app-production --watch

# 4. Remove old deployment after validation
helm uninstall old-app-prod
kubectl delete namespace old-app-production
```

### 🚀 Adding Applications to Existing Deployment

```bash
# Safe addition of new applications:

# 1. Update values file with new application
cat >> values-production.yaml << EOF
  - name: notification-service
    enabled: true
    image:
      repository: mytomorrows/notifications
      tag: v1.0.0
    # ... rest of configuration
EOF

# 2. Upgrade deployment (existing apps unaffected)
helm upgrade prod-apps . -f values-production.yaml

# 3. Verify only new application was deployed
kubectl get deployment -l app.kubernetes.io/instance=prod-apps
```

## 🚀 Production Deployment Checklist

### ✅ Pre-Deployment Requirements

#### Infrastructure Readiness
- [ ] **Kubernetes cluster** meets minimum version requirements (1.24+)
- [ ] **Ingress controller** deployed and configured (nginx/ALB)
- [ ] **Certificate manager** available for TLS (cert-manager/AWS ACM)
- [ ] **Metrics server** installed for autoscaling functionality
- [ ] **DNS records** configured for application domains
- [ ] **Load balancer** capacity planned for expected traffic
- [ ] **Storage classes** available for persistent volumes (if needed)

#### Security Compliance
- [ ] **Pod Security Standards** enforced at namespace level
- [ ] **Network policies** configured for environment isolation
- [ ] **Service accounts** follow principle of least privilege  
- [ ] **Image scanning** completed and vulnerabilities addressed
- [ ] **Secrets management** integrated (external secrets operator)
- [ ] **RBAC policies** reviewed and approved
- [ ] **Compliance requirements** met (SOC2, GDPR, HIPAA, etc.)

#### Configuration Management  
- [ ] **Environment-specific values** reviewed and validated
- [ ] **Resource limits** set based on capacity planning
- [ ] **Application images** use specific tags (no `latest`)
- [ ] **Health check endpoints** implemented in applications
- [ ] **Configuration secrets** properly base64 encoded
- [ ] **Database credentials** rotated and secured
- [ ] **API keys** generated and configured

### ✅ Deployment Validation

#### Functional Testing
- [ ] **Helm template validation** passes without errors
- [ ] **Resource quotas** sufficient for planned deployment
- [ ] **Image pull secrets** working for private registries
- [ ] **Application connectivity** verified in staging
- [ ] **Database connections** tested and validated
- [ ] **External service integrations** operational
- [ ] **SSL/TLS certificates** valid and properly configured

#### Performance & Scaling
- [ ] **Resource requests/limits** tuned based on load testing
- [ ] **Autoscaling thresholds** set appropriately
- [ ] **Pod disruption budgets** configured for availability
- [ ] **Load testing** completed in staging environment
- [ ] **Monitoring alerts** configured for key metrics
- [ ] **Log aggregation** capturing application logs
- [ ] **Performance baselines** established

### ✅ Post-Deployment Operations

#### Monitoring & Alerting
- [ ] **Application health checks** returning successfully
- [ ] **Prometheus metrics** being collected
- [ ] **Grafana dashboards** displaying key metrics
- [ ] **Alert rules** configured for critical issues
- [ ] **Log aggregation** functioning across all apps
- [ ] **Error tracking** integrated (Sentry, Rollbar, etc.)
- [ ] **Uptime monitoring** configured (external monitoring)

#### Security Validation
- [ ] **Security scanning** of deployed containers
- [ ] **Network policy** enforcement verified
- [ ] **Service account permissions** validated
- [ ] **Secrets rotation** schedule established
- [ ] **Compliance audit trail** documented
- [ ] **Penetration testing** scheduled (if required)
- [ ] **Backup and recovery** procedures tested

### ✅ Operational Excellence

#### Documentation & Knowledge Transfer
- [ ] **Runbooks** created for common operations
- [ ] **Troubleshooting guides** available to on-call teams
- [ ] **Escalation procedures** documented
- [ ] **Configuration changes** tracked in version control
- [ ] **Disaster recovery** procedures tested
- [ ] **Team training** completed on new deployment

#### Continuous Improvement
- [ ] **CI/CD pipeline** integrated for automated deployments
- [ ] **GitOps workflow** established for configuration management
- [ ] **Performance optimization** opportunities identified
- [ ] **Cost optimization** analysis completed
- [ ] **Capacity planning** for future growth
- [ ] **Regular security updates** scheduled

## 🤝 Contributing & Maintenance

### 💡 Chart Development Guidelines

This chart follows **GitOps principles** and enterprise development standards:

```bash
# Development workflow:
1. Fork repository and create feature branch
   git checkout -b feature/add-redis-support

2. Make changes following Helm best practices
   # - Use semantic versioning for Chart.yaml
   # - Test all template changes with multiple environments
   # - Update documentation for new features  
   # - Follow security-first design principles

3. Validate changes comprehensively
   helm lint .
   helm template test . -f values-dev.yaml --dry-run
   helm template test . -f values-staging.yaml --dry-run  
   helm template test . -f values-production.yaml --dry-run

4. Test in development environment
   helm install test-feature . -f values-dev.yaml --set global.namespace=test-feature

5. Create pull request with detailed description
   # Include: changes made, testing performed, breaking changes, migration notes

6. Deploy through CI/CD pipeline
   # Automated: linting, security scanning, template validation
   # Manual: staging deployment approval, production deployment approval
```

### 🔄 Version Management

```yaml
# Chart.yaml versioning strategy:
version: "0.2.0"        # Chart version (semantic versioning)  
appVersion: "2.0.0"     # Application version (tracks feature releases)

# Breaking changes increment major version
# New features increment minor version  
# Bug fixes increment patch version
```

### 📋 Maintenance Schedule

| Task | Frequency | Owner |
|------|-----------|-------|
| **Security updates** | Weekly | Security team |
| **Dependency updates** | Monthly | DevOps team |
| **Performance review** | Quarterly | SRE team |
| **Disaster recovery test** | Quarterly | Operations team |
| **Documentation review** | Bi-annually | All teams |
| **Compliance audit** | Annually | Compliance team |

## 📜 License & Support

### 📄 License Information

This Helm chart is provided **as-is** for demonstration and educational purposes. 

**Usage Rights:**
- ✅ Use in development and testing environments
- ✅ Modify and adapt for specific requirements  
- ✅ Share and distribute within organization
- ✅ Commercial use with proper attribution

**Limitations:**
- ❌ No warranty or support guarantees
- ❌ Use at your own risk in production
- ❌ No liability for damages or issues

### 🆘 Support Channels

| Issue Type | Contact | Response Time |
|------------|---------|---------------|
| **Security vulnerabilities** | security@mytomorrows.com | 24 hours |
| **Production issues** | devops-oncall@mytomorrows.com | 2 hours |
| **Feature requests** | GitHub Issues | Best effort |
| **Documentation** | tech-docs@mytomorrows.com | 1 week |

### 🎯 Chart Roadmap

**Next Release (v0.3.0):**
- [ ] Velero backup integration
- [ ] External secrets operator support
- [ ] Advanced autoscaling metrics
- [ ] Canary deployment patterns

**Future Releases:**
- [ ] Multi-cluster deployment support
- [ ] Service mesh native integration  
- [ ] Advanced security policies
- [ ] Cost optimization features

---

## 🎉 Conclusion

This **Multi-Application Umbrella Helm Chart** provides a **production-ready, enterprise-grade solution** for deploying and managing multiple applications with shared infrastructure patterns.

### Key Achievements:
- ✅ **Scalable**: Deploy 2+ applications with single chart
- ✅ **Secure**: Defense-in-depth security with Pod Security Standards  
- ✅ **Production-Ready**: HA, autoscaling, monitoring, compliance
- ✅ **Flexible**: Environment-specific configurations with granular control
- ✅ **Maintainable**: Clean templates, comprehensive documentation, GitOps ready

**Ready for Production Deployment Across:**
- 🔨 **Development**: 2 applications with local NodePort access
- 🔄 **Staging**: 3 applications with nginx ingress and SSL
- 🏭 **Production**: 4 applications with AWS ALB, full monitoring, and enterprise security

**Chart Version**: `0.2.0` | **App Version**: `2.0.0` | **Status**: 🎯 **Production Ready**
