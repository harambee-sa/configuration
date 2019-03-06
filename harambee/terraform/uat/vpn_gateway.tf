# resource "aws_customer_gateway" "customer_gateway" {
#   bgp_asn    = 65000
#   ip_address = "82.117.252.245"
#   type       = "ipsec.1"

#   tags {
#       Name = "${var.environment_name} Customer Gateway"
#   }
# }

# resource "aws_vpn_gateway" "vpn_gateway" {
#   vpc_id = "${aws_vpc.default.id}"

#   tags {
#       Name = "${var.environment_name} VPN Gateway"
#   }
# }

# resource "aws_vpn_connection" "main" {
#   vpn_gateway_id      = "${aws_vpn_gateway.vpn_gateway.id}"
#   customer_gateway_id = "${aws_customer_gateway.customer_gateway.id}"
#   type                = "ipsec.1"
#   static_routes_only  = true

#   tags {
#       Name = "${var.environment_name} VPN Connection"
#   }
# }

# resource "aws_vpn_connection_route" "office" {
#   destination_cidr_block = "192.168.1.0/24"
#   vpn_connection_id      = "${aws_vpn_connection.main.id}"
# }
