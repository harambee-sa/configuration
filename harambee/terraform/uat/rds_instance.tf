/*
  AWS RDS Instance
*/

resource "aws_db_instance" "main_rds_instance" {
  identifier        = "${var.environment_name}-rds"
  allocated_storage = "${var.rds_allocated_storage}"
  engine            = "${var.rds_engine_type}"
  engine_version    = "${var.rds_engine_version}"
  instance_class    = "${var.rds_instance_class}"
  name              = "${var.database_name}"
  username          = "${var.database_user}"
  password          = "${var.database_password}"

  port = "${var.database_port}"

  # Because we're assuming a VPC, we use this option, but only one SG id
  vpc_security_group_ids = ["${aws_security_group.main_db_access.id}"]

  # We're creating a subnet group in the module and passing in the name
  db_subnet_group_name = "${aws_db_subnet_group.main_db_subnet_group.name}"
  parameter_group_name = "${aws_db_parameter_group.main_rds_instance.id}"

  # We want the multi-az setting to be toggleable, but off by default
  multi_az            = "${var.rds_is_multi_az}"
  storage_type        = "${var.rds_storage_type}"
  iops                = "${var.rds_iops}"
  publicly_accessible = "${var.publicly_accessible}"

  # Upgrades
  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  apply_immediately           = "${var.apply_immediately}"
  maintenance_window          = "${var.maintenance_window}"

  # Snapshots and backups
  skip_final_snapshot   = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot = "${var.copy_tags_to_snapshot}"

  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags {
    Name = "${var.environment_name}-rds"
  }
}

resource "aws_db_parameter_group" "main_rds_instance" {
  name   = "${var.environment_name}-rds-${replace(var.db_parameter_group, ".", "")}-custom-params"
  family = "${var.db_parameter_group}"

  parameter {
    name = "character_set_server"
    value = "utf8"
  }

  parameter {
    name = "net_read_timeout"
    value = "180"
  }

  parameter {
    name = "net_write_timeout"
    value = "180"
  }

  parameter {
    name = "character_set_client"
    value = "utf8"
  }

  parameter {
    name = "general_log"
    value = "0"
  }

  parameter {
    name = "slow_query_log"
    value = "1"
  }

  parameter {
    name = "long_query_time"
    value = "2"
  }

  parameter {
    name = "log_output"
    value = "file"
  }
# ----------------------------------
  parameter {
    name = "key_buffer_size"
    value = "33554432"
  }

  parameter {
    name = "tmp_table_size"
    value = "33554432"
  }

  parameter {
    name = "max_heap_table_size"
    value = "33554432"
  }

  parameter {
    name = "query_cache_type"
    value = "0"
  }

  # # parameter {
  # #   name = "max_connections"
  # #   value = "600"
  # # }

  parameter {
    name = "thread_cache_size"
    value = "50"
  }

  parameter {
    name = "thread_cache_size"
    value = "50"
  }

  # # parameter {
  # #   name = "innodb_open_files"
  # #   value = "65535"
  # # }

  parameter {
    name = "table_definition_cache"
    value = "4096"
  }
# ----------------------------------
  tags {
    Name = "${var.environment_name}-rds"
  }
}

resource "aws_db_subnet_group" "main_db_subnet_group" {
  name        = "${var.environment_name}-rds-subnetgrp"
  description = "RDS subnet group"
  subnet_ids  = ["${aws_subnet.private-1.id}","${aws_subnet.private-2.id}"]

  tags {
    Name = "${var.environment_name}-rds"
  }
}

# Security groups
resource "aws_security_group" "main_db_access" {
  name        = "${var.environment_name}-rds-access"
  description = "Allow access to the database"
  vpc_id      = "${aws_vpc.default.id}"

  tags {
    Name = "${var.environment_name}-rds"
  }
}

resource "aws_security_group_rule" "allow_db_access" {
  type = "ingress"

  from_port   = "${var.database_port}"
  to_port     = "${var.database_port}"
  protocol    = "tcp"
  cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]

  security_group_id = "${aws_security_group.main_db_access.id}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type = "egress"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.main_db_access.id}"
}
