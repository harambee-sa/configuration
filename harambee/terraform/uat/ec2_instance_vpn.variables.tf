
variable "vpn_instance_type" {
    description = "AWS EC2 Instance type"
    default = "t2.small"
}

variable "vpn_root_volume_size" {
    description = "VPN Instance Root Volume Size"
    default = "50"
}

variable "vpn_root_volume_type" {
    description = "VPN Instance Root Volume Type"
    default = "gp2"
}

