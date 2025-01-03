provider "vcd" {
  url       = var.vcd_url
  auth_type = "api_token"
  org       = var.vdc_org_name
}
