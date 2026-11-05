packer {
    required_plugins {
        proxmox = {
            version = ">=1.1.5"
            source  = "github.com/hashicorp/proxmox"
        }
    }
}

source "proxmox-iso" "image" {
    // PVE login
    proxmox_url              = var.pve_api_url
    username                 = var.pve_username
    token                    = var.pve_token
    node                     = var.pve_node
    insecure_skip_tls_verify = var.skip_tls_check

    // SSH
    ssh_username              = var.ssh_username
    ssh_timeout               = var.ssh_timeout
    ssh_keypair_name          = var.ssh_keypair_name
    ssh_private_key_file      = var.ssh_private_key_file
    ssh_clear_authorized_keys = var.ssh_clear_authorized_keys

    // HTTP server
    http_interface    = var.http_interface
    http_bind_address = var.http_bind_address
    http_port_min     = var.http_port_min
    http_port_max     = var.http_port_max

    // ISO
    os                   = var.os
    template_description = "Packer generated template image on ${timestamp()}"
    task_timeout         = var.task_timeout


    // System
    machine    = var.machine
    bios       = var.bios
    qemu_agent = var.qemu_agent

    // Disks
    scsi_controller = var.scsi_controller
    dynamic "disks" {
      for_each = var.disks
        content {
          type         = disks.value.type
          storage_pool = disks.value.storage_pool
          disk_size    = disks.value.size
          cache_mode   = disks.value.cache_mode
          format       = disks.value.format
          io_thread    = disks.value.io_thread
          discard      = disks.value.discard
          ssd          = disks.value.ssd
        }

    }
    // Cloud-init
    cloud_init              = var.cloud_init
    cloud_init_storage_pool = var.cloud_init_storage_pool

    // CPU & Memory
    sockets  = var.sockets
    cores    = var.vcpu
    cpu_type = var.cpu_type
    memory   = var.memory

    // Network
    network_adapters {
        bridge   = var.net_bridge
        model    = var.net_model
        vlan_tag = var.net_vlan_tag
        firewall = var.net_firewall
    }
}
