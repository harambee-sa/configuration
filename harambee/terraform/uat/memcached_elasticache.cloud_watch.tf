
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  alarm_name          = "${var.environment_name}-MemcachedCacheClusterCPUUtilization"
  alarm_description   = "Memcached cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = "${var.memcached_alarm_cpu_threshold_percent}"

  dimensions {
    CacheClusterId = "${aws_elasticache_cluster.memcached.id}"
  }

  alarm_actions = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions    = ["${aws_sns_topic.asg_slack_notify.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  alarm_name          = "${var.environment_name}-MemcachedCacheClusterFreeableMemory"
  alarm_description   = "Memcached cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = "${var.memcached_alarm_memory_threshold_bytes}"

  dimensions {
    CacheClusterId = "${aws_elasticache_cluster.memcached.id}"
  }

  alarm_actions = ["${aws_sns_topic.asg_slack_notify.arn}"]
  ok_actions    = ["${aws_sns_topic.asg_slack_notify.arn}"]
}
