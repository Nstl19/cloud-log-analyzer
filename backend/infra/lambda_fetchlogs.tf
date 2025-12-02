resource "aws_lambda_function" "fetch_lambda" {
  function_name    = "cla_fetch_logs"
  handler          = "handler.handler"
  runtime          = "python3.10"
  role             = aws_iam_role.lambda_role.arn

  filename         = "${path.module}/../lambda/fetchlogs/deployment.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/fetchlogs/deployment.zip")

  timeout = 15
}
