output "alb_dns_name" {
  value = module.alb.dns_name
}

output "proxy_commit_urls" {
  value = [
    for i in range(var.lambda_size): "http://${module.alb.dns_name}/v${i}/commit"
  ]
}
