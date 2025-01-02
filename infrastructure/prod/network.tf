#############
# Setup networks
#############
resource "vcd_network_routed_v2" "PROD-NET" {
  name                    = "PROD-NET"
  dual_stack_enabled      = true
  gateway                 = "172.16.0.17"
  prefix_length           = 28
  secondary_gateway       = "2001:780:0:2::0:0:0:1"
  secondary_prefix_length = 64
  edge_gateway_id         = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
}
