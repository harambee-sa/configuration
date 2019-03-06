variable "rds_cpu_threshold" {
  default     = "80"
  description = "Alarm threshold for percentage of CPU used"
}

variable "rds_min_storagespace_threshold" {
  default     = "20"
  description = "Alarm threshold for percentage of free storage space left"
}

/* 
http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html#Concepts.DBInstanceClass.Summary 
*/
variable "rds_memory" {
  default = {
    db.t2.micro    = "1000000000"
    db.t1.micro    = "615000000"
    db.m1.small    = "1700000000"
    db.m4.large    = "8000000000"
    db.m4.xlarge   = "16000000000"
    db.m4.2xlarge  = "32000000000"
    db.m4.4xlarge  = "64000000000"
    db.m4.10xlarge = "160000000000"
    db.r3.large    = "15000000000"
    db.r3.xlarge   = "30500000000"
    db.r3.2xlarge  = "61000000000"
    db.r3.4xlarge  = "122000000000"
    db.r3.8xlarge  = "244000000000"
    db.t2.small    = "2000000000"
    db.t2.medium   = "4000000000"
    db.t2.large    = "8000000000"
    db.m3.medium   = "3750000000"
    db.m3.large    = "7500000000"
    db.m3.xlarge   = "15000000000"
    db.m3.2xlarge  = "30000000000"
    db.m1.small    = "1700000000"
    db.m1.medium   = "3750000000"
    db.m1.large    = "7500000000"
    db.m1.xlarge   = "15000000000"
    db.m2.xlarge   = "17100000000"
    db.m2.2xlarge  = "34200000000"
    db.m2.4xlarge  = "68400000000"
  }
}

variable "rds_min_freememory_threshold" {
  default     = "20"
  description = "Alarm threshold for percentage of free memory left"
}

variable "rds_connections_threshold" {
  default     = "70"
  description = "Alarm threshold for percentage of total DB connections allowed"
}

variable "rds_write_iops_threshold" {
  default     = "60"
  description = "Alarm threshold for percentage of Provisioned IOPS used by writes"
}

variable "rds_read_iops_threshold" {
  default     = "60"
  description = "Alarm threshold for percentage of Provisioned IOPS used by reads"
}

variable "rds_swapusage_threshold" {
  default     = "20000000.0"
  description = "Alarm threshold for the amount of swap used in Bytes"
}

variable "rds_network_in_threshold" {
  default     = "80"
  description = "Alarm threshold for percentage of bandwidth used by network in traffic"
}

variable "rds_network_out_threshold" {
  default     = "80"
  description = "Alarm threshold for percentage of bandwidth used by network out traffic"
}

/* The bandwidth values below are taken from here. 
http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-ec2-config.html
http://stackoverflow.com/questions/18507405/ec2-instance-typess-exact-network-performance */

variable "bandwidth" {
  default = {
    db.t2.micro    = "8750000"
    db.t1.micro    = "12500000"
    db.m4.large    = "56250000"
    db.m4.xlarge   = "93750000"
    db.m4.2xlarge  = "125000000"
    db.m4.4xlarge  = "250000000"
    db.m4.10xlarge = "500000000"
    db.r3.large    = "31250000"
    db.r3.xlarge   = "62500000"
    db.r3.2xlarge  = "125000000"
    db.r3.4xlarge  = "250000000"
    db.r3.8xlarge  = "600000000"
    db.t2.small    = "15625000"
    db.t2.medium   = "31250000"
    db.t2.large    = "62500000"
    db.m3.medium   = "15625000"
    db.m3.large    = "31250000"
    db.m3.xlarge   = "62500000"
    db.m3.2xlarge  = "125000000"
    db.m1.small    = "15625000"
    db.m1.medium   = "31250000"
    db.m1.large    = "62500000"
    db.m1.xlarge   = "125000000"
    db.m2.xlarge   = "31250000"
    db.m2.2xlarge  = "62500000"
    db.m2.4xlarge  = "125000000"
  }
}

variable "rds_read_latency_threshold" {
  default     = "0.03"
  description = "Alarm threshold for the average amount of time taken per read operation in seconds"
}

variable "rds_write_latency_threshold" {
  default     = "0.03"
  description = "Alarm threshold for the average amount of time taken per write operation in seconds"
}

variable "rds_read_throughput_threshold" {
  default     = ""
  description = "Alarm threshold for the average number of bytes read from disk per second"
}

variable "rds_write_throughput_threshold" {
  default     = ""
  description = "Alarm threshold for the average number of bytes written to disk per second"
}

variable "rds_disk_queue_threshold" {
  default     = "10"
  description = "Alarm threshold for the number of outstanding IOs (read/write requests) waiting to access the disk"
}

variable "rds_binlog_threshold" {
  default     = ""
  description = "Alarm threshold for the amount of disk space occupied by binary logs on the master. Applies to MySQL read replicas."
}

variable "rds_replica_lag_threshold" {
  default     = "0.3"
  description = "Alarm threshold for the maximum amount of time a read replica DB instance lags behind the source DB instance in seconds"
}

variable "rds_burst_balance_threshold" {
  description = "The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available."
  type        = "string"
  default     = 20
}

# variable "rds_min_credits" {
#   default     = ""
#   description = "Alarm threshold for the number of CPU credits available for the instance to burst beyond its base CPU utilization."
# }

# variable "rds_credits" {
#   default = {
#     "db.t2.micro"  = "50"
#     "db.t2.small"  = "100"
#     "db.t2.medium" = "200"
#     "db.t2.large"  = "400"
#   }
# }
