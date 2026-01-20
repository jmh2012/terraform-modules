terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc05"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  target_node = var.target_node
  clone       = "debian-12-cloudinit"

  os_type = "cloud-init"

  cores   = var.cores
  sockets = var.sockets
  memory  = var.memory

  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot     = "scsi0"
    size     = var.disk_size
    type     = "disk"
    storage  = "local-lvm"
  }

disk {
  slot    = "ide2"
  type    = "cloudinit"
  storage = "local-lvm"
}

  network {
    id = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=dhcp"

  ciuser     = "debian"
  sshkeys    = var.ssh_public_key

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
