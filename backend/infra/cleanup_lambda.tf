resource "aws_lambda_function" "cleanup_lambda" {
  function_name = "cla_cleanup_30day"
  handler       = "handler.handler"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambda/cleanup/deployment.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/cleanup/deployment.zip")
}

resource "aws_cloudwatch_event_rule" "cleanup_daily" {
  name                = "cleanup-daily-rule"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "cleanup_daily_target" {
  rule      = aws_cloudwatch_event_rule.cleanup_daily.name
  target_id = "cleanup-daily"
  arn       = aws_lambda_function.cleanup_lambda.arn
}

resource "aws_lambda_permission" "allow_cleanup_schedule" {
  statement_id  = "AllowCleanupSchedule"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cleanup_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cleanup_daily.arn
}
