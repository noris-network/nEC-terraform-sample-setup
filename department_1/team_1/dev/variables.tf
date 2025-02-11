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
# cloud-init config snippets
#############
variable "cloud_init_config" {
  description = "cloud-init config snippets that can be supplied when creating a Linux VM. Keep the indentation!"
  type        = any
  default = {
    users = {
      root = <<EOT
  - name: root
    ssh_authorized_keys:
    - ssh-rsa AAAAB3Nza8Og8/u2bfQ== root@noris.de
EOT
    }
    cmd_debian_netconfig = <<EOT
  - cloud-init devel net-convert --network-data /etc/cloud/cloud.cfg.d/99_network.cfg --kind yaml --output-kind eni -D debian -d /
  - systemctl restart networking
EOT
    cmd_rhel_netconfig   = <<EOT
  - nmcli connection delete "System eth0"  # delete System eth0 connection as it causes our config to be ignored
  - cloud-init devel net-convert --network-data /etc/cloud/cloud.cfg.d/99_network.cfg --kind yaml --output-kind network-manager -D rhel -d /
  - systemctl restart NetworkManager
EOT
    network_nameservers  = <<EOT
            nameservers:
              addresses:
                - "62.128.1.42"
                - "62.128.1.53"
EOT
    resolv_conf          = <<EOT
  - path: /etc/resolv.conf
    owner: root/root
    permissions: 0o644
    defer: true
    content: |
      nameserver 62.128.1.42
      nameserver 62.128.1.53
EOT
  }
}
