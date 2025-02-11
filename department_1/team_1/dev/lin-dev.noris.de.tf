resource "vcd_vm" "lin-dev" {
  name                   = "lin-dev.noris.de"
  computer_name          = "lin-dev"
  description            = "lin dev"
  vdc                    = "HA-DN6A-1-1"
  cpus                   = 4
  cpu_hot_add_enabled    = true
  memory                 = (1024 * 16)
  memory_hot_add_enabled = true
  vapp_template_id       = data.vcd_catalog_vapp_template.debian12.id

  network {
    type                         = "org"
    adapter_type                 = "VMXNET3"
    name                         = data.vcd_network_routed_v2.DEV-NET.name
    ip_allocation_mode           = "MANUAL"
    ip                           = "172.16.0.2"
    secondary_ip_allocation_mode = "MANUAL"
    secondary_ip                 = "2001:780:0:1::2"
    is_primary                   = true
  }

  guest_properties = {
    "user-data" = base64encode(<<EOT
#cloud-config
hostname: lin-dev.noris.de
groups:
  - noris
users:
${var.cloud_init_config["users"]["root"]}
write_files:
  - path: /etc/cloud/cloud.cfg.d/99_network.cfg
    owner: root/root
    permissions: 0o644
    defer: true
    content: |
      instance-id: lin-dev.noris.de
      local-hostname: lin-dev.noris.de
      network:
        version: 2
        ethernets:
          eth0:
            addresses:
              - "172.16.0.2/28"
              - "2001:780:0:1::2/64"
            routes:
              - to: 0.0.0.0/0
                via: 172.16.0.1
                metric: 1
                on-link: true
              - to: ::/0
                via: 2001:780:0:1::1
                metric: 1
                on-link: true
      ${var.cloud_init_config["network_nameservers"]}
${var.cloud_init_config["resolv_conf"]}
runcmd:
${var.cloud_init_config["cmd_debian_netconfig"]}
EOT
    )
  }
  customization { enabled = true }

  lifecycle {
    ignore_changes  = [vapp_template_id, consolidate_disks_on_create]
    prevent_destroy = true
  }
}

#############
# bus 0 disk 0 150GB /
#############
resource "vcd_vm_internal_disk" "lin-dev_bus1_disk0" {
  vm_name     = vcd_vapp_vm.lin-dev.name
  vapp_name   = vcd_vapp_vm.lin-dev.vapp_name
  vdc         = vcd_vapp_vm.lin-dev.vdc
  size_in_mb  = (1024 * 150)
  bus_type    = "paravirtual"
  bus_number  = 1
  unit_number = 0
  lifecycle {
    prevent_destroy = true
  }
}
