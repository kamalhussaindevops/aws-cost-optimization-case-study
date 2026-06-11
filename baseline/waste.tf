resource "aws_ebs_volume" "orphan" {
  count             = 2
  availability_zone = data.aws_availability_zones.available.names[count.index]
  size              = 50
  type              = "gp2"
}

resource "aws_eip" "idle" {
  count  = 2
  domain = "vpc"
}
