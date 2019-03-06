# /*
# CloudWatch Metric Alarms
# */

/*
CloudWatch Metric Alarms for Autoscaling Group
*/

# scale-up alarm
resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scaleup" {
  actions_enabled     = true
  alarm_actions       = ["${aws_autoscaling_policy.asg_policy_step_up.arn}", "${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${aws_autoscaling_group.asg.name}-cpu-alarm-scaleup"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
  }

  evaluation_periods = "1"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = "${var.cpu_utilization_scaleup_period}"
  statistic          = "Average"
  threshold          = "${var.cpu_utilization_upper_bound}"
}

# scale-down alarm
resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scaledown" {
  actions_enabled     = true
  alarm_actions       = ["${aws_autoscaling_policy.asg_policy_step_down.arn}", "${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
  alarm_name          = "${aws_autoscaling_group.asg.name}-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
  }

  evaluation_periods = "1"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = "2400"
  statistic          = "Average"
  threshold          = "${var.cpu_utilization_lower_bound}"
}

# # Memory alarm - warning
# resource "aws_cloudwatch_metric_alarm" "ASG_EC2_MemoryWarning" {
#   alarm_name = "${aws_autoscaling_group.asg.name}-EC2 Instances MemoryWarning"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods = "1"
#   metric_name = "MemoryUtilization"
#   namespace = "System/Linux"
#   period = "120"
#   statistic = "Average"
#   threshold = "${var.memory_warning}"

#   dimensions = {
#     "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
#   }

#   alarm_description = "${var.environment_name} - warning for high memory usage"
#   alarm_actions = ["${aws_sns_topic.asg_slack_notify.arn}"]
#   ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
# }

# # Memory alarm - critical
# resource "aws_cloudwatch_metric_alarm" "ASG_EC2_MemoryCritical" {
#   alarm_name = "${aws_autoscaling_group.asg.name}-EC2 Instances MemoryCritical"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods = "1"
#   metric_name = "MemoryUtilization"
#   namespace = "System/Linux"
#   period = "120"
#   statistic = "Average"
#   threshold = "${var.memory_critical}"

#   dimensions = {
#     "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
#   }

#   alarm_description = "${var.environment_name} - critical for high memory usage"
#   alarm_actions = ["${aws_sns_topic.asg_slack_notify.arn}"]
#   ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
# }

# # Disk space alarm - warning
# resource "aws_cloudwatch_metric_alarm" "ASG_EC2_DiskSpaceWarning" {
#   alarm_name = "${aws_autoscaling_group.asg.name}-EC2 Instances DiskSpaceWarning"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods = "1"
#   metric_name = "DiskSpaceUtilization"
#   namespace = "System/Linux"
#   period = "120"
#   statistic = "Average"
#   threshold = "${var.diskspace_warning}"

#   dimensions = {
#     "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
#   }

#   alarm_description = "${var.environment_name} - warning for low available disk space"
#   alarm_actions = ["${aws_sns_topic.asg_slack_notify.arn}"]
#   ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
# }

# # Disk space - critical
# resource "aws_cloudwatch_metric_alarm" "ASG_EC2_DiskSpaceCritical" {
#   alarm_name = "${aws_autoscaling_group.asg.name}-EC2 Instances DiskSpaceCritical"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods = "1"
#   metric_name = "DiskSpaceUtilization"
#   namespace = "System/Linux"
#   period = "120"
#   statistic = "Average"
#   threshold = "${var.diskspace_critical}"

#   dimensions = {
#     "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
#   }
  
#   alarm_description = "${var.environment_name} - critical for low available disk space"
#   alarm_actions = ["${aws_sns_topic.asg_slack_notify.arn}"]
#   ok_actions          = ["${aws_sns_topic.asg_slack_notify.arn}"]
# }


