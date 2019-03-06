# Initializing terraform

```
cp secrets.sh_example secrets.sh
ed secrets.sh  # configure AWS credentials
source secrets.sh
terraform init
terraform plan # verify creds, and check configuration
               # and state is actual and correctly loaded from S3
```

# Create AWS OpenEdX single infrastructure
## Required permissions
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:DeleteRole",
                "iam:CreateRole",
                "iam:PutRolePolicy",
                "iam:ListInstanceProfilesForRole",
                "iam:CreateInstanceProfile",
                "iam:CreatePolicy",
                "iam:AttachRolePolicy",
                "iam:DetachRolePolicy",
                "iam:PassRole",
                "iam:DeleteRolePolicy",
                "iam:GetInstanceProfile",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:ListEntitiesForPolicy",
                "iam:ListPolicyVersions",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:DeleteInstanceProfile",
                "iam:ListRolePolicies",
                "iam:GetRolePolicy",
                "iam:DeletePolicy",
                "iam:AddRoleToInstanceProfile",
                "iam:CreateServiceLinkedRole",
                "apigateway:PATCH",
                "lambda:*",
                "sns:*",
                "ec2:*",
                "apigateway:PUT",
                "apigateway:POST",
                "apigateway:GET",
                "apigateway:DELETE",
                "events:*",
                "elasticloadbalancing:*",
                "es:*",
                "rds:*",
                "autoscaling:DescribeAutoScalingGroups",
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DeleteAlarms",
                "cloudwatch:PutMetricData",
                "autoscaling:*",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribePolicies",
                "autoscaling:DescribeNotificationConfigurations",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeNotificationConfigurations",
                "autoscaling:PutScalingPolicy",
                "elasticache:*",
                "elasticache:CreateCacheParameterGroup",
                "elasticache:CreateCacheSubnetGroup",
            ],
            "Resource": "*"
        }
    ]
}
```
## EC2 Snapshot Configuration (AWS CloudWatch vs AWS Lambda)

Just add a Tag named LambdaBackupConfiguration to your EC2 instances with the following format:

`[RetentionDaily],[RetentionWeekly],[RetentionMonthly],[RetentionYearly]`

Examples:
- `7,4,12,1` to have 7 daily, 4 weekly, 12 monthly and 1 yearly backup
- `7,0,3,0` to have 7 daily, 3 monthly backups
- `0,4,0,0` to have 4 weekly backups

Only one backup per day will be created (due to parallel snapshot limitations of AWS).
Weekly backups will be created on Sunday, monthly backups on 1st day of the month and yearly
backups on 1st of January.
If you specify 0 for a weekly, monthly or yearly Retention, a backup for the next group
(monthly instead of yearly, weekly instead of monthly and daily instead of weekly) will be made.
