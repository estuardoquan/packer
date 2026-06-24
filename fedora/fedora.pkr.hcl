build {
    source "proxmox-iso.image" {
        name         = "f44"
        boot_command = var.boot_cmd_fedora
        boot_wait    = var.boot_wait
        
        http_content = { "/anaconda-ks.cfg" = templatefile("configs/anaconda-ks.cfg", {
                var            = var,
                ssh_public_key = chomp(file(var.ssh_public_key_file))
            })
        }

        efi_config {
            efi_storage_pool    = var.efi_storage_pool
            pre_enrolled_keys   = var.pre_enrolled_keys
            efi_format          = var.efi_format
            efi_type            = var.efi_type
        }
        
        boot_iso {
            iso_checksum = var.iso_checksum["fedora44"]
            iso_download_pve = var.iso_download_pve
            iso_storage_pool = var.iso_storage_pool
            iso_url = var.iso_url["fedora44"]
            unmount = var.unmount_iso
        }
        
        template_name = "f44-se"
        vm_id         = var.vm_id["fedora44"]
  }

  provisioner "shell" {
        scripts = concat(var.user_scripts, [
          "configs/init.sh",
          "configs/custom.sh",
          "configs/install-nsupdate-key.sh",
          "configs/cleanup.sh",
        ])
  }
}
