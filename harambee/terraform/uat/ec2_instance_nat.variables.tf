
variable "nat_instance_type" {
    description = "AWS EC2 Instance type"
    default = "t2.small"
}

variable "nat_root_volume_size" {
    description = "NAT Instance Root Volume Size"
    default = "50"
}

variable "nat_root_volume_type" {
    description = "NAT Instance Root Volume Type"
    default = "gp2"
}

