variable "memory_warning" {
  description = "Memory warning threshold"
  default = "50"
}

variable "memory_critical" {
  description = "Memory critical threshold"
  default = "70"
}
variable "diskspace_warning" {
  description = "Disk space warning threshold"
  default = "10"
}
variable "diskspace_critical" {
  description = "Disk space critical threshold"
  default = "5"
}
