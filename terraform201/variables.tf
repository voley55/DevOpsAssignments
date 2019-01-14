// Variable definition
variable network_base_cidr {
  type        = "string"
  description = "Base CIDR for test VPC"
  default     = "10.0.0.0/16"
}

variable subnet_size {
  type        = "string"
  description = "Subnet size for test vpc"
  default     = "0"
}

variable apex_domain {
  type        = "string"
  description = "Domain name for test app ALB"
  default     = "terraform-test-alb.test.com"
}

variable asg_max_size {
  type        = "string"
  description = "Max size for Auto-Scaling Group"
  default     = "2"
}

variable asg_min_size {
  type        = "string"
  description = "Min size for Auto-Scaling Group"
  default     = "1"
}

variable asg_desired_size {
  type        = "string"
  description = "Desired size for Auto-Scaling Group"
  default     = "1"
}

variable ami_id {
  type        = "string"
  description = "AMI to be used in Auto-Scaling Group"
  default     = "ami-70dad51a"
}

variable on_demand_base_capacity {
  type        = "string"
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances"
  default     = "0"
}

variable on_demand_percentage_above_base_capacity {
  type        = "string"
  description = "Percentage split between on-demand and Spot instances above the base on-demand capacity"
  default     = "50"
}

variable target_group_port {
  type        = "string"
  description = "Target group port for ALB"
  default     = "80"
}
