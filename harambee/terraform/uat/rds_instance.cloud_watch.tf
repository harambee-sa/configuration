# /*
# CloudWatch Metric Alarms
# */

/*
CloudWatch Metric Alarms for RDS Instance
*/

resource "aws_cloudwatch_metric_alarm" "alarm_rds_CPU" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_cpu_threshold}"
  unit                = "Percent"
  alarm_description   = "High CPU on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_FreeStorageSpace" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_FreeStorageSpace"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_min_storagespace_threshold/100.0 * 1000000000 * var.rds_allocated_storage}"
  alarm_description   = "Low Storage Space on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_FreeableMemory" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_FreeableMemory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "3"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_min_freememory_threshold/100.0 * var.rds_memory[var.rds_instance_class]}"
  alarm_description   = "High Memory Usage on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_DatabaseConnections" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_DatabaseConnections"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_memory[var.rds_instance_class]/12582880.0 * var.rds_connections_threshold/100.0}"
  alarm_description   = "High DB Connections on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }
}

# the following two alarms apply when the storage volume is Provisioned IOPS

resource "aws_cloudwatch_metric_alarm" "alarm_rds_WriteIOPS" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_WriteIOPS"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "WriteIOPS"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.rds_write_iops_threshold/100.0 * var.rds_iops}"
  alarm_description   = "High Write IOPS on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }

  count = "${var.rds_storage_type == "io1" ? "1" : "0"}"
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_ReadIOPS" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_ReadIOPS"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ReadIOPS"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.rds_read_iops_threshold/100.0 * var.rds_iops}"
  alarm_description   = "High Read IOPS on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }

  count = "${var.rds_storage_type == "io1" ? "1" : "0"}"
}

# the following four alarms apply when the storage volume is General Purpose SSD

resource "aws_cloudwatch_metric_alarm" "alarm_rds_WriteIOPS_burst" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_WriteIOPS_burst"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "WriteIOPS"
  namespace           = "AWS/RDS"
  period              = "120"
  statistic           = "Average"
  threshold           = "2400.0"
  alarm_description   = "High Write Bursts on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }

  count = "${var.rds_storage_type == "gp2" ? "1" : "0"}"
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_ReadIOPS_burst" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_ReadIOPS_burst"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "ReadIOPS"
  namespace           = "AWS/RDS"
  period              = "120"
  statistic           = "Average"
  threshold           = "2400.0"
  alarm_description   = "High Read Bursts on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }

  count = "${var.rds_storage_type == "gp2" ? "1" : "0"}"
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_WriteIOPS_general" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_WriteIOPS_general"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "WriteIOPS"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.rds_write_iops_threshold/100.0 * 3 * var.rds_allocated_storage}"
  alarm_description   = "High Write IOPS on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }

  count = "${var.rds_storage_type == "gp2" ? "1" : "0"}"
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_ReadIOPS_general" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_ReadIOPS_general"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ReadIOPS"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.rds_read_iops_threshold/100.0 * 3 * var.rds_allocated_storage}"
  alarm_description   = "High Read IOPS on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }

  count = "${var.rds_storage_type == "gp2" ? "1" : "0"}"
}

# the following two alarms apply when the storage volume is Magnetic
# assuming that 500 is the maximum number of IOPS for magnetic storage:
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html#EBSVolumeTypes_standard

