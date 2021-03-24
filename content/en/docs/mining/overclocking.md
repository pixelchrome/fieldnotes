---
title: "Overclocking GPUs"
linkTitle: "Overclocking GPUs"
weight: 130
---

# Overclocking

## NVIDIA Cards

The examples below are for 1070 TI 

### Ubuntu

#### `Coolbits` must be set

Run `nvidia-xconfig --enable-all-gpus` and and set Coolbits

`/usr/share/X11/xorg.conf.d/10-nvidia.conf`

```
Section "OutputClass"
    Identifier "nvidia"
    MatchDriver "nvidia-drm"
    Driver "nvidia"
    Option "AllowEmptyInitialConfiguration"
    Option "Coolbits" "24"
    ModulePath "/usr/lib/x86_64-linux-gnu/nvidia/xorg"
EndSection
```

```
reboot
```

#### Persistence Mode

Before we do any actual tweaks, we should enable Persistence Mode to ensure our changes stay active even after we close any applications that might be using our card.

```sh
nvidia-smi -pm 1
```

```sh
Enabled persistence mode for GPU 00000000:01:00.0.
Enabled persistence mode for GPU 00000000:03:00.0.
All done.
```

#### Power Limits

Query

```sh
nvidia-smi -i 0 -q -d power
```

Set

```sh
nvidia-smi -i 0 -pl 130
```

#### Clock

Query

```sh
nvidia-smi -i 0 -q -d clock
```

Set

```sh
XAUTH=`pgrep -af Xauthority | awk {' print $7 }'`
DISPLAY=:0 XAUTHORITY=$XAUTH nvidia-settings -c :0 -a [gpu:0]/GPUMemoryTransferRateOffset[2]=1300
DISPLAY=:0 XAUTHORITY=$XAUTH nvidia-settings -c :0 -a [gpu:0]/GPUMemoryTransferRateOffset[3]=1300
DISPLAY=:0 XAUTHORITY=$XAUTH nvidia-settings -c :0 -a [gpu:0]/GPUGraphicsClockOffset[2]=200
DISPLAY=:0 XAUTHORITY=$XAUTH nvidia-settings -c :0 -a [gpu:0]/GPUGraphicsClockOffset[3]=200
```

#### Script all together

```bash
#!/bin/bash

## run `nvidia-xconfig --enable-all-gpus``
## add `Option "Coolbits" "24"` to `/usr/share/X11/xorg.conf.d/10-nvidia.conf`

XAUTH=`pgrep -af Xauthority | awk {' print $7 }'`

nvidia-smi -pm 1
nvidia-smi -pl 125

GPU=1

for i in $(seq 0 $GPU)
do
	echo Setting Parameters for GPU$i
	DISPLAY=:0 XAUTHORITY=$XAUTH nvidia-settings -a [gpu:$i]/GpuPowerMizerMode=1
	DISPLAY=:0 XAUTHORITY=$XAUTH nvidia-settings -a [gpu:$i]/GPUFanControlState=1
	DISPLAY=:0 XAUTHORITY=$XAUTH nvidia-settings -a [gpu:$i]/GPUTargetFanSpeed=80
	DISPLAY=:0 XAUTHORITY=$XAUTH nvidia-settings -c :0 -a [gpu:$i]/GPUMemoryTransferRateOffset[2]=1300
	DISPLAY=:0 XAUTHORITY=$XAUTH nvidia-settings -c :0 -a [gpu:$i]/GPUMemoryTransferRateOffset[3]=1300
	DISPLAY=:0 XAUTHORITY=$XAUTH nvidia-settings -c :0 -a [gpu:$i]/GPUGraphicsClockOffset[2]=200
	DISPLAY=:0 XAUTHORITY=$XAUTH nvidia-settings -c :0 -a [gpu:$i]/GPUGraphicsClockOffset[3]=200
done
```

## Links
* http://cryptomining-blog.com/7341-how-to-squeeze-some-extra-performance-mining-ethereum-on-nvidia/
* https://gist.github.com/johnstcn/add029045db93e0628ad15434203d13c#overclocking
* https://www.simonmott.co.uk/2017/07/ethereum-mining-nvidia-linux/