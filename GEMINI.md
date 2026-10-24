# TV Detox — Project Rules

This project makes old, slow Android TVs fast again by removing bloatware, ads
and sponsored rows, installing a tiny ad-free home screen, and optimising system
settings — all via ADB over Wi-Fi.

## Repository layout

| Path | Purpose |
|---|---|
| `install.sh` | Installs the home screen APK and configures the TV |
| `undo.sh` | Reverts changes: re-enables stock launcher, removes custom home screen |
| `candidates.sh` | Reads the TV and prints every app with a verdict (never / keep / safe / review) |
| `check.sh` | Verifies the home screen is still active; `--fix` repairs it |
| `build.sh` | Builds the home screen APK from source (requires Java 17 + Android SDK) |
| `apps.txt` | Default app package names shown on the home screen |
| `src/` | Home screen Java source (plain Java, no Gradle, no libraries) |
| `ci/smoke-test.sh` | Automated smoke tests for emulators and real TVs |
| `AndroidManifest.xml` | Android manifest for the home screen APK |
| `docs/debloat.md` | Rules behind the debloat verdicts and safe/never-touch lists |

## Key constraints

- **Never uninstall** system apps — only disable them with `pm disable-user --user 0`.
- **Never disable** critical packages: Google Play services (`com.google.android.gms`),
  Google Play Store, Settings, System UI, keyboard, Bluetooth, HDMI/tuner
  framework, or setup apps.
- On **Google TV / Chromecast**, never disable the Google TV home screen
  (`com.google.android.apps.tv.launcherx`) unless the user explicitly opts in
  with `GOOGLE_TV=1`.
- On **OLED TVs**, always keep the screensaver enabled to prevent burn-in.
- **Always ask the user before every change.** Keep a list of what was changed
  and how to undo it.
- After all changes, **restart the TV once** and verify it starts normally.
- Remind the user to **turn off USB/Network/Wireless debugging** when done.

## Shell scripts

All shell scripts use POSIX `sh` (not bash). When modifying scripts:
- Use `#!/bin/sh` shebang.
- Quote all variables: `"$var"` not `$var`.
- Test on both GNU and BSD (macOS) coreutils.

## Home screen app

- Plain Java, no libraries, no Gradle.
- One screen, minimal RAM (~30 MB).
- The only animation is the focus lift.
- Background is drawn once — keep GPU/memory cost trivial.
- Supports 16 languages — translations live in `src/com/ansub/tvhome/Strings.java`.
