/*
  Load balancer
*/

resource "aws_security_group" "lb" {
    name = "${var.environment_name}-lb"
    description = "Allow incoming HTTP/HTTPS connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        self = true #If true, the security group itself will be added as a source to this ingress rule.
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        self = true #If true, the security group itself will be added as a source to this ingress rule.
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "${var.environment_name} ALB"
    }
}

resource "aws_alb" "lb" {
  name               = "${var.environment_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb.id}"]
  subnets            = ["${aws_subnet.public-1.id}", "${aws_subnet.public-2.id}"]
  enable_deletion_protection = false
  idle_timeout       = 120
  tags = {
    Name = "${var.environment_name} ALB"
    Environment = "${var.environment_name}"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.lb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-1:191523250427:certificate/8f5d4a1c-6255-400a-a4c9-752f5c0ca9a8"


  # Be sure to create an aws_alb_target_group first
  default_action {
    target_group_arn = "${aws_alb_target_group.lb.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = ["aws_alb_target_group.lb"]  
  listener_arn = "${aws_alb_listener.alb_listener.arn}"  
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.lb.id}"
  }
  condition {    
    field  = "${var.listener_condition_field}"
    values = "${var.listener_condition_values}"
  }
}

resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn = "${aws_alb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  # Be sure to create an aws_alb_target_group first
  default_action {
    target_group_arn = "${aws_alb_target_group.lb.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "listener_rule_http" {
  depends_on   = ["aws_alb_target_group.lb"]  
  listener_arn = "${aws_alb_listener.alb_listener_http.arn}"  
  priority     = 99
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.lb.id}"
  }
  condition {    
    field  = "${var.listener_condition_field}"
    values = "${var.listener_condition_values}"
  }
}

resource "aws_alb_target_group" "lb" {
  name_prefix          = "lb-"
  port                 = 8080
  protocol             = "HTTP"
  # deregistration_delay = 300
  # slow_start           = 900
  vpc_id               = "${aws_vpc.default.id}"

  health_check = {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 30
    interval            = 60
    port                = 8080
    path                = "${var.alb_target_group_health_check_path}"
  }

  tags = {
    Name = "${var.environment_name} ALB"
    Environment = "${var.environment_name}"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
  alb_target_group_arn   = "${aws_alb_target_group.lb.arn}"
}

# resource "aws_elb" "lb" {
#     name = "${var.environment_name}"
#     security_groups    = ["${aws_security_group.lb.id}"]
#     subnets            = ["${aws_subnet.public-1.id}", "${aws_subnet.public-2.id}"]

#     health_check = {
#       healthy_threshold   = 2
#       unhealthy_threshold = 3
#       timeout             = 10
#       interval            = 30
#       target                = "HTTP:80/"
#     }

#     listener {
#         lb_port     = "80"
#         lb_protocol = "http"

#         instance_port     = "80"
#         instance_protocol = "http"
#     }

#     cross_zone_load_balancing   = true
#     idle_timeout                = 60
#     connection_draining         = true
#     connection_draining_timeout = 200


#   tags = {
#     Name = "${var.environment_name} ELB"
#     Environment = "${var.environment_name}"
#   }
# }

# resource "aws_autoscaling_attachment" "asg_attachment" {
#   autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
#   elb                    = "${aws_elb.lb.id}"
# }
