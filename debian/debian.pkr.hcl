build {
    source "proxmox-iso.image" {
        name         = "debian-k3s"
        boot_command = var.boot_cmd_debian
        boot_wait    = var.boot_wait

        http_content = { "/preseed.cfg" = templatefile("configs/preseed.cfg", {
                var            = var,
                ssh_public_key = chomp(file(var.ssh_public_key_file))
            })
        }

        efi_config {
            efi_storage_pool  = var.efi_storage_pool
            pre_enrolled_keys = var.pre_enrolled_keys
            efi_format        = var.efi_format
            efi_type          = var.efi_type
        }

        boot_iso {
            iso_checksum     = var.iso_checksum["debian13"]
            iso_download_pve = var.iso_download_pve
            iso_storage_pool = var.iso_storage_pool
            iso_url          = var.iso_url["debian13"]
            unmount          = var.unmount_iso
        }

        template_name = "<template-name>"
        vm_id         = var.vm_id["debian13"]
    }

    provisioner "shell" {
        scripts = concat(var.user_scripts, [
          "configs/init.sh",
          "configs/custom.sh",
          "configs/cleanup.sh",
        ])
    }
}
