resource "aws_lambda_layer_version" "this" {
  filename            = var.lambda_deps_archive_file
  source_code_hash    = filebase64sha256(var.lambda_deps_archive_file)
  layer_name          = "deeplx-deps-${md5(var.lambda_deps_archive_file)}"
  compatible_runtimes = ["python3.10"]
}

module "lambda" {
  source = "./lambda"
  count  = var.lambda_size

  archive = var.lambda_archive_file
  index   = count.index

  lambda_source_arn = module.alb.target_groups["lambda_${count.index}"].arn
  lambda_layer_arn  = aws_lambda_layer_version.this.arn

  security_group_ids = [aws_security_group.lambda.id]
  subnet_ids         = module.vpc.private_subnets

  s3_bucket     = aws_s3_bucket.this.id
  s3_object_key = aws_s3_object.this.key
}
