variable "aws_ec2_instance_frontend_type" {
    description = "AWS EC2 instance type"
    default = "c5.xlarge"
}

variable "aws_ec2_root_volume_size" {
    description = "AWS EC2 Root Volume Size"
    default = "100"
}

variable "aws_ec2_ami_autoscaling_regexp" {
    description = "A regex string to apply to the AMI list returned by AWS"
    default = "^Open-EdX-\\w+-RG-\\d+"
}

variable "as_min_nodes" {
  description = "Min number of nodes for autoscaling"
  default = "2"
}

variable "as_max_nodes" {
  description = "Max number of nodes for autoscaling"
  default = "5"
}

variable "as_desired_nodes" {
  description = "Desired number of nodes for autoscaling"
  default = "2"
}

variable "as_health_check_grace_period" {
  description = "health_check_grace_period for autoscaling"
  default = "600"
}

variable "step_up_scaling_adjustment_normal" {
  description = "The number of instances by which to scale (PercentChangeInCapacity) for normal threshold."
  default = "15"
}

variable "step_up_scaling_adjustment_spike" {
  description = "The number of instances by which to scale (PercentChangeInCapacity) for spike threshold."
  default = "30"
}
