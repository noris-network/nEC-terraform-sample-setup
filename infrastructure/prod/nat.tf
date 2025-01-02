#############
# Create NAT Rules
#############
resource "vcd_nsxt_nat_rule" "outbound_nat" {
  name             = "1-outbound_nat_prod"
  edge_gateway_id  = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  rule_type        = "SNAT"
  external_address = "123.234.123.1"
  internal_address = "172.16.0.16/28"
  priority         = 1
}
