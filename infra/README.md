# Infrastructure (Terraform)

## Layout
- `modules/network` — VPC, public/private subnets, IGW, single NAT gateway, route tables
- `modules/ecs` — ECS Fargate cluster, task definition, service, ALB, security groups
- `modules/rds` — Private PostgreSQL RDS instance, security group scoped to ECS only
- `envs/dev` — Dev-sized environment (db.t3.micro, 1-day backups, no deletion protection)
- `envs/prod` — Prod-sized environment (db.t3.small, 7-day backups, deletion protection + multi-AZ)

## Usage

```bash
cd infra/envs/dev
terraform init
export TF_VAR_db_password="choose-a-strong-password"
terraform fmt
terraform validate
terraform plan
terraform apply
```

Repeat in `infra/envs/prod` for production, using a strong, unique password.

## Notes
- `backend.tf` in each environment points at an S3 bucket + DynamoDB lock table. Create these
  once (or use `terraform init` locally without a backend block first) before wiring up remote state.
- The RDS security group only allows inbound traffic from the ECS service's security group —
  never `0.0.0.0/0`.
- `container_image` defaults to `nginx:latest`; swap it for your own app image via `-var` or tfvars.
