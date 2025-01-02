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

#############
# Gather info about Application Port Profiles that ship with vCD by default
#############
data "vcd_nsxt_manager" "main" {
  name = var.nsxt_host
}

data "vcd_nsxt_app_port_profile" "SSH" {
  name       = "SSH"
  scope      = "SYSTEM"
  context_id = data.vcd_nsxt_manager.main.id
}

#############
# Gather info about IP-Sets
#############
data "vcd_nsxt_ip_set" "lin_dev" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  name            = "lin_dev"
}

data "vcd_nsxt_ip_set" "lin_prod" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  name            = "lin_prod"
}

data "vcd_nsxt_ip_set" "win_dev" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  name            = "win_dev"
}

data "vcd_nsxt_ip_set" "win_prod" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  name            = "win_prod"
}

data "vcd_nsxt_ip_set" "DEV_NET" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  name            = "DEV_NET"
}

data "vcd_nsxt_ip_set" "PROD_NET" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  name            = "PROD_NET"
}
