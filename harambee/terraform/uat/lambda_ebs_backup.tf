#Creating an IAM Role
resource "aws_iam_role" "lambda_ebs_backup" {
  name = "${var.environment_name}-lambda_ebs_backup"
  assume_role_policy = "${data.aws_iam_policy_document.assume_lambda_role.json}"
}

#Creating an IAM Role Policy
resource "aws_iam_role_policy" "lambda_ebs_backup_policy" {
  name = "lambda_ebs_backup_policy"
  role = "${aws_iam_role.lambda_ebs_backup.id}"
  policy = "${data.aws_iam_policy_document.assume_lambda_ebs_backup_policy.json}"
}

data "archive_file" "ebs_backup" {
    type = "zip"
    source_file = "ebs-backup.py"
    output_path = "ebs-backup.zip"
}

resource "aws_lambda_function" "lambda_ebs_backup" {
    depends_on = ["data.archive_file.ebs_backup"]
    filename = "ebs-backup.zip"
    function_name = "ebs-backup"
    role = "${aws_iam_role.lambda_ebs_backup.arn}"
    handler = "ebs-backup.lambda_handler"
    source_code_hash = "${base64sha256(file("ebs-backup.zip"))}"
    runtime = "python2.7"
    timeout = 60
}

resource "aws_cloudwatch_event_rule" "lambda_ebs_backup" {
    name = "lambda_ebs_backup"
    description = "Run backups once a day"
    schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "lambda_ebs_backup" {
    rule = "${aws_cloudwatch_event_rule.lambda_ebs_backup.name}"
    target_id = "ebs-backup"
    arn = "${aws_lambda_function.lambda_ebs_backup.arn}"
}

resource "aws_lambda_permission" "lambda_ebs_backup" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.lambda_ebs_backup.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.lambda_ebs_backup.arn}"
}
