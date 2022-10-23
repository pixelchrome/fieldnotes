---
title: "proxmox cloud images"
linkTitle: "proxmox cloud images"
weight: 120
---

# Configure Cloud Image (Ubuntu)

## Create a VM

- SSH to PVE
- Download the image http://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

```sh
qm create 9002 --memory 4096 --core 2 --name ubuntu-cloud-2204 --net0 virtio,bridge=vmbr0
qm importdisk 9002 jammy-server-cloudimg-amd64.img local-zfs
qm set 9002 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9001-disk-0
qm set 9002 --ide2 local-zfs:cloudinit
qm set 9002 --boot c --bootdisk scsi0
qm set 9002 --serial0 socket --vga serial0
```

- Do not start the VM!

### Settings
#### Cloud Init
- User -> harry
- SSH public key -> Authorized Keys
- Network - DHCP - SLAAC
#### Options
- QEMU Guest Agent - Enabled - Run guest-trim...

### Create the template

`qm template 9002`

# Clone the VM

- `qm clone 9001 <newid e.g. 135> --name <newname e.g. yoshi> --full`

## Links

* Techno Tim - https://www.youtube.com/watch?v=shiIi38cJe4
* Techno Tim - https://docs.technotim.live/posts/cloud-init-cloud-image/