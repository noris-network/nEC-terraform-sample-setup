resource "vcd_vm" "win-dev" {
  name                   = "win-dev.noris.de"
  computer_name          = "win-dev"
  description            = "win dev"
  vdc                    = "HA-DN6A-1-1"
  cpus                   = 4
  cpu_hot_add_enabled    = true
  memory                 = (1024 * 16)
  memory_hot_add_enabled = true
  vapp_template_id       = data.vcd_catalog_vapp_template.noris-Windows_Server_2022_Standard_English.id

  network {
    type                         = "org"
    adapter_type                 = "VMXNET3"
    name                         = data.vcd_network_routed_v2.PROD-NET.name
    ip_allocation_mode           = "MANUAL"
    ip                           = "172.16.0.2"
    secondary_ip_allocation_mode = "MANUAL"
    secondary_ip                 = "2001:780:0:1::2"
    is_primary                   = true
  }

  lifecycle {
    ignore_changes  = [vapp_template_id, consolidate_disks_on_create]
    prevent_destroy = true
  }
}

#############
# bus 1 disk 0 150GB d
#############
resource "vcd_vm_internal_disk" "win-dev_bus1_disk0" {
  vm_name     = vcd_vm.win-dev.name
  vapp_name   = vcd_vm.win-dev.vapp_name
  vdc         = vcd_vm.win-dev.vdc
  size_in_mb  = (1024 * 150)
  bus_type    = "paravirtual"
  bus_number  = 1
  unit_number = 0
  lifecycle {
    prevent_destroy = true
  }
}

#############
# bus 1 disk 1 250GB e
#############
resource "vcd_vm_internal_disk" "win-dev_bus1_disk1" {
  vm_name     = vcd_vm.win-dev.name
  vapp_name   = vcd_vm.win-dev.vapp_name
  vdc         = vcd_vm.win-dev.vdc
  size_in_mb  = (1024 * 250)
  bus_type    = "paravirtual"
  bus_number  = 1
  unit_number = 1
  depends_on  = [vcd_vm_internal_disk.win-dev_bus1_disk0]
  lifecycle {
    prevent_destroy = true
  }
}

#############
# bus 1 disk 2 100GB f
#############
resource "vcd_vm_internal_disk" "win-dev_bus1_disk2" {
  vm_name     = vcd_vm.win-dev.name
  vapp_name   = vcd_vm.win-dev.vapp_name
  vdc         = vcd_vm.win-dev.vdc
  size_in_mb  = (1024 * 100)
  bus_type    = "paravirtual"
  bus_number  = 1
  unit_number = 2
  depends_on  = [vcd_vm_internal_disk.win-dev_bus1_disk1]
  lifecycle {
    prevent_destroy = true
  }
}
