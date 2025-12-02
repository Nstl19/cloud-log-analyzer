resource "aws_dynamodb_table" "logs_table" {
  name         = "CloudLogAnalyzer"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "id"
  range_key = "timestamp"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  tags = {
    Name = "Log Analyzer Table"
  }
}
