# Plan: wired CarPlay on BMW CIC HIGH

Updated 2026-11-26.

## Research summary

- **There is no public software-only CarPlay for the CIC.** CarPlay needs an Apple MFi authentication chip, and in
  wired CarPlay the iPhone becomes the USB host, while the CIC's USB port is host-only. Every CarPlay-on-CIC product
  found is a hardware box that injects video over LVDS (for example Bimmertech MMI Prime).
- **Software-only Android Auto for the CIC exists:** [bmw-cic-androidauto](https://github.com/josemalm32/bmw-cic-androidauto) (AAPlugin).
  - Runs inside the CIC's HmiMain; H.264/AAC are decoded on the CIC DSP (TI DM642); input via iDrive.
  - Installed from USB: at boot the CIC runs the scrambled `/fs/usb0/copie_scr.sh`.
  - Known HmiMain builds: 9283417A (C1A, E9x), `CIC_L6_1107_Release B1107-501-1121A Build 11` (**E60 LCI**),
    `CIC_L6_1103_Release B1103-500-1048A Build 43` (C16A, E9x LCI). Other builds can be profiled from a `/dev/fs0` copy.
  - Limits: 800x480 video (DSP limit), ~0.5 s latency, no microphone.
- **CarPlay dongles (Carlinkit CPC200 and similar)** do the CarPlay and MFi part themselves and send H.264 video and
  audio to a USB host over a simple protocol, documented by open projects (node-carplay, pi-carplay). The dongle has
  its own Wi-Fi, so wireless CarPlay may also work.

## Delivery options (tried in this order)

The goal is the least hardware possible. Each option is tried only if the one before it proves impossible.

1. **Software only, phone cable.** Software installed once from a USB stick; afterwards the iPhone is plugged into
   the car's USB with a normal cable and CarPlay runs. Blockers to check:
   - **USB role switch:** in wired CarPlay the iPhone becomes the USB host, so the CIC port must work in device (OTG)
     mode. The diagnostic stick (v2) lists the USB controller and driver options.
   - **Apple MFi authentication:** the iPhone asks the car to sign a challenge with an Apple auth coprocessor.
     The diagnostic stick looks for any iPod/iAP/auth support on the CIC. The Combox's iPod chip sits in a separate
     ECU and is probably an older, non-CarPlay version.
   - **Protocol:** CarPlay video/audio is AirPlay-based with Apple encryption; no open receiver exists.
   Expected: very unlikely, but we confirm with data before dropping it.
2. **Software runs from a USB stick that stays in the glovebox port**, phone on a cable (armrest port, if it is a
   separate CIC/Combox port). Same blockers as option 1, but nothing is written to the CIC flash.
3. **Software installed once + CarPlay dongle** (Carlinkit CPC200-style) in a USB port. The dongle supplies MFi auth
   and the CarPlay protocol; the iPhone connects to it wirelessly. Most likely to work.
4. **Software on a stick + dongle**, both in the glovebox (through a USB hub). Fallback if installing to flash is
   not possible on a given CIC build.

## Architecture

```
iPhone --(cable or Wi-Fi)--> CarPlay dongle --USB--> CIC
                                                     ├─ plugin in HmiMain (menu entry, iDrive keys)
                                                     ├─ USB protocol process (dongle protocol instead of AA)
                                                     └─ DSP feeder (H.264 + AAC/PCM -> DM642)
```

Reused from AAPlugin: the HMI plugin, the DSP video/audio path, iDrive key capture.
Replaced: the Android Auto protocol (AOA + TLS) with the CarPlay dongle protocol.

## Stages

1. **Identify the CIC version and check option 1** (now). The diagnostic stick (`diag/`, v2) reads system info,
   USB controller and Apple-auth probes, and a copy of `/dev/fs0`.
   HmiMain is extracted from it and compared with the known profiles (likely the E60 LCI build).
2. **Toolchain.** QNX Momentics 6.3.x (SH4, `ntosh-gcc-3.3.5`) on a Windows PC. QNX has retired it; it needs a
   myQNX account or an archived copy. This is the hardest part to obtain.
3. **Baseline test.** With unmodified AAPlugin (an Android phone, borrowed if needed), confirm that video through the
   DSP works on this CIC. This proves the DSP path before the CarPlay part is written.
4. **Dongle protocol on QNX.** Rewrite the USB part of `libcicaa` for the dongle protocol. Test on a PC first
   (Linux + dongle), then on the CIC.
5. **Video tuning.** Request 800x480 H.264 Baseline from the dongle; check DSP load.
6. **Audio and input.** Dongle audio (PCM/AAC) to the DSP; iDrive rotate/press -> CarPlay buttons.

## Risks

- The diagnostics (stage 1) write nothing to the CIC.
- The plugin is written to the flash `Plugins/` folder and is removed by deleting that folder. The DSP change lives in RAM only.
- **Do not update the CIC software** (ISTA/E-Sys) just for this project: that is the biggest bricking risk.
- Never write to `/dev/fs0*`.

## Needed

- FAT32 USB stick (≥1 GB).
- CarPlay USB dongle (Carlinkit CPC200-style), to buy after stage 1.
- A Windows PC for the QNX tools.
