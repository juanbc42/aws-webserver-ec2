variable "tags" {
  type        = map(string)
  description = "Tags to be used in the resources"
}

variable "region" {
  type        = string
  description = "Default region to be set"
}

variable "env" {
  type        = string
  description = "Default environment to be set"
}

variable "buckets_list" {
  type        = set(string)
  description = "A list with names of buckets to be created. Attention, no underscores"
}

variable "vpc_id" {
  type        = string
  description = "main vpc id to be used in data for ec2 instances"
}

variable "subnet_id" {
  type        = string
  description = "main subnet id to be used in data for ec2 instances"
}
