data "aws_iam_policy_document" "assume_ec2_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_lambda_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_lambda_ebs_backup_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:DeleteSnapshot",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

data "aws_iam_policy_document" "slack_notify" {
  statement {
    sid = "CloudwatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:GetLogEvents",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

data "aws_iam_policy_document" "assume_autoscaling_role" {
  statement {
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingInstances",
      "ec2:DescribeInstances",
    ]

    resources = [
      "*",
    ]

  }
}


