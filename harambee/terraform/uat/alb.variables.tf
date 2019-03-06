variable "listener_condition_field" {
  description = "The name of the field. Must be one of path-pattern for path based routing or host-header for host based routing."
  default = "path-pattern"
}

variable "listener_condition_values" {
  description = "The path patterns to match. A maximum of 1 can be defined."
  type    = "list"
  default = ["/*"]
}

variable "alb_target_group_health_check_path" {
  description = "The path patterns to match. A maximum of 1 can be defined."
  default = "/heartbeat"
}
