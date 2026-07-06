aws_region              = "us-east-1"
vpc_cidr                = "10.0.0.0/16"
container_image         = "nginx:latest"
desired_count           = 1
db_instance_class       = "db.t3.micro"
backup_retention_period = 1
deletion_protection     = false