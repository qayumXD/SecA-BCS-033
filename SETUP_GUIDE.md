# Flutter Development Environment Setup Guide

This codespace has been fully configured for Flutter development. All necessary tools and dependencies have been installed to compile, test, and build APKs for multiple Flutter applications.

## ✅ Installation Summary

### Installed Components:

1. **Flutter SDK 3.41.7** (Stable Channel)
   - Location: `/opt/flutter`
   - Dart 3.11.5 included

2. **Java/OpenJDK 21**
   - Required for Android build tools
   - Automatically detected by Flutter

3. **Android SDK 34.0.0+**
   - Location: `/opt/android/sdk`
   - Includes:
     - Platform Tools v37.0.0
     - Android SDK Platforms (33, 34, 36)
     - Build Tools (28.0.3, 30.0.0, 31.0.0, 32.0.0, 33.0.0, 34.0.0)

4. **Additional Development Tools:**
   - Chromium Browser (Web development support)
   - Ninja Build System (Linux desktop development)
   - GTK 3 Libraries (Linux desktop development)
   - Mesa Utilities (GPU debugging)

## Environment Variables

The following variables have been permanently added to `~/.bashrc`:

```bash
export PATH="/opt/flutter/bin:$PATH"
export ANDROID_HOME="/opt/android/sdk"
export ANDROID_SDK_ROOT="/opt/android/sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"
```

To activate these variables in the current session:
```bash
source ~/.bashrc
```

## Flutter Doctor Status

Run `flutter doctor` to verify the environment:

```bash
$ flutter doctor

Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.41.7, on Ubuntu 24.04.4 LTS)
[✓] Android toolchain - develop for Android devices
[✓] Chrome - develop for the web
[✓] Linux toolchain - develop for Linux desktop
[✓] Connected device (2 available)
[✓] Network resources

• No issues found!
```

## Setting Up Individual Projects

For each Flutter application in this workspace:

### 1. Get Dependencies
```bash
cd <project-directory>
flutter pub get
```

### 2. Run Tests
```bash
flutter test
```

### 3. Build Debug APK
```bash
flutter build apk --debug
```

Output location: `build/app/outputs/flutter-apk/app-debug.apk`

### 4. Build Release APK
```bash
flutter build apk --release
```

Output location: `build/app/outputs/flutter-apk/app-release.apk`

### 5. Build for Web
```bash
flutter build web
```

### 6. Build for Linux Desktop
```bash
flutter build linux
```

## Flutter Projects in Workspace

The following Flutter applications are available:

1. **Assignment2** - Profile Card Application
2. **dice_roll_game** - Dice Roll Game
3. **Lab Assignment 1** - Full Flutter Application
4. **lab01/myapp** - Sample Flutter App
5. **magic_8_ball** - Magic 8 Ball Game
6. **mid-term** - Task Manager Application
7. **simple_api_app** - API Integration Application

## Useful Commands

### Check for dependency updates
```bash
flutter pub outdated
```

### Update dependencies
```bash
flutter pub upgrade
```

### Clean project
```bash
flutter clean
```

### Run on connected device/emulator
```bash
flutter run
```

### Run with verbose logging
```bash
flutter run -v
```

### Install on connected Android device
```bash
flutter install
```

### Analyze code for issues
```bash
flutter analyze
```

## APK Information

- **Debug APKs**: Faster to build, larger in size, suitable for testing
- **Release APKs**: Optimized size and performance, suitable for distribution
- **APK Output**: Located in `build/app/outputs/flutter-apk/` after build completes

## Troubleshooting

### If Flutter commands fail:
```bash
# Source environment variables
source ~/.bashrc

# Verify installation
flutter doctor -v
```

### If Android SDK commands fail:
```bash
# Verify Android SDK setup
export ANDROID_HOME="/opt/android/sdk"
ls $ANDROID_HOME/platforms  # Should show installed platforms
```

### If Java is not found:
```bash
# Verify Java installation
java -version
which javac
```

## Additional Resources

- [Flutter Documentation](https://flutter.dev)
- [Android Development with Flutter](https://flutter.dev/to/linux-android-setup)
- [Flutter Build Configuration](https://flutter.dev/docs/deployment)

---

**Setup completed on**: April 27, 2026
**Environment**: Ubuntu 24.04.4 LTS (Codespace)
