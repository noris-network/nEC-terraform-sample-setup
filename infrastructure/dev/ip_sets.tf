#############
# Create IP Sets
#############
resource "vcd_nsxt_ip_set" "DEV-NET" {
  name            = "DEV-NET"
  description     = "172.16.0.0/28, 2001:780:0:2:0:0:0:0/64"
  ip_addresses    = ["172.16.0.0/28", "2001:780:0:2:0:0:0:0/64"]
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
}
