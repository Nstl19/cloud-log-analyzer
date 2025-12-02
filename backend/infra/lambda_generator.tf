# -------------------------
# Lambda: Auto Log Generator
# -------------------------
resource "aws_lambda_function" "log_generator" {
  function_name = "cla_log_generator"
  handler       = "handler.handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../generator/deployment.zip"
  source_code_hash = filebase64sha256("${path.module}/../generator/deployment.zip")

  environment {
    variables = {
      BUCKET_NAME = "loganalyzer-05458f58"
    }
  }
}

# -------------------------
# EventBridge rule (runs every 1 minute)
# -------------------------
resource "aws_cloudwatch_event_rule" "log_schedule" {
  name                = "log-generator-schedule"
  schedule_expression = "rate(1 minute)"
}

# Connect schedule to lambda
resource "aws_cloudwatch_event_target" "log_schedule_target" {
  rule      = aws_cloudwatch_event_rule.log_schedule.name
  target_id = "generate-logs"
  arn       = aws_lambda_function.log_generator.arn
}

# Allow EventBridge to invoke Lambda 
resource "aws_lambda_permission" "allow_event_schedule" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.log_generator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.log_schedule.arn
}

# -------------------------
# IAM Policy - S3 Write Access
# -------------------------
resource "aws_iam_role_policy" "lambda_s3_write" {
  name = "lambda_s3_write_access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject"
        ]
        Resource = [
          aws_s3_bucket.log_bucket.arn,
          "${aws_s3_bucket.log_bucket.arn}/*"
        ]
      }
    ]
  })
}
