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

#############
# cloud-init config
#############
variable "cloud_init_default_config" {
  description = "cloud-init default config for VMs"
  type        = any
  default     = <<EOT
users:
  - name: root
    ssh_authorized_keys:
      - "ssh-rsa AAAAB3Nza8Og8/u2bfQ== imperator@noris.de"
  - name: imperator
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - "ssh-rsa AAAAB3Nza8Og8/u2bfQ== imperator@noris.de"
    groups: [noris]
groups:
  - noris
write_files:
  - path: /etc/motd
    owner: root:root
    append: true
    content: |
      "You may fire when ready" - but be careful, this is the production environment!
  EOT
}
