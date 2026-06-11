resource "aws_s3_bucket" "data" {
  bucket_prefix = "${var.project}-data-"
  force_destroy = true
  tags          = { Name = "${var.project}-data" }
}

resource "aws_cloudwatch_log_group" "app" {
  name = "/${var.project}/app"
  tags = { Name = "${var.project}-app-logs" }
}
