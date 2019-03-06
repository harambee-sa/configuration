
variable "memcached_parameter_group_family" {
  default = "memcached1.4"
}

variable "memcached_parameter_group_max_item_size" {
  default = "10485760"
}

variable "memcached_maintenance_window" {
  default = "sun:02:30-sun:03:30"
}

variable "memcached_desired_clusters" {
  default = "1"
}

variable "memcached_instance_type" {
  default = "cache.t2.small"
}

variable "memcached_engine_version" {
  default = "1.4.33"
}

variable "memcached_alarm_cpu_threshold_percent" {
  default = "75"
}

variable "memcached_alarm_memory_threshold_bytes" {
  # 10MB
  default = "10000000"
}
