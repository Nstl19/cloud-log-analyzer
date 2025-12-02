resource "aws_lambda_function" "parser_lambda" {
  function_name = "cla_parser"
  runtime       = "python3.12"
  handler       = "handler.handler"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambda/parser/deployment.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/parser/deployment.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.log_bucket.bucket
    }
  }
}

# IAM Allow S3 Read Access
resource "aws_iam_role_policy" "parser_s3_read" {
  name = "parser-s3-read"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.log_bucket.arn,
          "${aws_s3_bucket.log_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Allow S3 to invoke Parser Lambda
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.parser_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.log_bucket.arn
}

# S3 - Lambda Notification Trigger
resource "aws_s3_bucket_notification" "log_bucket_notify" {
  bucket = aws_s3_bucket.log_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.parser_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "logs/"
  }

  depends_on = [
    aws_lambda_permission.allow_s3_invoke
  ]
}
