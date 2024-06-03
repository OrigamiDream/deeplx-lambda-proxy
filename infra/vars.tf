variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Name of AWS region"
}

variable "lambda_archive_file" {
  type    = string
  default = "../lambda.zip"
}

variable "lambda_deps_archive_file" {
  type    = string
  default = "../deps.zip"
}

variable "lambda_size" {
  type        = number
  default     = 15
  description = "Number of AWS Lambda functions"
}