resource "aws_cloudwatch_metric_alarm" "alarm_rds_WriteIOPS_magnetic" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_WriteIOPS_magnetic"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "WriteIOPS"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.rds_write_iops_threshold/100.0 * 500}"
  alarm_description   = "High Write IOPS on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }

  count = "${var.rds_storage_type == "standard" ? "1" : "0"}"
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_ReadIOPS_magnetic" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_ReadIOPS_magnetic"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ReadIOPS"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.rds_read_iops_threshold/100.0 * 500}"
  alarm_description   = "High Read IOPS on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }

  count = "${var.rds_storage_type == "standard" ? "1" : "0"}"
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_SwapUsage" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_SwapUsage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "SwapUsage"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_swapusage_threshold}"
  alarm_description   = "High Swap Usage on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_NetworkIn" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_NetworkIn"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "NetworkReceiveThroughput"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_network_in_threshold/100.0 * var.bandwidth[var.rds_instance_class]}"
  alarm_description   = "High Network In traffic on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_NetworkOut" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_NetworkOut"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "NetworkTransmitThroughput"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_network_out_threshold/100.0 * var.bandwidth[var.rds_instance_class]}"
  alarm_description   = "High Network Out traffic on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_ReadLatency" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_ReadLatency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "ReadLatency"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_read_latency_threshold}"
  alarm_description   = "High Read Latency on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_WriteLatency" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_WriteLatency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "WriteLatency"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_write_latency_threshold}"
  alarm_description   = "High Write Latency on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }
}

# Read and Write Throughput alarms are created only if the user sets the variables max_read_throughput and max_write_throughput

resource "aws_cloudwatch_metric_alarm" "alarm_rds_ReadThroughput" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_ReadThroughput"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "ReadThroughput"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_read_throughput_threshold}"
  alarm_description   = "High Read Throughput on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }

  count = "${var.rds_read_throughput_threshold == "" ? "0" : "1"}"
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_WriteThroughput" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_WriteThroughput"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "WriteThroughput"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_write_throughput_threshold}"
  alarm_description   = "High Write Throughput on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }

  count = "${var.rds_write_throughput_threshold == "" ? "0" : "1"}"
}

resource "aws_cloudwatch_metric_alarm" "alarm_rds_DiskQueueDepth" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_DiskQueueDepth"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_disk_queue_threshold}"
  alarm_description   = "High Disk Queue Depth on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }
}

# The following alarm for Bin Log Disk Usage is created only when rds_binlog_threshold is set.

resource "aws_cloudwatch_metric_alarm" "alarm_rds_BinLogDiskUsage" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_BinLogDiskUsage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "BinLogDiskUsage"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.rds_binlog_threshold}"
  alarm_description   = "High Binlog Disk Usage on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }

  count = "${var.rds_binlog_threshold == "" ? "0" : "1"}"
}

# resource "aws_cloudwatch_metric_alarm" "alarm_rds_ReplicaLag" {
#   alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_ReplicaLag"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "ReplicaLag"
#   namespace           = "AWS/RDS"
#   period              = "300"
#   statistic           = "Average"
#   threshold           = "${var.rds_replica_lag_threshold}"
#   alarm_description   = "High Replica Lag on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
#   actions_enabled     = true
#   alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
#   ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

#   dimensions {
#     DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
#   }
# }

resource "aws_cloudwatch_metric_alarm" "alarm_rds_BurstBalance" {
  alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_BurstBalance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = "${min(max(var.rds_burst_balance_threshold, 0), 100)}"
  alarm_description   = "Average database storage burst balance over last 10 minutes too low, expect a significant performance drop soon"
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

  dimensions {
    DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
  }
}

# resource "aws_cloudwatch_metric_alarm" "alarm_rds_CPUCreditBalance" {
#   alarm_name          = "${aws_db_instance.main_rds_instance.identifier}_alarm_rds_CPUCreditBalance"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = "3"
#   metric_name         = "CPUCreditBalance"
#   namespace           = "AWS/RDS"
#   period              = "300"
#   statistic           = "Average"
#   threshold           = "${var.rds_min_credits == "" ? "${var.rds_credits[var.rds_instance_class]}" : "${var.rds_min_credits}"}"
#   alarm_description   = "Low CPU credit balance on RDS ${aws_db_instance.main_rds_instance.identifier} Instance"
#   actions_enabled     = true
#   alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  # ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]

#   dimensions {
#     DBInstanceIdentifier = "${aws_db_instance.main_rds_instance.identifier}"
#   }

#   count = "${var.rds_instance_class == "db.t2.micro" || var.rds_instance_class == "db.t2.large" || var.rds_instance_class == "db.t2.small" || var.rds_instance_class == "db.t2.medium" ? "1" : "0"}"
# }
