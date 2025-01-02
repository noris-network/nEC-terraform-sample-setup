#############
# Create Edge Firewall ruleset
#############
resource "vcd_nsxt_firewall" "nsxt_firewall" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id

  ### noris>ssh lin
  rule {
    name        = "noris>lin_tcp22"
    direction   = "IN_OUT"
    ip_protocol = "IPV4_IPV6"
    action      = "ALLOW"
    source_ids = [
      vcd_nsxt_ip_set.NORIS-BLK1.id
    ]
    destination_ids = [
      data.vcd_nsxt_ip_set.lin_dev.id,
      data.vcd_nsxt_ip_set.lin_prod.id
    ]
    app_port_profile_ids = [data.vcd_nsxt_app_port_profile.SSH.id]
  }

  ### noris>monitoring
  rule {
    name        = "noris>vms_tcp5666"
    direction   = "IN_OUT"
    ip_protocol = "IPV4_IPV6"
    action      = "ALLOW"
    source_ids = [
      vcd_nsxt_ip_set.NORIS-BLK1.id
    ]
    destination_ids = [
      data.vcd_nsxt_ip_set.DEV_NET.id,
      data.vcd_nsxt_ip_set.PROD_NET.id,
    ]
    app_port_profile_ids = [vcd_nsxt_app_port_profile.icinga_tcp5666.id]
  }
}
