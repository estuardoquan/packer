pve_api_url  = "https://10.10.0.39:8006/api2/json"
pve_username = "root@pam!packer"
pve_token    = ""
pve_node     = "pve-39"

disk_storage_pool = "proxmox"
efi_storage_pool  = "proxmox"
cloud_init_storage_pool = "proxmox"

disk_size = "20G"
vcpu      = 4
memory    = 4096

net_bridge   = "vlan20"
