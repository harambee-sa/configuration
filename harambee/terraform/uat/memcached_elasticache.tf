resource "aws_elasticache_subnet_group" "memcached" {
  name = "${var.environment_name}-memcached"
  subnet_ids = ["${aws_subnet.private-1.id}","${aws_subnet.private-2.id}","${aws_subnet.public-1.id}","${aws_subnet.public-2.id}"]
}

resource "aws_elasticache_parameter_group" "memcached" {
  name = "${var.environment_name}-memcached"
  family = "${var.memcached_parameter_group_family}"

  parameter {
    name  = "max_item_size"
    value = "${var.memcached_parameter_group_max_item_size}"
  }
}

#
# Security group resources
#
resource "aws_security_group" "memcached" {
  vpc_id = "${aws_vpc.default.id}"
  name = "${var.environment_name}-memcached"

  ingress {
    from_port       = "11211"                    # Memcache
    to_port         = "11211"
    protocol        = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment_name}-CacheCluster"
    Environment = "${var.environment_name}"
  }
}

#
# ElastiCache resources
#
resource "aws_elasticache_cluster" "memcached" {
  lifecycle {
    create_before_destroy = true
  }

  cluster_id             = "${format("%.16s-%.4s", lower(var.environment_name), md5(var.memcached_instance_type))}"
  engine                 = "memcached"
  engine_version         = "${var.memcached_engine_version}"
  node_type              = "${var.memcached_instance_type}"
  num_cache_nodes        = "${var.memcached_desired_clusters}"
  az_mode                = "${var.memcached_desired_clusters == 1 ? "single-az" : "cross-az"}"
  parameter_group_name   = "${aws_elasticache_parameter_group.memcached.name}"
  subnet_group_name      = "${aws_elasticache_subnet_group.memcached.name}"
  security_group_ids     = ["${aws_security_group.memcached.id}"]
  maintenance_window     = "${var.memcached_maintenance_window}"
  notification_topic_arn = "${aws_sns_topic.asg_slack_notify.arn}"
  port                   = "11211"

  tags {
    Name        = "${var.environment_name}-CacheCluster"
    Environment = "${var.environment_name}"
  }
}

