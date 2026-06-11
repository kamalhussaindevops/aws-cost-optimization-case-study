resource "aws_s3_bucket" "data" {
  bucket_prefix = "${var.project}-data-"
  force_destroy = true
  tags          = { Name = "${var.project}-data" }
}

# F4: lifecycle policy — stop paying Standard rates for cold data.
resource "aws_s3_bucket_lifecycle_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    id     = "archive-and-expire"
    status = "Enabled"
    filter {}
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    expiration {
      days = 365
    }
  }
}

# F5: 30-day log retention instead of "never expire".
resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.project}/app"
  retention_in_days = 30
  tags              = { Name = "${var.project}-app-logs" }
}
