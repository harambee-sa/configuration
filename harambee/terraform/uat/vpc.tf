resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "${var.environment_name} VPC"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "${var.environment_name} IGW"
    }
}

data "aws_availability_zones" "available" {}

/*
  Public Subnet 1
*/
resource "aws_subnet" "public-1" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet_cidr_1}"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"

    tags {
        Name = "${var.environment_name} Public Subnet 1"
    }
}

resource "aws_route_table" "public-1" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "${var.environment_name} Public Subnet 1"
    }
}

resource "aws_route_table_association" "public-1" {
    subnet_id = "${aws_subnet.public-1.id}"
    route_table_id = "${aws_route_table.public-1.id}"
}

/*
  Public Subnet 2
*/
resource "aws_subnet" "public-2" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet_cidr_2}"
    availability_zone = "${data.aws_availability_zones.available.names[1]}"

    tags {
        Name = "${var.environment_name} Public Subnet 2"
    }
}

resource "aws_route_table" "public-2" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "${var.environment_name} Public Subnet 2"
    }
}

resource "aws_route_table_association" "public-2" {
    subnet_id = "${aws_subnet.public-2.id}"
    route_table_id = "${aws_route_table.public-2.id}"
}

/*
  Private Subnet 1
*/
resource "aws_subnet" "private-1" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_subnet_cidr_1}"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"

    tags {
        Name = "${var.environment_name} Private Subnet 1"
    }
}

/*
  Private Subnet 2
*/
resource "aws_subnet" "private-2" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_subnet_cidr_2}"
    availability_zone = "${data.aws_availability_zones.available.names[1]}"

    tags {
        Name = "${var.environment_name} Private Subnet 2"
    }
}


