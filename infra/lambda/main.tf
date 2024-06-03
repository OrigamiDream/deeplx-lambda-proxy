resource "aws_lambda_function" "this" {
  function_name = "deeplx-${var.index}"
  role          = aws_iam_role.this.arn

  handler          = "service/main.handler"
  runtime          = "python3.10"
  source_code_hash = filebase64sha256(var.archive)
  publish          = true
  memory_size      = 256

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_object_key

  layers  = [var.lambda_layer_arn]
  timeout = 300

  #   vpc_config {
  #     security_group_ids = var.security_group_ids
  #     subnet_ids         = var.subnet_ids
  #   }

  environment {
    variables = {
      FUNCTION_INDEX = var.index
    }
  }
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = var.lambda_source_arn
}
