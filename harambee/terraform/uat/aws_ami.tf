/*
  Use terraform data source to get the ID of a registered AMI for use in other resources.
*/

/* AWS EC2 Instances AMI for Autoscaling*/
data "aws_ami" "autoscaling" {
  most_recent      = true
  name_regex = "${var.aws_ec2_ami_autoscaling_regexp}"
  owners     = ["self"]
}

# /* Main AWS EC2 Instances */
# data "aws_ami" "ubuntu" {
#   most_recent      = true

#   filter {
#       name   = "name"
#       values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
#   }

#   filter {
#     name   = "state"
#     values = ["available"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "block-device-mapping.volume-type"
#     values = ["gp2"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# /* VPN EC2 Instances */
# data "aws_ami" "vpn" {
#   most_recent      = true

#   filter {
#       name   = "name"
#       values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
#   }

#   filter {
#     name   = "state"
#     values = ["available"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "block-device-mapping.volume-type"
#     values = ["gp2"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# /* NAT AWS EC2 Instance */
# data "aws_ami" "amazon" {
#   most_recent      = true
  
#   filter {
#     name   = "owner-alias"
#     values = ["amazon"]
#   }

#   filter {
#     name   = "name"
#     values = ["amzn-ami-vpc-nat-hvm-*x86_64*"]
#   }

#   filter {
#     name   = "state"
#     values = ["available"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   # filter {
#   #   name   = "block-device-mapping.volume-type"
#   #   values = ["gp2"]
#   # }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

# }
