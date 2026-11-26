#!/bin/ksh
# CIC diagnostics (read-only). Writes nothing to the CIC; output goes to the USB stick only.
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/opt/bin:/mnt/EFS_RO/opt/bin:/mnt/EFS_RO/bin:/proc/boot
export PATH
USB=/fs/usb0
OUT="$USB/CICDIAG"
[ -f "$OUT/DONE.TXT" ] && exit 0
mkdir -p "$OUT" || exit 0
LOG="$OUT/INFO.TXT"
exec > "$LOG" 2>&1
s() { echo; echo "===== $*"; "$@"; }
echo "CIC diag v2"
s date
s uname -a
s cat /etc/starter.cfg
s ls -l /etc
s ls -lR /mnt/EFS_RO/Hmi/data/ro/Plugins
s ls -l /mnt/EFS_RO /mnt/EFS_RO/Hmi /mnt/EFS_RO/Hmi/data /mnt/EFS_RO/Hmi/data/ro
s ls -l /mnt /mnt/hbdebug /mnt/hbuser
s ls -l /fs /dev
echo; echo "===== dvd_dm642 images"
find /mnt -name 'dvd_dm642*' -exec ls -l {} \; 2>&1
for F in /etc/*version* /etc/*VERSION* /mnt/EFS_RO/*version* /mnt/EFS_RO/etc/*version*; do
 [ -f "$F" ] && { echo; echo "===== $F"; cat "$F"; }
done
s pidin arg
s usb -v
s df -k
# ---- Option 1 probes: USB controller (device/OTG mode?) and Apple auth / iPod support ----
s ls -l /proc/boot
s ls -l /dev/io-usb /dev/usb /dev/i2c* /dev/ipod* /dev/iap* /dev/umass*
s pidin -p io-usb arg
s pidin mem
echo; echo "===== usb/otg/apple related files"
for D in /proc/boot /mnt/EFS_RO /etc /usr /opt; do
 [ -d "$D" ] || continue
 find "$D" \( -iname '*usb*' -o -iname '*otg*' -o -iname '*ipod*' -o -iname '*iap*' -o -iname '*mfi*' -o -iname '*apple*' -o -iname '*auth*cp*' -o -iname '*i2c*' \) 2>/dev/null
done
echo; echo "===== /etc/starter.cfg usb lines"
grep -i -n 'usb\|ipod\|iap\|i2c\|otg' /etc/starter.cfg /etc/*.cfg 2>/dev/null
/bin/sync 2>/dev/null; sync 2>/dev/null
# Raw flash copy (READ-ONLY from /dev/fs0), needed to identify the HmiMain build
echo; echo "===== fs0 copy start"; date
ls -l /dev/fs0*
cp /dev/fs0 "$OUT/fs0.img" && echo FS0_OK || echo FS0_FAIL
ls -l "$OUT/fs0.img"
date
/bin/sync 2>/dev/null; sync 2>/dev/null
echo done > "$OUT/DONE.TXT"
/bin/sync 2>/dev/null; sync 2>/dev/null
exit 0
