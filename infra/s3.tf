resource "aws_s3_bucket" "this" {
  bucket = "deeplx"
}

resource "aws_s3_object" "this" {
  bucket = aws_s3_bucket.this.bucket
  source_hash = filebase64sha256(var.lambda_archive_file)
  key = "apps/lambda.zip"
  source = var.lambda_archive_file
}
