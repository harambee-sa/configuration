resource "aws_eip" "nat-gw" {
  vpc   = true

  tags {
    Name = "${var.environment_name}-nat-gw-private"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.nat-gw.id}"
  subnet_id = "${aws_subnet.public-1.id}"
  depends_on = ["aws_internet_gateway.default"]
    tags {
        Name = "${var.environment_name} Private Subnets"
    }
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.default.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
    }

    tags {
        Name = "${var.environment_name} Private Subnets"
    }
}

resource "aws_route_table_association" "private-1" {
    subnet_id = "${aws_subnet.private-1.id}"
    route_table_id = "${aws_route_table.private.id}"
}
resource "aws_route_table_association" "private-2" {
    subnet_id = "${aws_subnet.private-2.id}"
    route_table_id = "${aws_route_table.private.id}"
}
