# Sony BRAVIA TV Detox — Complete Undo & Restoration Guide

This document explains step-by-step how to revert any or all changes made during the TV Detox session on your **Sony BRAVIA (VU31 / Android 14)**.

---

## 📋 Table of Contents
1. [Prerequisites & Connecting to Your TV](#1-prerequisites--connecting-to-your-tv)
2. [One-Click Complete Restoration (Reset Everything)](#2-one-click-complete-restoration)
3. [App-Specific Re-Enable Commands](#3-app-specific-re-enable-commands)
4. [Restoring the Default Google TV Home Screen](#4-restoring-the-default-google-tv-home-screen)
5. [Restoring System Animations & Settings](#5-restoring-system-animations--settings)
6. [Emergency Recovery (If TV Ever Bootloops)](#6-emergency-recovery)

---

## 1. Prerequisites & Connecting to Your TV

Before running any commands from your computer:

1. **Turn on Debugging on the TV:**
   - Go to: **Settings → System (or Device Preferences) → Developer options**.
   - Turn **ON**: **USB debugging** (and **Network / Wireless debugging** if listed).
2. **Open Terminal on your Mac:**
   - Ensure your Mac and TV are on the same Wi-Fi network.
   - Run the connect command (replace `192.168.0.229` with your TV's current IP if it changed):
     ```bash
     adb connect 192.168.0.229:5555
     ```
   - If prompted on the TV screen, select **"Always allow from this computer"** and click **Allow**.

---

## 2. One-Click Complete Restoration

If you ever want to completely undo all changes and return your TV to 100% of its original factory state:

### Method A: Using the Automated Restore Script
Run the automated restore script created during your setup session:
```bash
sh ~/Downloads/tv-detox/backup/restore-backup.sh 192.168.0.229
```
*This re-enables all 29 disabled packages, restores animation speeds to 1.0x, and restarts the TV.*

### Method B: Using `undo.sh` (from tv-detox)
```bash
cd ~/Downloads/tv-detox
sh undo.sh 192.168.0.229
```
*This re-enables Google TV Launcher, restores setup routing, and removes the TV Detox home screen.*

### Method C: One-Liner Terminal Command
To re-enable every disabled package at once:
```bash
for pkg in $(adb -s 192.168.0.229:5555 shell pm list packages -d | tr -d '\r' | sed 's/package://'); do
    adb -s 192.168.0.229:5555 shell pm enable "$pkg"
done
```

---

## 3. App-Specific Re-Enable Commands

If you only want to restore a **single specific feature** (e.g. AirPlay, Google TV launcher, or a specific app), run the matching command below:

### 🍏 AirPlay & Apple Screen Mirroring
If you need Apple AirPlay back:
```bash
adb -s 192.168.0.229:5555 shell pm enable com.sony.dtv.airplayapp
```

### 📺 Home Screen & Google TV Setup
To restore the default Google TV home screen with Google recommendations:
```bash
# 1. Re-enable Google TV Launcher
adb -s 192.168.0.229:5555 shell pm enable com.google.android.apps.tv.launcherx

# 2. Re-enable Google TV Setup Routing
adb -s 192.168.0.229:5555 shell pm enable com.google.android.tungsten.setupwraith

# 3. Re-enable Google TV Ambient Screensaver
adb -s 192.168.0.229:5555 shell pm enable com.google.android.apps.tv.dreamx
```

### 📅 Calendar & Account Sync
```bash
adb -s 192.168.0.229:5555 shell pm enable com.google.android.syncadapters.calendar
```

### 🎬 Media & Store Apps
```bash
# Sony Pictures Core (Sony Movie Store)
adb -s 192.168.0.229:5555 shell pm enable com.sonypicturescore

# Google Play Movies & TV (Google Videos)
adb -s 192.168.0.229:5555 shell pm enable com.google.android.videos
```

### 🏷️ Sony Apps, Manuals & Overlays
```bash
# Sony Select (App store recommendations)
adb -s 192.168.0.229:5555 shell pm enable com.sony.dtv.sonyselect

# Sony Promos (Promotional banners)
adb -s 192.168.0.229:5555 shell pm enable com.sony.dtv.promos

# Sony Tab (Sponsored content tab)
adb -s 192.168.0.229:5555 shell pm enable com.sony.dtv.sonytab

# Sony Help Guide (Built-in user manual)
adb -s 192.168.0.229:5555 shell pm enable com.sony.dtv.helpguidecontents

# Sony Smart Help (Interactive help popups)
adb -s 192.168.0.229:5555 shell pm enable com.sony.dtv.smarthelp

# Sony Smart UI (Content recommendation agent)
adb -s 192.168.0.229:5555 shell pm enable com.sony.dtv.smartui

# Sony In-Store Demo Mode
adb -s 192.168.0.229:5555 shell pm enable com.sony.dtv.multiscreendemo

# Sony License & EULA Viewers
adb -s 192.168.0.229:5555 shell pm enable com.sony.dtv.eulaviewer
adb -s 192.168.0.229:5555 shell pm enable com.sony.dtv.softwarelicense
```

### ⚙️ Realtek & Google Advertising / Telemetry
```bash
# Google TV Promotional Engine (Axel)
adb -s 192.168.0.229:5555 shell pm enable com.google.android.tv.axel

# GrayMatrix OEM Analytics Daemon
adb -s 192.168.0.229:5555 shell pm enable com.graymatrix.did

# Realtek Factory Service Menu
adb -s 192.168.0.229:5555 shell pm enable com.realtek.servicemenu

# Realtek Unboxing Partner Customizer
adb -s 192.168.0.229:5555 shell pm enable com.realtek.tvsetup.partnercustomizer

# Android Ad Services & Tracking
adb -s 192.168.0.229:5555 shell pm enable com.android.adservices.api
adb -s 192.168.0.229:5555 shell pm enable com.android.federatedcompute.services
adb -s 192.168.0.229:5555 shell pm enable com.android.ondevicepersonalization.services

# Google Crash Feedback Reporter
adb -s 192.168.0.229:5555 shell pm enable com.google.android.feedback
```

### 📱 Unused Phone Services
```bash
# Camera Subsystem
adb -s 192.168.0.229:5555 shell pm enable com.android.camera2
adb -s 192.168.0.229:5555 shell pm enable com.android.cameraextensions

# Printer Service
adb -s 192.168.0.229:5555 shell pm enable com.android.printspooler

# Wallpaper Backup & Live Wallpapers
adb -s 192.168.0.229:5555 shell pm enable com.android.wallpaperbackup
adb -s 192.168.0.229:5555 shell pm enable com.android.wallpaper.livepicker
```

---

## 4. Restoring the Default Google TV Home Screen

If you want the remote's **Home** button to open the original Google TV home screen again:

```bash
# 1. Re-enable Google TV
adb -s 192.168.0.229:5555 shell pm enable com.google.android.apps.tv.launcherx
adb -s 192.168.0.229:5555 shell pm enable com.google.android.tungsten.setupwraith

# 2. Set Google TV as the default HOME role
adb -s 192.168.0.229:5555 shell cmd role add-role-holder --user 0 android.app.role.HOME com.google.android.apps.tv.launcherx
adb -s 192.168.0.229:5555 shell cmd package set-home-activity com.google.android.apps.tv.launcherx/.home.HomeActivity

# 3. Optional: Uninstall TV Detox Home Screen
adb -s 192.168.0.229:5555 uninstall com.ansub.tvhome
```

---

## 5. Restoring System Animations & Settings

To revert UI animations and process limits back to Android's defaults:

```bash
# Revert animation scales back to default 1.0x
adb -s 192.168.0.229:5555 shell settings put global window_animation_scale 1
adb -s 192.168.0.229:5555 shell settings put global transition_animation_scale 1
adb -s 192.168.0.229:5555 shell settings put global animator_duration_scale 1

# Reset sleep timeout to default (20 or 30 minutes)
adb -s 192.168.0.229:5555 shell settings put system screen_off_timeout 1200000

# Remove the cached background process limit (allow Android default)
adb -s 192.168.0.229:5555 shell device_config delete activity_manager max_cached_processes

# Re-allow background execution for streaming apps
for pkg in in.startv.hotstar com.viewlift.hoichoi com.netflix.ninja com.sonyliv com.amazon.amazonvideo.livingroom; do
    adb -s 192.168.0.229:5555 shell cmd appops set "$pkg" RUN_IN_BACKGROUND allow
    adb -s 192.168.0.229:5555 shell cmd appops set "$pkg" RUN_ANY_IN_BACKGROUND allow
done
```

---

## 6. Emergency Recovery (If TV Ever Gets Stuck)

Your TV's network port 5555 connects for a few seconds during every boot. If your TV ever gets stuck restarting:

1. Connect your computer to the TV's Wi-Fi.
2. In your Terminal, run:
   ```bash
   adb connect 192.168.0.229:5555
   adb wait-for-device
   for p in $(adb shell pm list packages -d | tr -d '\r' | sed 's/package://'); do adb shell pm enable "$p"; done
   adb shell reboot
   ```
3. This unfreezes every disabled app and reboots the TV normally.

---

### 🔒 Reminder: Debugging Security
After making any undo adjustments, always turn **OFF** Developer Options / USB Debugging in **Settings → System → Developer options** on your TV to keep your TV secure on your home network.
