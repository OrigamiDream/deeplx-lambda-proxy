module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "deeplx-vpc"
  cidr = "10.30.0.0/16"

  azs = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.30.1.0/24", "10.30.2.0/24"]
  public_subnets = ["10.30.10.0/24", "10.30.11.0/24"]

  enable_dns_hostnames = true
  enable_dns_support = true
  enable_nat_gateway = true
  single_nat_gateway = true
}
