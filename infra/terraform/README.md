# Terraform Helm Chart Deployment

This Terraform module deploys the myTomorrows application using the Helm chart created in the `../myTomorrows-app` directory.

## Prerequisites

1. **Terraform** (>= 1.0)
2. **Kubernetes cluster** (Docker Desktop, minikube, etc.)
3. **kubectl** configured and connected to your cluster
4. **Helm** (>= 3.0)
5. **Docker image** `mytms:1.0` available in your cluster

## Quick Start

1. **Initialize Terraform:**
   ```bash
   cd /Users/pmewada/code/mytomorrows/devops-assignment/infra/terraform
   terraform init
   ```

2. **Create variables file:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your specific values
   ```

3. **Plan the deployment:**
   ```bash
   terraform plan
   ```

4. **Apply the deployment:**
   ```bash
   terraform apply
   ```

5. **Access the application:**
   - For NodePort service: `http://localhost:30090`
   - Check outputs for other access methods

## Configuration

### Key Variables

- `namespace`: Kubernetes namespace (default: `my-tomorrows-app`)
- `release_name`: Helm release name (default: `my-tomorrows-app`)
- `chart_path`: Path to Helm chart (default: `../myTomorrows-app`)
- `app_replicas`: Number of pod replicas (default: `3`)
- `service_type`: Service type - `NodePort`, `ClusterIP`, or `LoadBalancer` (default: `NodePort`)
- `service_node_port`: NodePort number (default: `30090`)

### Secrets and Configuration

The module sets the following application secrets and configuration:
- `SECRET_KEY`: Application secret key
- `DB_PASSWORD`: Database password
- `API_BASE_URL`: API base URL
- `LOG_LEVEL`: Application log level
- `MAX_CONNECTIONS`: Maximum database connections

## Outputs

After deployment, Terraform provides useful outputs including:
- Application URL
- Kubectl commands for management
- Helm commands for release management
- Service and deployment information

## Management Commands

### Check deployment status:
```bash
terraform output kubectl_commands
```

### View application logs:
```bash
kubectl logs -l app.kubernetes.io/name=mytomorrows-app -n my-tomorrows-app
```

### Update the deployment:
```bash
terraform apply
```

### Destroy the deployment:
```bash
terraform destroy
```

## Troubleshooting

1. **Image pull issues**: Ensure `mytms:1.0` image is available in your cluster
2. **Port conflicts**: Change `service_node_port` if 30090 is in use
3. **Context issues**: Verify `kube_context` matches your kubectl current context
4. **Namespace conflicts**: The module creates the namespace, ensure it doesn't exist already

## File Structure

```
terraform/
├── provider.tf          # Terraform and provider configuration
├── variables.tf         # Input variable definitions
├── main.tf             # Main Terraform resources
├── outputs.tf          # Output definitions
├── terraform.tfvars.example  # Example variables file
└── README.md           # This file
```