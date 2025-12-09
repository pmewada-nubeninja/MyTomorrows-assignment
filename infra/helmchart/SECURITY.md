# Security Configuration Guide

This document outlines the comprehensive security features implemented in the Helm umbrella chart.

## 🛡️ Security Features Overview

### 1. **Pod Security Standards**
- **Development**: `baseline` enforcement with `restricted` audit/warn
- **Staging/Production**: `restricted` enforcement across all policies
- Applied via namespace labels for cluster-wide enforcement

### 2. **Container Security**
```yaml
securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 10001
  runAsGroup: 10001
  capabilities:
    drop: [ALL]
```

### 3. **Network Policies**
- **Development**: Permissive ingress for easier debugging
- **Staging**: Controlled ingress from ingress-nginx + DNS egress
- **Production**: Strict ingress/egress with minimal required traffic

### 4. **RBAC (Role-Based Access Control)**
- Minimal permissions principle
- Development: Read-only pod access
- Staging: Pod + ConfigMap read access  
- Production: Minimal read-only access

### 5. **Service Account Security**
- `automountServiceAccountToken: false` by default
- Prevents automatic mounting of service account tokens
- Reduces attack surface

### 6. **Volume Security**
- Read-only root filesystem enabled
- Temporary directories mounted as emptyDir volumes:
  - `/tmp` - 100Mi limit
  - `/var/log` - 100Mi limit  
  - `/var/run` - 100Mi limit

## 🔧 Security Configuration per Environment

### Development Environment
- **Pod Security**: Baseline enforcement
- **Network**: Open ingress for development ease
- **RBAC**: Basic pod read access
- **Purpose**: Developer-friendly with basic security

### Staging Environment  
- **Pod Security**: Restricted enforcement
- **Network**: Controlled traffic from ingress controller
- **RBAC**: Pod + ConfigMap access
- **PDB**: 1 pod minimum availability
- **Purpose**: Production-like security with testing flexibility

### Production Environment
- **Pod Security**: Full restricted enforcement
- **Network**: Strict ingress/egress policies
- **RBAC**: Minimal read-only permissions
- **PDB**: High availability protection
- **Purpose**: Maximum security hardening

## 🚨 Security Validations

### Pre-deployment Validation
```bash
# Validate security policies
helm template app . --values values-prod.yaml | kubectl apply --dry-run=server -f -

# Security scan with Polaris
polaris audit --format=json --audit-path ./templates/

# Check Pod Security Standards
kubectl label namespace <namespace> pod-security.kubernetes.io/enforce=restricted
```

### Runtime Security Monitoring
```bash
# Check pod security context
kubectl get pods -o jsonpath='{.items[*].spec.securityContext}'

# Verify network policies
kubectl get networkpolicy -n <namespace>

# Check RBAC permissions
kubectl auth can-i --list --as=system:serviceaccount:<namespace>:<service-account>
```

## 🔒 Security Best Practices Implemented

### 1. **Defense in Depth**
- Multiple security layers: Pod Security, Network Policies, RBAC
- Container-level and pod-level security contexts
- Namespace-level policy enforcement

### 2. **Principle of Least Privilege**
- Minimal RBAC permissions per environment
- Non-root user execution (UID 10001)
- Capability dropping (ALL capabilities removed)

### 3. **Immutable Infrastructure**
- Read-only root filesystem
- Temporary storage in controlled volumes
- No privilege escalation allowed

### 4. **Network Segmentation**
- Environment-specific network policies
- Controlled ingress/egress traffic
- DNS resolution restrictions

### 5. **Runtime Protection**
- Pod Security Standards enforcement
- Resource limits and quotas

## ⚠️ Security Considerations

### Image Security
```yaml
# Recommended: Use minimal base images
image:
  repository: "distroless/python3"
  tag: "3.11"
  
# Scan images for vulnerabilities
# docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \\
#   aquasec/trivy image <your-image>
```

### Secrets Management
```yaml
# Use external secret management (recommended)
externalSecrets:
  enabled: true
  provider: "aws-secrets-manager"  # or vault, azure-kv
  
# Rotate secrets regularly
secretRotation:
  enabled: true
  schedule: "0 2 * * 0"  # Weekly
```

### Certificate Management
```yaml
# Use cert-manager for TLS
certManager:
  enabled: true
  issuer: "letsencrypt-prod"
  dnsNames:
    - "app.yourdomain.com"
```

## 📋 Security Checklist

- [ ] **Container Security**
  - [x] Non-root user execution
  - [x] Read-only root filesystem
  - [x] Capability dropping
  - [ ] Image vulnerability scanning

- [ ] **Pod Security**
  - [x] Pod Security Standards enforced
  - [x] Security contexts configured
  - [x] Resource limits defined

- [ ] **Network Security**
  - [x] Network policies configured
  - [x] Ingress traffic controlled
  - [x] Egress traffic restricted
  - [ ] Service mesh integration

- [ ] **Access Control**
  - [x] RBAC configured
  - [x] Service account secured
  - [x] Minimal permissions granted
  - [ ] External authentication

- [ ] **Data Protection**
  - [x] Secrets management
  - [x] ConfigMap separation
  - [ ] Data encryption at rest
  - [ ] TLS encryption in transit

- [ ] **Monitoring & Compliance**
  - [ ] Security monitoring
  - [ ] Audit logging
  - [ ] Compliance validation
  - [ ] Incident response plan

## 🚀 Deployment Commands

### Secure Development Deployment
```bash
helm upgrade --install myapp . \\
  --namespace myapp-dev \\
  --create-namespace \\
  --values values-dev.yaml \\
  --set podSecurityStandards.enforce=baseline
```

### Secure Production Deployment
```bash
helm upgrade --install myapp . \\
  --namespace myapp-prod \\
  --create-namespace \\
  --values values-prod.yaml \\
  --set podSecurityStandards.enforce=restricted \\
  --atomic \\
  --timeout=10m
```

### Security Validation
```bash
# Validate security policies before deployment
helm template myapp . --values values-prod.yaml | \\
  kubectl apply --dry-run=server -f -

# Test network policies
kubectl run test-pod --image=busybox -it --rm -- wget myapp:80
```

This security configuration provides enterprise-grade protection while maintaining operational flexibility across different environments.