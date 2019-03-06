/*
  AWS RDS Instance Variables
*/ 

variable "rds_is_multi_az" {
  default     = false
}

variable "rds_storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)."
  default     = "gp2"
}

variable "rds_iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1', default is 0 if rds storage type is not io1"
  default     = "0"
}

variable "rds_allocated_storage" {
  description = "The allocated storage in GBs"
  default = "200"
}

variable "rds_engine_type" {
  description = "Database engine type"
  default = "mysql"
  # Valid types are
  # - mysql
  # - postgres
  # - oracle-*
  # - sqlserver-*
  # See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
  # --engine
}

variable "rds_engine_version" {
  description = "Database engine version, depends on engine type"
  default = "5.6.40"
  # For valid engine versions, see:
  # See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
  # --engine-version
}

variable "rds_instance_class" {
  description = "Class of RDS instance"
  default = "db.t2.large"
  # Valid values
  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
}

variable "auto_minor_version_upgrade" {
  description = "Allow automated minor version upgrade"
  default     = true
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrade"
  default     = false
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = true
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi' UTC "
  default     = "Mon:03:30-Mon:04:30"
}

#The name of the database to create
variable "database_name" {}

# Self-explainatory variables
variable "database_user" {}
variable "database_password" {}

variable "database_port" {
  description = "RDS database port number"
  default = "3306"
}

# This is for a custom parameter to be passed to the DB
# We're "cloning" default ones, but we need to specify which should be copied
variable "db_parameter_group" {
  description = "Parameter group, depends on DB engine used"
  default = "mysql5.6"
}

variable "publicly_accessible" {
  description = "Determines if database can be publicly available (NOT recommended)"
  default     = false
}

variable "skip_final_snapshot" {
  description = "If true (default), no snapshot will be made before deleting DB"
  default     = false
}

variable "copy_tags_to_snapshot" {
  description = "Copy tags from DB to a snapshot"
  default     = true
}

variable "backup_window" {
  description = "When AWS can run snapshot, can't overlap with maintenance window"
  default     = "01:00-03:00"
}

variable "backup_retention_period" {
  type        = "string"
  description = "How long will we retain backups"
  default     = 7
}
