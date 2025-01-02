##############
# Create Loadbalancer Pool
##############
resource "vcd_nsxt_alb_pool" "lin_dev" {
  name            = "lin_dev"
  edge_gateway_id = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  default_port    = 80
  ssl_enabled     = true
  health_monitor { type = "TCP" }
  member_group_id = vcd_nsxt_ip_set.lin_dev.id
}

##############
# Create Loadbalancer Virtual Service
##############
resource "vcd_nsxt_alb_virtual_service" "lin_dev" {
  name                     = "lin_dev"
  pool_id                  = vcd_nsxt_alb_pool.lin_dev.id
  edge_gateway_id          = data.vcd_nsxt_edgegateway.nsxt_edgegateway.id
  service_engine_group_id  = data.vcd_nsxt_alb_edgegateway_service_engine_group.nsxt_alb_edgegateway_service_engine_group.service_engine_group_id
  application_profile_type = "HTTP"
  virtual_ip_address       = "123.234.123.2"
  ipv6_virtual_ip_address  = "2001:780:1:100:1:0:0:1"
  service_port {
    start_port  = 80
    end_port    = 0
    ssl_enabled = false
    type        = "TCP_PROXY"
  }
}
