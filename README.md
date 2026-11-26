# bmw-cic-carplay

Wired Apple CarPlay for the BMW **CIC HIGH** iDrive head unit (first target car: E61 LCI 2009, CIC High + Combox).

Idea: a CarPlay USB dongle (Carlinkit-style) handles the Apple side and delivers H.264 video and audio over USB.
A plugin running inside the CIC decodes the video on the CIC's own DSP (TI DM642), shows it on screen,
and maps the iDrive controller to CarPlay input. No LVDS box, no screen disassembly.

Status: **Stage 1, identifying the CIC software version.** Details: [docs/PLAN.md](docs/PLAN.md).

## Layout

| Path | What |
|---|---|
| `diag/copie_scr.plain.sh` | Read-only diagnostic boot script: CIC info + flash copy to the USB stick |
| `tools/cic_script.py` | Encode/decode the CIC `copie_scr.sh` boot script and stage a USB stick |
| `docs/PLAN.md` | Research summary, architecture, stages and risks |

## Making the diagnostic USB stick

```
python tools/cic_script.py stage diag/copie_scr.plain.sh out/usb
```

Copy `out/usb/copie_scr.sh` to the root of a FAT32 stick, switch the ignition on, plug the stick in and reboot the CIC
(hold the radio power/volume knob for ~25–30 s). The CIC only runs the script while booting.
After ~5 minutes the stick has `CICDIAG/` with `INFO.TXT`, `fs0.img` and `DONE.TXT`.

**Never commit `fs0.img` or any other file copied from a car** (`.gitignore` blocks them). They contain BMW software.

## Help wanted: CIC owners

We are looking for people with a **BMW CIC HIGH** head unit to test and contribute, especially cars that
also have a **Combox**, so that Bluetooth audio and phone calls keep working alongside CarPlay.

Every car helps, because each CIC software build needs its own profile. To join:

1. Run the read-only diagnostic stick above (it changes nothing on the CIC).
2. Open a **[Car report](../../issues/new?template=car-report.yml)** issue with your car, CIC/Combox details and the
   contents of `INFO.TXT`. **Do not upload `fs0.img`**: it contains BMW software. We will ask for specific values from it.
3. Code, reverse-engineering notes and testing are all welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

Useful to have: a CarPlay USB dongle (Carlinkit CPC200-style), an iPhone, and for developers a Windows PC
with the QNX Momentics 6.3.x SH4 toolchain.

## License and contributing

License: [PolyForm Noncommercial 1.0.0](LICENSE.md). Contributions welcome, see [CONTRIBUTING.md](CONTRIBUTING.md).

This project builds on the publicly documented [bmw-cic-androidauto](https://github.com/josemalm32/bmw-cic-androidauto)
project (also PolyForm Noncommercial 1.0.0). Not affiliated with BMW or Apple. Use at your own risk.
