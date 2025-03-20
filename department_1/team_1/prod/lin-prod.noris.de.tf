resource "vcd_vm" "lin-prod" {
  name                   = "lin-prod.noris.de"
  computer_name          = "lin-prod"
  description            = "lin prod"
  vdc                    = "HA-DN6A-1-1"
  cpus                   = 4
  cpu_hot_add_enabled    = true
  memory                 = (1024 * 16)
  memory_hot_add_enabled = true
  vapp_template_id       = data.vcd_catalog_vapp_template.ubuntu2404.id

  network {
    type                         = "org"
    adapter_type                 = "VMXNET3"
    name                         = data.vcd_network_routed_v2.PROD-NET.name
    ip_allocation_mode           = "MANUAL"
    ip                           = "172.16.0.18"
    secondary_ip_allocation_mode = "MANUAL"
    secondary_ip                 = "2001:780:0:2::18"
    is_primary                   = true
  }

  guest_properties = {
    "user-data" = base64encode(<<EOT
#cloud-config
${var.cloud_init_default_config}
bootcmd:
  - [ sh, -c, "while [ ! -e /dev/sdb ]; do echo 'Waiting for /dev/sdb to be available'; sleep 1; done" ]
disk_setup:
  /dev/sdb:
    layout: true
    table_type: gpt
    overwrite: false
fs_setup:
  - device: /dev/sdb1
    filesystem: ext4
mounts:
  - [/dev/sdb1, /mnt]
EOT
    )
  }
  customization { enabled = true }

  lifecycle {
    ignore_changes  = [vapp_template_id, consolidate_disks_on_create]
    prevent_destroy = true
  }
}

resource "vcd_vm_internal_disk" "lin-prod_bus1_disk0" {
  vm_name     = vcd_vm.lin-prod.name
  vapp_name   = vcd_vm.lin-prod.vapp_name
  vdc         = vcd_vm.lin-prod.vdc
  size_in_mb  = (1024 * 200)
  bus_type    = "paravirtual"
  bus_number  = 1
  unit_number = 0
  lifecycle {
    prevent_destroy = true
  }
}
