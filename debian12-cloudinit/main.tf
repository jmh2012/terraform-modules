provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
}

resource "debian12_vm_qemu" "vm" {
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
    size     = "var.disk_size
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
    bridge = var.network_bridge
  }

  ipconfig0 = "ip=dhcp"

  ciuser     = var.ssh_user
  sshkeys    = var.ssh_public_key

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
