# API Gateway
resource "aws_apigatewayv2_api" "cla_api" {
  name          = "claApi"
  protocol_type = "HTTP"
}

# Lambda Integration
resource "aws_apigatewayv2_integration" "fetch_integration" {
  api_id                 = aws_apigatewayv2_api.cla_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.fetch_lambda.invoke_arn
  payload_format_version = "2.0"
}

# Route: GET /logs
resource "aws_apigatewayv2_route" "get_logs" {
  api_id    = aws_apigatewayv2_api.cla_api.id
  route_key = "GET /logs"
  target    = "integrations/${aws_apigatewayv2_integration.fetch_integration.id}"
}

# Stage
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.cla_api.id
  name        = "$default"
  auto_deploy = true
}

# Lambda Permission
resource "aws_lambda_permission" "allow_api_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fetch_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.cla_api.execution_arn}/*/*"
}
