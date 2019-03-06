# /*
# CloudWatch Metric Alarms
# */

/*
CloudWatch Metric Alarms for EC2 Instances not in Autoscaling Group
*/

//Mongo-1

resource "aws_cloudwatch_metric_alarm" "MongoDB1_CPUUtilization" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-MongoDB1_CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    InstanceId = "${aws_instance.mongodb-1.id}"
  }

  evaluation_periods = "1"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = "60"
  statistic          = "Average"
  threshold          = "${var.cpu_utilization_upper_bound}"
}

# Memory alarm - warning
resource "aws_cloudwatch_metric_alarm" "MongoDB1_MemoryWarning" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-MongoDB1_MemoryWarning"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.memory_warning}"

  dimensions = {
    InstanceId = "${aws_instance.mongodb-1.id}"
  }

  alarm_description = "${var.environment_name} - warning for high memory usage"
}

# Memory alarm - critical
resource "aws_cloudwatch_metric_alarm" "MongoDB1_MemoryCritical" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-MongoDB1_MemoryCritical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.memory_critical}"

  dimensions = {
    InstanceId = "${aws_instance.mongodb-1.id}"
  }

  alarm_description = "${var.environment_name} - critical for high memory usage"
}

# Disk space alarm - warning
resource "aws_cloudwatch_metric_alarm" "MongoDB1_DiskSpaceWarning" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-MongoDB1_DiskSpaceWarning"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskSpaceAvailable"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.diskspace_warning}"

  dimensions = {
    InstanceId = "${aws_instance.mongodb-1.id}"
    MountPath = "/"
    Filesystem = "/dev/nvme0n1p1"
  }

  alarm_description = "${var.environment_name} - warning for low available disk space"
}

# Disk space - critical
resource "aws_cloudwatch_metric_alarm" "MongoDB1_DiskSpaceCritical" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-MongoDB1_DiskSpaceCritical"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskSpaceAvailable"
  namespace           = "System/Linux"
  period              = "120"
  statistic           = "Average"
  threshold           = "${var.diskspace_critical}"

  dimensions = {
    InstanceId = "${aws_instance.mongodb-1.id}"
    MountPath = "/"
    Filesystem = "/dev/nvme0n1p1"
  }
  
  alarm_description = "${var.environment_name} - critical for low available disk space"
}

//Mongo-2

resource "aws_cloudwatch_metric_alarm" "MongoDB2_CPUUtilization" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-MongoDB2_CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    InstanceId = "${aws_instance.mongodb-2.id}"
  }

  evaluation_periods = "1"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = "60"
  statistic          = "Average"
  threshold          = "${var.cpu_utilization_upper_bound}"
}

# Memory alarm - warning
resource "aws_cloudwatch_metric_alarm" "MongoDB2_MemoryWarning" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-MongoDB2_MemoryWarning"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.memory_warning}"

  dimensions = {
    InstanceId = "${aws_instance.mongodb-2.id}"
  }

  alarm_description = "${var.environment_name} - warning for high memory usage"
}

# Memory alarm - critical
resource "aws_cloudwatch_metric_alarm" "MongoDB2_MemoryCritical" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-MongoDB2_MemoryCritical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.memory_critical}"

  dimensions = {
    InstanceId = "${aws_instance.mongodb-2.id}"
  }

  alarm_description = "${var.environment_name} - critical for high memory usage"
}

# Disk space alarm - warning
resource "aws_cloudwatch_metric_alarm" "MongoDB2_DiskSpaceWarning" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-MongoDB2_DiskSpaceWarning"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskSpaceAvailable"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.diskspace_warning}"

  dimensions = {
    InstanceId = "${aws_instance.mongodb-2.id}"
    MountPath = "/"
    Filesystem = "/dev/nvme0n1p1"
  }

  alarm_description = "${var.environment_name} - warning for low available disk space"
}

# Disk space - critical
resource "aws_cloudwatch_metric_alarm" "MongoDB2_DiskSpaceCritical" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-MongoDB2_DiskSpaceCritical"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskSpaceAvailable"
  namespace           = "System/Linux"
  period              = "120"
  statistic           = "Average"
  threshold           = "${var.diskspace_critical}"

  dimensions = {
    InstanceId = "${aws_instance.mongodb-2.id}"
    MountPath = "/"
    Filesystem = "/dev/nvme0n1p1"
  }
  
  alarm_description = "${var.environment_name} - critical for low available disk space"
}


