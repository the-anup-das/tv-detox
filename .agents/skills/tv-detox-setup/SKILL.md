---
name: tv-detox-setup
description: >-
  Use this skill when the user wants to clean up, debloat, or speed up an
  Android TV or Google TV. Guides the agent through connecting to the TV over
  ADB, listing apps, disabling bloatware, installing the TV Detox home screen,
  and optimising system settings — all interactively with user confirmation at
  every step.
---

# TV Detox Setup — Full Cleanup Workflow

This skill walks you through making an old, slow Android TV fast again.
The laptop and TV must be on the same Wi-Fi network.

## Prerequisites

- `adb` installed on the user's machine (`brew install android-platform-tools`
  on macOS, or download Google's SDK Platform Tools on Windows).
- Developer mode and USB debugging enabled on the TV.

## Step-by-step procedure

### 1. Safety warning

Before changing anything, tell the user in plain words:

> This turns off system apps, and that has some risk. A few TVs got stuck at the
> logo or kept restarting, and you're an AI, so you can make mistakes. `undo.sh`
> and your undo list turn everything back on.

**Ask the user to confirm they want to go ahead.**

### 2. Connect to the TV

Connect over Wi-Fi using ADB. Walk the user through anything they need to tap
on the TV screen (e.g. "Allow USB debugging?" → tick "Always allow" → Allow).

```sh
adb connect <TV_IP>
adb devices
```

For Chromecast / newer Google TVs that only have **Wireless debugging**, guide
the user through the pairing-code flow:

```sh
adb pair <IP>:<pairing_port>   # enter the code shown on the TV
adb connect <IP>:<port>        # the port shown on the Wireless debugging screen
```

### 3. Inventory all apps

Before changing anything, list every app in plain English. Categorise them:

- **Safe to turn off** — bloatware, ad services, demo apps
- **Needed by the TV** — system UI, input framework, settings, keyboard
- **Apps the user uses** — streaming apps, games, etc.

Run the planner to get automated verdicts:

```sh
sh candidates.sh <TV_IP>
```

Check free memory:

```sh
adb shell cat /proc/meminfo | head -3
```

### 4. Disable bloatware (with user confirmation)

**Ask the user before every change.** Turn apps off instead of deleting them.
Keep a running list of what you changed and how to undo it.

```sh
adb shell pm disable-user --user 0 <package_name>
```

#### Never disable

- `com.google.android.gms` (Google Play services)
- Google Play Store
- Settings, System UI
- Setup apps
- The keyboard, Bluetooth
- HDMI inputs, the TV's input and tuner framework
- On Google TV / Chromecast: `com.google.android.apps.tv.launcherx`

When in doubt, **leave it on**.

### 5. Install the home screen

Clone this repo (if not already done) and run the install script:

```sh
sh install.sh <TV_IP>
# Or with specific apps:
sh install.sh <TV_IP> "com.netflix.ninja,com.youtube.tv"
# With settings shortcuts:
sh install.sh <TV_IP> "" "bluetooth,sound,picture"
```

### 6. Optimise animations and sleep

Turn off animations and set sleep timeout:

```sh
adb shell settings put global window_animation_scale 0
adb shell settings put global transition_animation_scale 0
adb shell settings put global animator_duration_scale 0
adb shell settings put system screen_off_timeout 300000
```

Ask if the TV is OLED. **Keep the screensaver on for OLED TVs** to prevent
burn-in.

### 7. Verify and restart

Wait 30 seconds after the last change, then restart:

```sh
adb shell reboot
```

After reboot, reconnect and check it starts normally:

```sh
adb connect <TV_IP>
adb shell pm list packages -d   # list disabled packages
```

Show free memory before and after.

### 8. Remind about debugging

Once everything is verified, remind the user:

> **Turn off USB debugging, Network debugging, and Wireless debugging** (or
> Developer options entirely) on the TV. While these are on, other devices on
> your network can ask to control it. Only turn them back on for `undo.sh` or
> updates.

## Undoing changes

To undo everything:

```sh
sh undo.sh <TV_IP>
```

To re-enable a single app:

```sh
adb shell pm enable <package_name>
```

## References

- [Debloat rules and safe/never-touch lists](../../docs/debloat.md)
- [README — full documentation](../../README.md)
