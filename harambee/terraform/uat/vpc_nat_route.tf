
# #Private Subnet 1

# resource "aws_route_table" "private-1" {
#     vpc_id = "${aws_vpc.default.id}"

#     route {
#         cidr_block = "0.0.0.0/0"
#         instance_id = "${aws_instance.nat.id}"
#     }

#     tags {
#         Name = "${var.environment_name} Private Subnet"
#     }
# }

# resource "aws_route_table_association" "private-1" {
#     subnet_id = "${aws_subnet.private-1.id}"
#     route_table_id = "${aws_route_table.private-1.id}"
# }


# #Private Subnet 2

# resource "aws_route_table" "private-2" {
#     vpc_id = "${aws_vpc.default.id}"

#     route {
#         cidr_block = "0.0.0.0/0"
#         instance_id = "${aws_instance.nat.id}"
#     }

#     tags {
#         Name = "${var.environment_name} Private Subnet 2"
#     }
# }

# resource "aws_route_table_association" "private-2" {
#     subnet_id = "${aws_subnet.private-2.id}"
#     route_table_id = "${aws_route_table.private-2.id}"
# }

