resource "aws_key_pair" "deployer" {
  key_name   = "${var.aws_key_name}"
  public_key = "${ file("${var.aws_key_path}")}"
}

resource "aws_key_pair" "deployer-private-subnets" {
  key_name   = "${var.aws_mt_private_subnet_key_name}"
  public_key = "${ file("${var.aws_mt_public_subnet_key_path}")}"
}
