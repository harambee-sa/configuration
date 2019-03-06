# resource "aws_elasticache_subnet_group" "redis" {
#   name = "${var.environment_name}-redis"
#   subnet_ids = ["${aws_subnet.private-1.id}","${aws_subnet.private-2.id}","${aws_subnet.public-1.id}","${aws_subnet.public-2.id}"]
# }

# resource "aws_elasticache_parameter_group" "redis" {
#   name = "${var.environment_name}-redis"
#   family = "${var.redis_parameter_group_family}"

# }

# #
# # Security group resources
# #
# resource "aws_security_group" "redis" {
#   vpc_id = "${aws_vpc.default.id}"
#   name = "${var.environment_name}-redis"

#   ingress {
#     from_port       = "6379"                    # redis
#     to_port         = "6379"
#     protocol        = "tcp"
#     cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags {
#     Name        = "${var.environment_name}-RedisCluster"
#     Environment = "${var.environment_name}"
#   }
# }

# #
# # ElastiCache resources
# #
# resource "aws_elasticache_cluster" "redis" {
#   lifecycle {
#     create_before_destroy = true
#   }

#   cluster_id             = "${format("%.16s-%.4s", lower(var.environment_name), md5(var.redis_instance_type))}"
#   engine                 = "redis"
#   engine_version         = "${var.redis_engine_version}"
#   node_type              = "${var.redis_instance_type}"
#   num_cache_nodes        = "${var.redis_desired_clusters}"
#   az_mode                = "${var.redis_desired_clusters == 1 ? "single-az" : "cross-az"}"
#   parameter_group_name   = "${aws_elasticache_parameter_group.redis.name}"
#   subnet_group_name      = "${aws_elasticache_subnet_group.redis.name}"
#   security_group_ids     = ["${aws_security_group.redis.id}"]
#   maintenance_window     = "${var.redis_maintenance_window}"
#   notification_topic_arn = "${aws_sns_topic.asg_slack_notify.arn}"
#   port                   = "6379"

#   tags {
#     Name        = "${var.environment_name}-RedisCluster"
#     Environment = "${var.environment_name}"
#   }
# }
