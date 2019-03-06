variable "db_instance_type" {
    description = "Mongo DB Instances Type"
    default = "c5.large"
}

variable "db_instance_root_volume_size" {
    description = "db_instance Root Volume Size"
    default = "150"
}

variable "db_instance_root_volume_type" {
    description = "db_instance Root Volume Type"
    default = "gp2"
}

# variable "db_instance_ebs_volume_size" {
#     description = "db_instance Additional Volume Size"
#     default = "100"
# }

# variable "db_instance_ebs_volume_type" {
#     description = "db_instance Additional Volume Type"
#     default = "gp2"
# }
