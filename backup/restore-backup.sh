#!/bin/sh
# TV Detox Restore Script — Sony BRAVIA VU31
# Created: 2026-10-24 18:09 IST
# TV IP: 192.168.0.229
# 
# This script re-enables ALL packages that were enabled before the cleanup.
# Run: sh restore-backup.sh 192.168.0.229
#
# To use: ensure USB/Network debugging is on, then run this script.

TV_IP="${1:-192.168.0.229}"

echo "Connecting to TV at $TV_IP..."
adb connect "$TV_IP"
sleep 2

echo ""
echo "Re-enabling all disabled packages..."
for p in $(adb -s "$TV_IP:5555" shell pm list packages -d | tr -d '\r' | sed 's/package://'); do
    echo "  Enabling: $p"
    adb -s "$TV_IP:5555" shell pm enable "$p"
done

echo ""
echo "Restoring animation settings..."
adb -s "$TV_IP:5555" shell settings put global window_animation_scale 1
adb -s "$TV_IP:5555" shell settings put global transition_animation_scale 1
adb -s "$TV_IP:5555" shell settings put global animator_duration_scale 1

echo ""
echo "Done! Restarting TV..."
adb -s "$TV_IP:5555" shell reboot
echo "TV is restarting. It should come back to its original state."
