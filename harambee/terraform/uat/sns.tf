resource "aws_sns_topic" "asg_slack_notify" {
  name = "SlackNotify-ASG"
  display_name = "Autoscaling Notifications to Slack"
}

resource "aws_autoscaling_notification" "slack_notify" {
  group_names = ["${aws_autoscaling_group.asg.name}"]
  notifications  = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
    "autoscaling:TEST_NOTIFICATION"
  ]
  topic_arn = "${aws_sns_topic.asg_slack_notify.arn}"
}

data "archive_file" "notify_js" {
  type = "zip"
  source_file = "asgSlackNotifications.js"
  output_path = "asgSlackNotifications.zip"
}

resource "aws_lambda_function" "slack_notify" {
  depends_on = ["data.archive_file.notify_js"]

  function_name = "asgSlackNotifications"
  description = "Send notifications to Slack when Autoscaling events occur"

  runtime = "nodejs4.3"
  handler = "asgSlackNotifications.handler"

  role = "${aws_iam_role.slack_notify.arn}"

  filename = "${data.archive_file.notify_js.output_path}"
  source_code_hash = "${base64sha256(file(data.archive_file.notify_js.output_path))}"

  environment {
    variables {
      SLACK_CHANNEL = "${var.slack_channel}"
      SLACK_PATH = "${var.slack_path}"
    }
  }
}

#Creating an IAM Roles
resource "aws_iam_role" "slack_notify" {
  name = "SlackNotifications"
  assume_role_policy = "${data.aws_iam_policy_document.assume_lambda_role.json}"
}

resource "aws_iam_role_policy" "slack_notify" {
  name = "SlackNotifications"
  role = "${aws_iam_role.slack_notify.id}"
  policy = "${data.aws_iam_policy_document.slack_notify.json}"
}

#Subscribing to the SNS topic
resource "aws_lambda_permission" "with_sns" {
  statement_id = "AllowExecutionFromSNS"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.slack_notify.arn}"
  principal = "sns.amazonaws.com"
  source_arn = "${aws_sns_topic.asg_slack_notify.arn}"
}

#Create a subscription
resource "aws_sns_topic_subscription" "lambda" {
  depends_on = ["aws_lambda_permission.with_sns"]
  topic_arn = "${aws_sns_topic.asg_slack_notify.arn}"
  protocol = "lambda"
  endpoint = "${aws_lambda_function.slack_notify.arn}"
}
