/*
  Services
*/
resource "aws_security_group" "services" {
    name = "${var.environment_name}-services"
    description = "Allow incoming connections for elasticsearch, rabbitmq, xqueue, forum, certs."

    ingress { # The default for rabbitmq_port
        from_port = 5672
        to_port = 5672
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
    }
    ingress { # The default for rabbitmq_management_port
        from_port = 15672
        to_port = 15672
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
    }

    ingress { # The default for CERTS_NGINX_PORT
        from_port = 18090
        to_port = 18090
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
    }

    # ingress { # The default for XQUEUE_NGINX_PORT
    #     from_port = 18040
    #     to_port = 18040
    #     protocol = "tcp"
    #     cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
    # }

    ingress { # The default for FORUM_NGINX_PORT
        from_port = 18080
        to_port = 18080
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
    }

    ingress { # The default port for mongod and mongos instances
        from_port = 27017
        to_port = 27017
        protocol = "tcp"
        security_groups = []
        cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
    }

    ingress { # The default port when running with --shardsvr runtime operation or the shardsvr value for the clusterRole setting in a configuration file.
        from_port = 27018
        to_port = 27018
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
    }

    ingress { # The default port when running with --configsvr runtime operation or the configsvr value for the clusterRole setting in a configuration file.
        from_port = 27019
        to_port = 27019
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
    }

    ingress { # The default port for the frontend status page. The frontend status page is always accessible at a port number that is 1000 greater than the port determined by port.
        from_port = 28017
        to_port = 28017
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
    }

    # ingress {
    #     from_port = 22
    #     to_port = 22
    #     protocol = "tcp"
    #     security_groups = ["${aws_security_group.nat.id}"]
    # }

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
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    # egress { 
    #     from_port = 0
    #     to_port = 65535
    #     protocol    = "tcp"
    #     cidr_blocks = ["${var.private_subnet_cidr_1}","${var.private_subnet_cidr_2}","${var.public_subnet_cidr_1}","${var.public_subnet_cidr_2}"]
    # }

    egress { 
        from_port = 0
        to_port = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "${var.environment_name} services"
    }
}

resource "aws_instance" "services" {
    # ami = "${data.aws_ami.ubuntu.id}"
    ami = "ami-2a7d75c0"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    instance_type = "${var.services_instance_type}"
    key_name = "${var.aws_mt_private_subnet_key_name}"
    vpc_security_group_ids = ["${aws_security_group.services.id}"]
    subnet_id = "${aws_subnet.private-1.id}"
    source_dest_check = false
    disable_api_termination = "${var.ec2_disable_api_termination}"
    monitoring = true
    # user_data = "${file("user_data.sh")}"

    root_block_device {
        volume_size = "${var.services_root_volume_size}"
        volume_type = "${var.services_root_volume_type}"
        delete_on_termination = "${var.root_block_device_delete_on_termination}"      
    }

    # ebs_block_device {
    #     device_name = "/dev/sdh"
    #     volume_size = "${var.services_ebs_volume_size}"
    #     volume_type = "${var.services_ebs_volume_type}"
    #     delete_on_termination = "${var.root_block_device_delete_on_termination}"
    #     encrypted = true

    # }

    tags {
        Name = "${var.environment_name} services"
        LambdaBackupConfiguration = "${var.aws_snapshot_lambda_cron}"
        awx-filter = "${var.environment_name}"
    }

    volume_tags {
        Name = "${var.environment_name} services"
    }

    # Destroy ec2 only if created successful
    lifecycle {
        create_before_destroy = true
    }
}
