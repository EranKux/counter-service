
# Counter Service

A counter service deployed on AWS EKS with Redis persistence and CI/CD automation.


## 1. Bootstrap (State Backend) Setup

Before running any Terraform commands, you must provision the S3 bucket and DynamoDB table used for storing the Terraform state and managing state locks. This is done using the `bootstrap_backend.tf` file.

### Initialize the Backend Resources

Run:

```bash
cd infrastructure
terraform init -backend=false
terraform apply -target=aws_s3_bucket.tf_state -target=aws_dynamodb_table.tf_lock
```

This will create the S3 bucket (`counter-state-bucket`) and DynamoDB table (`counter-lock-table`) required for the remote backend.

## 2. Provision Infrastructure

```bash
terraform init
terraform apply
aws eks update-kubeconfig --region eu-central-1 --name eran-counter-eks
```

## 3. Install AWS Load Balancer Controller

```bash
helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system --set clusterName=eran-counter-eks
```

## 4. Configure Credentials

### GitHub Actions Secret

Add to repository secrets (Settings → Secrets → Actions):
- `AWS_ROLE_ARN` - IAM role ARN for GitHub Actions OIDC

### ALB Controller IRSA

```bash
ROLE_ARN=$(terraform output -raw alb_controller_role_arn)
kubectl annotate serviceaccount aws-load-balancer-controller \
  -n kube-system eks.amazonaws.com/role-arn=$ROLE_ARN --overwrite
kubectl rollout restart deployment aws-load-balancer-controller -n kube-system
```

## 5. Install Metrics Server (for HPA)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

## 6. Run Pipeline

Pipeline triggers automatically on push to `main` (application/, helm/, .github/workflows/).

Manual: GitHub → Actions → CI/CD Pipeline → Run workflow

## 7. Test

```bash
# Get ALB URL
kubectl get ingress counter-service -n prod

# Test endpoints
curl http://<ALB_URL>/health
curl http://<ALB_URL>/          # GET counter
curl -X POST http://<ALB_URL>/  # Increment counter
```

## Architecture Notes

### High Availability
- 3 pods minimum across 3 AZs
- PDB: minAvailable=2
- HPA: 3-10 replicas (CPU 70%, Memory 80%)

### Persistence
- Redis (ElastiCache) stores counter value
- Snapshots retained 5 days

### Trade-offs
| Choice | Reason |
|--------|--------|
| Single Redis node | Cost-effective, acceptable for non-critical data |
| SSL disabled | Simpler setup; Redis in private subnet |
| IP target type | Direct pod routing, better performance |

## Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET/POST | Get/increment counter |
| `/health` | GET | Liveness probe |
| `/ready` | GET | Readiness probe |
| `/metrics` | GET | Prometheus metrics |
