build {
    source "proxmox-iso.image" {
        name         = "alpine"
        boot_command = var.boot_cmd_alpine
        boot_wait    = var.boot_wait

        http_content = { "/answers" = templatefile("configs/answers", {
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
            iso_checksum     = var.iso_checksum["alpine3"]
            iso_download_pve = var.iso_download_pve
            iso_storage_pool = var.iso_storage_pool
            iso_url          = var.iso_url["alpine3"]
            unmount          = var.unmount_iso
        }

        template_name = var.vm_template["alpine3"]
        vm_id         = var.vm_id["alpine3"]
    }

    provisioner "shell" {
        scripts = concat(var.user_scripts, [
          "${path.root}/configs/custom.sh",
          "${path.root}/configs/cleanup.sh",
        ])
    }
}
