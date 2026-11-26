#!/usr/bin/env python3
"""Encode/decode a BMW CIC boot script (copie_scr.sh) and stage a USB stick folder.

At boot the CIC runs /fs/usb0/copie_scr.sh from a USB stick, but only if the file is
scrambled with a fixed XOR keystream (seed 0x001BE3AC). The same operation encodes and
decodes; it is obfuscation, not a signature.

Usage:
  python tools/cic_script.py encode diag/copie_scr.plain.sh out/usb/copie_scr.sh
  python tools/cic_script.py decode some/copie_scr.sh plain.sh
  python tools/cic_script.py stage diag/copie_scr.plain.sh out/usb   # + zip
"""
import argparse
import sys
import zipfile
from pathlib import Path

SEED = 0x001BE3AC
M32 = 0xFFFFFFFF


def keystream():
    seed = SEED
    first = True
    while True:
        out = seed
        r = ((seed >> 1) | (seed << 31)) & M32
        r = (((r >> 16) & 0xFF) + r) & M32
        seed = (r - (((r >> 8) & 0xFF) << 16)) & M32
        if first:  # the original discards the first value
            first = False
            continue
        yield out & 0xFF


def transform(data: bytes) -> bytes:
    ks = keystream()
    return bytes(b ^ next(ks) for b in data)


def plain_bytes(path: Path) -> bytes:
    text = path.read_text(encoding="utf-8").replace("\r\n", "\n")
    if not text.startswith("#!/bin/ksh"):
        sys.exit(f"{path}: script must start with #!/bin/ksh")
    return text.encode("utf-8")


def main() -> None:
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="cmd", required=True)
    for name in ("encode", "decode"):
        s = sub.add_parser(name)
        s.add_argument("src", type=Path)
        s.add_argument("dst", type=Path)
    s = sub.add_parser("stage", help="encode into <dir>/copie_scr.sh and write <dir>.zip")
    s.add_argument("src", type=Path)
    s.add_argument("dir", type=Path)
    a = p.parse_args()

    if a.cmd == "encode":
        a.dst.parent.mkdir(parents=True, exist_ok=True)
        a.dst.write_bytes(transform(plain_bytes(a.src)))
    elif a.cmd == "decode":
        a.dst.write_bytes(transform(a.src.read_bytes()))
    else:
        enc = transform(plain_bytes(a.src))
        assert transform(enc) == plain_bytes(a.src)
        a.dir.mkdir(parents=True, exist_ok=True)
        (a.dir / "copie_scr.sh").write_bytes(enc)
        zpath = a.dir.with_suffix(".zip")
        with zipfile.ZipFile(zpath, "w", zipfile.ZIP_DEFLATED) as z:
            z.writestr("copie_scr.sh", enc)
        print(f"staged {a.dir / 'copie_scr.sh'} and {zpath}")


if __name__ == "__main__":
    main()
