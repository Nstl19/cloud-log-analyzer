resource "aws_s3_bucket" "log_bucket" {
  bucket = "loganalyzer-${random_id.suffix.hex}"

  tags = {
    Name = "Cloud Log Analyzer Bucket"
  }
}
