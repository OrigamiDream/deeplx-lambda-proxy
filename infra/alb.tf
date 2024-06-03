locals {
  http_listener_rules = {
    for i in range(var.lambda_size) : "forward_${i}" => {
      actions = [
        {
          type             = "forward"
          target_group_key = "lambda_${i}"
        }
      ]
      conditions = [
        {
          path_pattern = {
            values = ["/v${i}/*"]
          }
        }
      ]
    }
  }
  target_groups = {
    for i in range(var.lambda_size) : "lambda_${i}" => {
      name                          = "deeplx-${i}-alb-tg"
      load_balancing_algorithm_type = "least_outstanding_requests"
      target_type                   = "lambda"
      target_id                     = "arn:aws:lambda:${var.region}:${data.aws_caller_identity.this.account_id}:function:deeplx-${i}"
      health_check = {
        protocol = "HTTP"
        path     = "/v${i}/health"
        timeout  = 15
      }
    }
  }
}

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name   = "deeplx-alb-sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = "deeplx-alb"

  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true
  idle_timeout                     = 30

  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_subnets
  security_groups            = [module.alb_sg.security_group_id]
  internal                   = false
  enable_deletion_protection = false

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "lambda_0" # default action
      }
      rules = local.http_listener_rules
    }
  }

  target_groups = local.target_groups
}
