# DevOps Assessment

A complete DevOps assessment project: multi-environment Terraform infrastructure on AWS
(VPC, ALB, ECS Fargate, RDS PostgreSQL), a local Docker Compose Postgres environment,
database migrations/seed/indexing, backup/restore scripts, and a GitHub Actions CI workflow.

## Architecture

```
                 AWS (Terraform)

                    Internet
                        |
                Application Load Balancer
                        |
                 ECS Fargate Service
                        |
               Private PostgreSQL RDS


               Local Development

                Docker Compose
                       |
                 PostgreSQL
                       |
          Migration + Seed Data
                       |
           Backup & Restore Scripts
```

## Folder Structure

```
devops-assessment/
├── infra/
│   ├── modules/
│   │      ├── network/
│   │      ├── ecs/
│   │      └── rds/
│   ├── envs/
│   │      ├── dev/
│   │      └── prod/
│   └── README.md
├── database/
│      ├── migrations/
│      ├── seed/
│      └── indexes.sql
├── docker-compose.yml
├── scripts/
│      ├── backup.sh
│      └── restore.sh
├── .github/workflows/terraform.yml
└── README.md
```

## Prerequisites

- Terraform >= 1.5
- Docker Desktop
- PostgreSQL client (`psql`, `pg_dump`)
- Git
- AWS credentials configured (`aws configure`) if you intend to actually apply infra

## Terraform Commands

```bash
cd infra/envs/dev
terraform init
export TF_VAR_db_password="choose-a-strong-password"
terraform fmt
terraform validate
terraform plan
terraform apply
```

Same commands apply under `infra/envs/prod` for the production environment.
Dev uses `db.t3.micro`, 1-day backups, no deletion protection.
Prod uses `db.t3.small`, 7-day backups, deletion protection, and multi-AZ.

## Docker Commands (local development database)

```bash
docker compose up -d
docker compose ps
docker compose logs -f postgres
docker compose down          # stop
docker compose down -v       # stop and wipe the volume
```

## Database Setup

Connect to the local database:

```bash
psql -h localhost -p 5432 -U admin -d hotel
# password: password
```

### Migration

```bash
psql -h localhost -U admin -d hotel -f database/migrations/001_create_tables.sql
```

### Seed

```bash
psql -h localhost -U admin -d hotel -f database/seed/seed.sql
```

This inserts 100 bookings spread across Delhi, Mumbai, Pune, and Bangalore,
across Org1/Org2/Org3, across all four statuses (booked, cancelled, completed,
pending), plus a matching `booking_events` row for each booking.

### Indexes / Query Optimization

```bash
psql -h localhost -U admin -d hotel -f database/indexes.sql
```

Optimizes:

```sql
SELECT org_id, status, COUNT(*), SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi' AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

A composite B-tree index on `(city, created_at)` puts the equality filter
(`city`) first and the range filter (`created_at`) second, letting Postgres
do a single index range scan instead of a full table scan. An optional
covering variant (`INCLUDE (org_id, status, amount)`) allows an index-only
scan for this exact query shape. Full reasoning is in `database/indexes.sql`.

Verify with:

```sql
EXPLAIN ANALYZE
SELECT org_id, status, COUNT(*), SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi' AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

## Backup

```bash
./scripts/backup.sh
```

Writes a timestamped dump to `backups/backup_<YYYYMMDD_HHMMSS>.sql`.

## Restore

```bash
./scripts/restore.sh backups/backup_20260706_120000.sql
```

Drops the existing database, recreates it, and restores from the given file
(asks for confirmation before dropping).

## Verification Checklist

- [ ] `terraform fmt`, `terraform validate`, `terraform plan` run clean in both `dev` and `prod`
- [ ] `docker compose up -d` brings up Postgres and it passes its healthcheck
- [ ] Migration creates `hotel_bookings` and `booking_events`
- [ ] Seed inserts 100 bookings + matching events
- [ ] `EXPLAIN ANALYZE` on the reporting query shows an index scan, not a seq scan
- [ ] `backup.sh` produces a restorable `.sql` file
- [ ] `restore.sh` successfully rebuilds the database from that file
- [ ] GitHub Actions workflow runs `fmt` / `init` / `validate` / `plan` on pull requests

## GitHub Actions

`.github/workflows/terraform.yml` runs on pull requests touching `infra/**`:
Terraform Format Check → Init → Validate → Plan. It expects these repository
secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `TF_VAR_DB_PASSWORD`.

## Screenshots

Add screenshots of `terraform plan` output, the running ECS service, and a
successful `psql` query here once you've applied the infrastructure.
## Screenshots

### Terraform Init, Format & Validate — Dev
![Terraform Plan](screenshots/Screenshot (271).png)

### Terraform Plan — Dev RDS Security Group
![Terraform Plan](screenshots/Screenshot (272).png)

### Terraform Format & Validate — Prod
![Terraform Plan](screenshots/Screenshot (275).png)

### Terraform Plan — Prod RDS Security Group
![Terraform Plan](screenshots/Screenshot (276).png)

### Docker Compose, Migration, Seed & Indexes
![Docker Compose](screenshots/Screenshot (273).png)
![Docker Compose](screenshots/Screenshot (273).png)

### Seed Verification & Query Optimization (EXPLAIN ANALYZE)
![Seed Verify](screenshots/Screenshot (274).png)

### Backup & Restore
![Backup](screenshots/Screenshot (277).png)
![Restore](screenshots/Screenshot (278).png)

### GitHub Actions
![GitHub Actions](screenshots/github-actions.png)

## Push to GitHub

```bash
git init
git branch -M main
git add .
git commit -m "Initial Commit"
git remote add origin <your-repo-url>
git push -u origin main
```
