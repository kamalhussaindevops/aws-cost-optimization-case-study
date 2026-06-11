output "region" {
  value = var.region
}
output "app_instance_ids" {
  value = [aws_instance.app_0.id, aws_instance.app_1.id]
}
output "rds_identifier" {
  value = aws_db_instance.main.identifier
}
output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
output "s3_bucket" {
  value = aws_s3_bucket.data.bucket
}
