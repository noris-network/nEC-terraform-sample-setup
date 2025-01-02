#############
# Create IP Sets
#############
resource "vcd_nsxt_ip_set" "snat_out" {
  name            = "snat_out"
  description     = "123.234.123.1"
  ip_addresses    = ["123.234.123.1"]
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
}

resource "vcd_nsxt_ip_set" "NORIS-BLK1" {
  name            = "NORIS-BLK1"
  description     = "62.128.0.0/19"
  ip_addresses    = ["62.128.0.0/19"]
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
}
