#############
# Gather info about the vDC-Group
#############
data "vcd_vdc_group" "vdc_group" {
  name = var.vdc_group_name
}

#############
# Gather info about the Edge-Gateway
#############
data "vcd_nsxt_edgegateway" "nsxt_edgegateway" {
  name     = var.vdc_edge_gateway_name
  owner_id = data.vcd_vdc_group.vdc_group.id
}
