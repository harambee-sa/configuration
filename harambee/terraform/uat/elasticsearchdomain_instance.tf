# /*
#  Elasticsearch Domain
# */
# resource "aws_elasticsearch_domain" "es" {
#   domain_name           = "${var.environment_name}-es"
#   elasticsearch_version = "1.5"
#   cluster_config {
#     instance_type = "t2.small.elasticsearch"
#     instance_count = 1
#     dedicated_master_enabled = false
#     zone_awareness_enabled = false
#   }

#   ebs_options {
#     ebs_enabled = true
#     volume_type = "gp2"
#     volume_size = 30
#   }

#   advanced_options {
#     "rest.action.multi.allow_explicit_index" = "true"
#   }

#   snapshot_options {
#     automated_snapshot_start_hour = 23
#   }

#    tags {
#     Domain = "${var.environment_name}-es"
#   }
# }


# resource "aws_elasticsearch_domain_policy" "main" {
#   domain_name = "${aws_elasticsearch_domain.es.domain_name}"
#     access_policies = <<CONFIG
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": [
#           "*"
#         ]
#       },
#       "Action": [
#         "es:*"
#       ],
#       "Resource": "${aws_elasticsearch_domain.es.arn}/*"
#     }
#   ]
# }
# CONFIG

# }
