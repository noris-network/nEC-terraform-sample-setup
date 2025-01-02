#############
# Create Application Port Profiles
#############
resource "vcd_nsxt_app_port_profile" "icinga_tcp5666" {
  name = "icinga_tcp5666"
  app_port {
    protocol = "TCP"
    port     = ["5666"]
  }
  scope = "TENANT"
}
