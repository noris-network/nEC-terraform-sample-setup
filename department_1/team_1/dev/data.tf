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
# Gather info about the SEG running the AVI Loadbalancer
#############
data "vcd_nsxt_alb_edgegateway_service_engine_group" "nsxt_alb_edgegateway_service_engine_group" {
  service_engine_group_name = "shared-seg-001"
  edge_gateway_id           = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
}

#############
# Gather info about vApp-Templates in the Catalog
#############
data "vcd_catalog" "catalog" {
  name = "imagepipeline"
  org  = "Catalog"
}

data "vcd_catalog_vapp_template" "debian12" {
  name       = "debian12"
  catalog_id = data.vcd_catalog.catalog.id
}

#############
# Gather info about Org-Networks
#############
data "vcd_network_routed_v2" "DEV-NET" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  name            = "DEV-NET"
}
