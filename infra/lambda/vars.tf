variable "index" {
  type = number
}

variable "archive" {
  type = string
}

variable "lambda_layer_arn" {
  type = string
}

variable "lambda_source_arn" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "s3_bucket" {
  type = string
}

variable "s3_object_key" {
  type = string
}
