/*
  VPN Instance
*/
resource "aws_security_group" "vpn" {
    name = "${var.environment_name}-vpc-vpn"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress { 
        from_port = 0
        to_port = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "${var.environment_name} VPC VPN"
    }
}

resource "aws_eip" "vpn" {
  vpc   = true

  tags {
    Name = "${var.environment_name} VPN"
  }
}

resource "aws_eip_association" "main_eip_single" {
  instance_id   = "${aws_instance.vpn.id}"
  allocation_id = "${aws_eip.vpn.id}"
}

resource "aws_instance" "vpn" {
    # ami = "${data.aws_ami.vpn.id}"
    ami = "ami-2a7d75c0"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    instance_type = "${var.vpn_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.vpn.id}"]
    subnet_id = "${aws_subnet.public-1.id}"
    associate_public_ip_address = true
    source_dest_check = false
    disable_api_termination = "${var.ec2_disable_api_termination}"
    user_data = "${file("user_data_vpn.sh")}"

    tags {
        Name = "${var.environment_name} VPC VPN"
        LambdaBackupConfiguration = "${var.aws_snapshot_lambda_cron}"
        awx-filter = "${var.environment_name}"
    }

    # Destroy ec2 only if created successful
    lifecycle {
        create_before_destroy = true
    }

    root_block_device {
        volume_size = "${var.vpn_root_volume_size}"
        volume_type = "${var.vpn_root_volume_type}"
        delete_on_termination = "${var.root_block_device_delete_on_termination}"
    }

    volume_tags {
        Name = "${var.environment_name} VPC VPN"
    }
}
