---
title: "PCI(e) Passthrough"
linkTitle: "PCI(e) Passthrough"
weight: 130
---

## The Steps

* Enable IOMMU (e.g `echo intel_iommu=on >> /etc/kernel/cmdline`)
* Apply changes `pve-efiboot-tool refresh`
* Add Kernel Modules
* Refresh your initramfs and REBOOT (`update-initramfs -u -k all` + `reboot`)
* Verify if it works
* Passthrough PCIe Card (pass the device IDs to the options of the vfio-pci modules)


### Prepare the Host

#### IOMMU

Add the following to `/etc/kernel/cmdline`

* for Intel CPUs
    * `intel_iommu=on`
* for AMD CPUs
    * `amd_iommu=on`

```sh
cat /etc/kernel/cmdline 
root=ZFS=rpool/ROOT/pve-1 boot=zfs intel_iommu=on
```

> Attention! One Line only!

Apply your changes

```sh
pve-efiboot-tool refresh
```

#### Kernel Modules

Add the following to `/etc/modules`

```
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

```
# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.

vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

#### Refresh your initramfs and REBOOT

```sh
update-initramfs -u -k all
```

```sh
reboot
```

#### Verify if it is enabled

```sh
dmesg | grep -e DMAR -e IOMMU -e AMD-Vi
```

```sh
find /sys/kernel/iommu_groups/ -type l
```

##### Examples

Intel `dmesg`
```
[    0.013654] ACPI: DMAR 0x00000000BAFDA000 0000B8 (v01 INTEL  SNB      00000001 INTL 00000001)
[    0.065485] DMAR: IOMMU enabled
[    0.133534] DMAR: Host address width 36
[    0.133536] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.133542] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.133545] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.133549] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.133551] DMAR: RMRR base: 0x000000ba3ba000 end: 0x000000ba3d0fff
[    0.133553] DMAR: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
[    0.133557] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.133559] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.133561] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.133975] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.825025] DMAR: No ATSR found
[    0.825073] DMAR: dmar0: Using Queued invalidation
[    0.825079] DMAR: dmar1: Using Queued invalidation
[    0.913290] DMAR: Intel(R) Virtualization Technology for Directed I/O
[    5.728472] i915 0000:00:02.0: DMAR active, disabling use of stolen memory
```

AMD `dmesg`
```
[    1.481126] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters supported
[    1.484439] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    1.484440] pci 0000:00:00.2: AMD-Vi: Extended features (0x58f77ef22294ade):
[    1.484442] AMD-Vi: Interrupt remapping enabled
[    1.484442] AMD-Vi: Virtual APIC enabled
[    1.484443] AMD-Vi: X2APIC enabled
[    1.484564] AMD-Vi: Lazy IO/TLB flushing enabled
[    1.485735] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/bank).
```

IOMMU Groups

```sh
find /sys/kernel/iommu_groups/ -type l
/sys/kernel/iommu_groups/7/devices/0000:00:1b.0
/sys/kernel/iommu_groups/5/devices/0000:00:19.0
...
```

## Passthrough a PCIe Card

#### Example with NVIDIA Card

```sh
lspci -nn | grep -i nvidia

01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK107GLM [Quadro K1000M] [10de:0ffc] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation GK107 HDMI Audio Controller [10de:0e1b] (rev ff)
```

The following needs to be added to a `.conf` file in `/etc/modprobe.d/`

e.g. `/etc/modprobe.d/pcie.conf`

```
options vfio-pci ids=10de:0ffc,10de:0e1b
```

Update `update-initramfs -u -k all` and `reboot`

Check with `lspci -nnk` --> `Kernel driver in use: vfio-pci`

```sh
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK107GLM [Quadro K1000M] [10de:0ffc] (rev a1)
	...
	Kernel driver in use: vfio-pci
	...
01:00.1 Audio device [0403]: NVIDIA Corporation GK107 HDMI Audio Controller [10de:0e1b] (rev a1)
	...
	Kernel driver in use: vfio-pci
	...
```

## Install a VM

Set **q35** as machine type, **OVMF (EFI for VMs)** as BIOS 

![VM Install 1](/notes/images/vm_pcie_1.png)

After the install. Add the GPU.

Check **PCIe** and the rest

![VM Install 2](/notes/images/vm_pcie_2.png)

## Links

* https://pve.proxmox.com/wiki/PCI(e)_Passthrough