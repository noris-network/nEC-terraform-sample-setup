#############
# noris nEC login settings
#############
variable "vcd_url" {
  description = "VDC API endpoint URL"
  type        = string
  default     = "https://vcd-nbg.nec.noris.de/api"
}

#############
# noris enterprise cloud customer environment settings
#############
variable "vdc_org_name" {
  description = "VDC Customer Name."
  type        = string
  default     = "1-1"
}

variable "vcd_vdc" {
  description = "Default VDC of Customer"
  type        = string
  default     = "HA-DN6A-1-1"
}

variable "vdc_group_name" {
  description = "VDC Group of Customer."
  type        = string
  default     = "1-1-nbg"
}

variable "vdc_edge_gateway_name" {
  description = "VDC Edge Gateway of Customer."
  type        = string
  default     = "T1-1-1-nbg"
}
