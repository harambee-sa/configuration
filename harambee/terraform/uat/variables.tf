variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}
variable "aws_mt_private_subnet_key_name" {}
variable "aws_mt_private_subnet_key_path" {}
variable "aws_mt_public_subnet_key_path" {}

variable "environment_name" {
    description = "Environment Name"
    default = "Production"
}

variable "ec2_disable_api_termination" {
    description = "Enables EC2 Instance Termination Protection"
    default = true
}

variable "ec2_env_tag" {
    description = "AWS EC2 snapshot_tag_filter"
    default = "edx"
}

variable "region_location" {
    description = "EC2 Region for the VPC"
    default = ""
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.10.0.0/22"
}

variable "public_subnet_cidr_1" {
    description = "CIDR for the Public Subnet 1"
    default = "10.10.0.0/26"
}

variable "public_subnet_cidr_2" {
    description = "CIDR for the Public Subnet 2"
    default = "10.10.0.64/26"
}

variable "private_subnet_cidr_1" {
    description = "CIDR for the Private Subnet 1"
    default = "10.10.0.128/26"
}

variable "private_subnet_cidr_2" {
    description = "CIDR for the Private Subnet 2"
    default = "10.10.0.192/26"
}

variable "aws_snapshot_lambda_cron" {
    description = "AWS Lambda EC2 snapshots period"
    default = "7,4,6,0"
}

variable "root_block_device_delete_on_termination" {
    description = "Whether the volume should be destroyed on instance termination"
    default = false
}
