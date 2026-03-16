#############
# Create IP Sets
#############
resource "vcd_nsxt_ip_set" "win_dev" {
  name = "win_dev"
  ip_addresses = [
    vcd_vm.win-dev.network[0].ip,
    vcd_vm.win-dev.network[0].secondary_ip
  ]
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
}
