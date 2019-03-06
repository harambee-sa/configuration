variable "services_instance_type" {
    description = "services Instances Type"
    default = "c5.large"
}

variable "services_root_volume_size" {
    description = "services Root Volume Size"
    default = "50"
}

variable "services_root_volume_type" {
    description = "services Root Volume Type"
    default = "gp2"
}

# variable "services_ebs_volume_size" {
#     description = "db_instance Additional Volume Size"
#     default = "50"
# }

# variable "services_ebs_volume_type" {
#     description = "db_instance Additional Volume Type"
#     default = "gp2"
# }
