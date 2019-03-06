terraform {
  backend "s3" {
    bucket = "harambee-terraform-states"
    key    = "harambee-uat-rg/terraform.tfstate"
  }
}
# ---------------------
# variable "as_health_check_grace_period" {
#   description = "health_check_grace_period for autoscaling"
#   default = "60"
# }
# ---------------------
variable "as_min_nodes" {
  description = "Min number of nodes for autoscaling"
  default = "1"
}

variable "as_max_nodes" {
  description = "Max number of nodes for autoscaling"
  default = "5"
}

variable "as_desired_nodes" {
  description = "Desired number of nodes for autoscaling"
  default = "1"
}

variable "rds_instance_class" {
  description = "Class of RDS instance"
  default = "db.t2.large"
  # Valid values
  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
}

variable "memcached_instance_type" {
  default = "cache.m3.medium"
}

# variable "memcached_desired_clusters" {
#   default = "2"
# }

variable "cpu_utilization_upper_bound" {
  description = "CPUUtilization upper bound threshold"
  default = "40"
}

variable "cpu_utilization_scaleup_period" {
  description = "CPUUtilization upper bound threshold"
  default = "60"
}

variable "environment_name" {
    description = "Environment Name"
    default = "harambee-uat-rg"
}

variable "aws_key_name" {
    description = "aws_key_name"
    default = "rg-deploy-harambee"
}

variable "aws_mt_private_subnet_key_name" {
    description = "aws_key_name for Instances in private subnets"
    default = "rg-deploy-harambee-private"
}

variable "aws_mt_private_subnet_key_path" {
    description = "EC2 Instances in private subnets public key material path"
    default = "rg-deploy-harambee-private"
}

variable "aws_mt_public_subnet_key_path" {
    description = "EC2 Instances in private subnets public key material path"
    default = "rg-deploy-harambee-private.pub"
}

variable "database_name" {
    description = "RDS database_name"
    default = "edxapp"
}

variable "database_user" {
    description = "RDS database_user"
    default = "root"
}

variable "database_password" {
    description = "RDS database_password"
    default = "MYSQL_ADMIN_PASSWORD"
}

variable "aws_ec2_ami_autoscaling_regexp" {
    description = "A regex string to apply to the AMI list returned by AWS"
    default = "^Open-EdX-harambee-UAT-RG-\\d+"
}

variable "slack_channel" {
    description = "SlackNotify channel"
    default = "#ci-devstack"
}

variable "slack_path" {
    description = "SlackNotify path"
    default = "THE_SECRET_PATH_OF_SLACK_NOTIFICATIONS"
}
