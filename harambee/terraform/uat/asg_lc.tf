#
#  Launch configuration, Autoscaling group
#

/*
Launch configuration
*/

resource "aws_security_group" "aws_ec2_instance_frontend" {
    name = "${var.environment_name}-${var.ec2_env_tag}"
    description = "Allow incoming HTTP/HTTPS connections."

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress { 
        from_port = 0
        to_port = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "${var.environment_name}-${var.ec2_env_tag}"
    }
}

resource "aws_iam_role" "autoscaling_role" {
  name = "${var.environment_name}-autoscale-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_ec2_role.json}"
}

resource "aws_iam_policy" "autoscale_policy" {
  name        = "${var.environment_name}-autoscale-policy"
  path        = "/"
  description = "Autoscale Policy"
  policy      = "${data.aws_iam_policy_document.assume_autoscaling_role.json}"
}

resource "aws_iam_policy_attachment" "autoscale-policy" {
  name       = "${var.environment_name}-autoscale-attachment"
  roles      = ["${aws_iam_role.autoscaling_role.id}"]
  policy_arn = "${aws_iam_policy.autoscale_policy.arn}"
}

resource "aws_iam_instance_profile" "auto_scale_profile" {
  name = "${var.environment_name}-profile"
  role = "${aws_iam_role.autoscaling_role.name}"
}

# resource "aws_launch_configuration" "as_conf" {
#   name                 = "${var.environment_name}-${var.ec2_env_tag}-lc"
#   image_id             = "${data.aws_ami.autoscaling.id}"
#   instance_type        = "${var.aws_ec2_instance_frontend_type}"
#   iam_instance_profile = "${aws_iam_instance_profile.auto_scale_profile.id}"
#   key_name             = "${var.aws_mt_private_subnet_key_name}"
#   security_groups      = ["${aws_security_group.aws_ec2_instance_frontend.id}"]
#   associate_public_ip_address = false

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_launch_template" "as_launch_template" {
  name                     = "${var.environment_name}-${var.ec2_env_tag}"
  image_id                 = "${data.aws_ami.autoscaling.id}"
  instance_type            = "${var.aws_ec2_instance_frontend_type}"
  key_name             = "${var.aws_mt_private_subnet_key_name}"

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination = true
    security_groups             = ["${aws_security_group.aws_ec2_instance_frontend.id}"]
  }
}

/*
  Auto scaling group
*/

resource "aws_placement_group" "pg" {
  name = "${var.environment_name}-pg"
  # Spreads instances across underlying hardware
  strategy = "spread"
}

# scale up alarm
resource "aws_autoscaling_group" "asg" {
  # depends_on                = ["aws_launch_configuration.as_conf"]
  depends_on                = ["aws_launch_template.as_launch_template"]
  name                      = "${var.environment_name}-asg"
  vpc_zone_identifier       = ["${aws_subnet.private-1.id}", "${aws_subnet.private-2.id}"]
  # launch_configuration      = "${aws_launch_configuration.as_conf.id}"
  launch_template = {
    id = "${aws_launch_template.as_launch_template.id}"
    version = "$$Latest"
  }
  max_size                  = "${var.as_max_nodes}"
  min_size                  = "${var.as_min_nodes}"
  desired_capacity          = "${var.as_desired_nodes}"
  health_check_grace_period = "${var.as_health_check_grace_period}"
  health_check_type         = "ELB"
  termination_policies      = ["OldestInstance"]
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  placement_group           = "${aws_placement_group.pg.id}"

  lifecycle {
    create_before_destroy = false
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.environment_name}-${var.ec2_env_tag}"
      propagate_at_launch = true
    },
  ]
}

resource "aws_autoscaling_policy" "asg_policy_step_up" {
  name                   = "${var.environment_name}-scale"
  adjustment_type        = "PercentChangeInCapacity"
  policy_type            = "StepScaling"
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
  estimated_instance_warmup = 90

  # Step 1 (Normal)
  step_adjustment {
    scaling_adjustment          = "${var.step_up_scaling_adjustment_normal}"
    metric_interval_lower_bound = 0 # Zero over CW threshold
    metric_interval_upper_bound = 50 # 15 over CW threshold (40 + 15 = 90)
  }

  # Step 2 (Spike)
  step_adjustment {
    scaling_adjustment          = "${var.step_up_scaling_adjustment_spike}"
    metric_interval_lower_bound = 50 # 45 over CW threshold (40 + 45 = 90)
  }
}

resource "aws_autoscaling_policy" "asg_policy_step_down" {
  name                   = "${var.environment_name}-scaledown"
  adjustment_type        = "PercentChangeInCapacity"
  policy_type            = "StepScaling"
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"

  # Step 1 (Normal)
  step_adjustment {
    scaling_adjustment          = -15
    metric_interval_upper_bound = 0 # 0 over CW threshold (7 + 0 = 7)
  }

}

