# /*
# CloudWatch Metric Alarms
# */

/*
CloudWatch Metric Alarms for EC2 Instances not in Autoscaling Group
*/

# resource "aws_cloudwatch_metric_alarm" "VPN_CPUUtilization" {
#   actions_enabled     = true
#   alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
#   ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
#   alarm_name          = "${var.environment_name}-VPN_CPUUtilization"
#   comparison_operator = "GreaterThanOrEqualToThreshold"

#   dimensions = {
#     # InstanceId = "${aws_instance.mongodb-1.id}",
#     # InstanceId = "${aws_instance.mongodb-2.id}",
#     # InstanceId = "${aws_instance.services.id}",
#     InstanceId = "${aws_instance.vpn.id}"
#   }

#   evaluation_periods = "1"
#   metric_name        = "CPUUtilization"
#   namespace          = "AWS/EC2"
#   period             = "60"
#   statistic          = "Average"
#   threshold          = "${var.cpu_utilization_upper_bound}"
# }

# Memory alarm - warning
resource "aws_cloudwatch_metric_alarm" "VPN_MemoryWarning" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-VPN_MemoryWarning"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.memory_warning}"

  dimensions = {
    # InstanceId = "${aws_instance.mongodb-1.id}",
    # InstanceId = "${aws_instance.mongodb-2.id}",
    # InstanceId = "${aws_instance.services.id}",
    InstanceId = "${aws_instance.vpn.id}"
  }

  alarm_description = "${var.environment_name} - warning for high memory usage"
}

# Memory alarm - critical
resource "aws_cloudwatch_metric_alarm" "VPN_MemoryCritical" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-VPN_MemoryCritical"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.memory_critical}"

  dimensions = {
    # InstanceId = "${aws_instance.mongodb-1.id}",
    # InstanceId = "${aws_instance.mongodb-2.id}",
    # InstanceId = "${aws_instance.services.id}",
    InstanceId = "${aws_instance.vpn.id}"
  }

  alarm_description = "${var.environment_name} - critical for high memory usage"
}

# Disk space alarm - warning
resource "aws_cloudwatch_metric_alarm" "VPN_DiskSpaceWarning" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-VPN_DiskSpaceWarning"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskSpaceAvailable"
  namespace           = "System/Linux"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.diskspace_warning}"

  dimensions = {
    # InstanceId = "${aws_instance.mongodb-1.id}",
    # InstanceId = "${aws_instance.mongodb-2.id}",
    # InstanceId = "${aws_instance.services.id}",
    InstanceId = "${aws_instance.vpn.id}"
    MountPath = "/"
    Filesystem = "/dev/xvda1"
  }

  alarm_description = "${var.environment_name} - warning for low available disk space"
}

# Disk space - critical
resource "aws_cloudwatch_metric_alarm" "VPN_DiskSpaceCritical" {
  actions_enabled     = true
  alarm_actions       = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${var.environment_name}-VPN_DiskSpaceCritical"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskSpaceAvailable"
  namespace           = "System/Linux"
  period              = "120"
  statistic           = "Average"
  threshold           = "${var.diskspace_critical}"

  dimensions = {
    # InstanceId = "${aws_instance.mongodb-1.id}",
    # InstanceId = "${aws_instance.mongodb-2.id}",
    # InstanceId = "${aws_instance.services.id}",
    InstanceId = "${aws_instance.vpn.id}"
    MountPath = "/"
    Filesystem = "/dev/xvda1"
  }
  
  alarm_description = "${var.environment_name} - critical for low available disk space"
}

