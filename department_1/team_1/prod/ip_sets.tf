#############
# Create IP Sets
#############
resource "vcd_nsxt_ip_set" "lin_prod" {
  name = "lin_prod"
  ip_addresses = [
    vcd_vm.lin-prod.network[0].ip,
    vcd_vm.lin-prod.network[0].secondary_ip
  ]
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
}
