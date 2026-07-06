aws_region              = "us-east-1"
vpc_cidr                = "10.1.0.0/16"
container_image         = "nginx:latest"
desired_count           = 2
db_instance_class       = "db.t3.small"
backup_retention_period = 7
deletion_protection     = true
multi_az                = true