# Flutter Development Environment - Installation Summary

**Date:** April 27, 2026  
**System:** Ubuntu 24.04.4 LTS (Linux Codespace)  
**Status:** ✅ **COMPLETE - All systems ready for development**

## Overview

This codespace has been fully configured as a complete Flutter development environment capable of:
- ✅ Running Flutter applications
- ✅ Compiling for Android (APK generation)
- ✅ Compiling for web platforms
- ✅ Compiling for Linux desktop
- ✅ Unit and widget testing
- ✅ Performance profiling and debugging

---

## Installed Components

### Core Development Tools

| Component | Version | Location | Status |
|-----------|---------|----------|--------|
| **Flutter SDK** | 3.41.7 (stable) | `/opt/flutter` | ✅ |
| **Dart SDK** | 3.11.5 | (bundled with Flutter) | ✅ |
| **Java/OpenJDK** | 21.0.10 | `/usr/lib/jvm/java-21-openjdk-amd64` | ✅ |
| **Android SDK** | 34.0.0+ | `/opt/android/sdk` | ✅ |

### Android SDK Components

| Component | Version | Status |
|-----------|---------|--------|
| Platform Tools | 37.0.0 | ✅ |
| Android SDK Platforms | 33, 34, 36 | ✅ |
| Build Tools | 28.0.3, 30.0.0, 31.0.0, 32.0.0, 33.0.0, 34.0.0 | ✅ |
| Command Line Tools | Latest | ✅ |

### Development & Build Tools

| Tool | Purpose | Status |
|------|---------|--------|
| Git | Version control | ✅ |
| wget/curl | Download utilities | ✅ |
| ninja-build | Build system (Linux desktop) | ✅ |
| GTK 3 Dev Libraries | GUI development (Linux) | ✅ |
| Mesa Utilities | GPU debugging | ✅ |
| Chromium Browser | Web platform support | ✅ |

---

## Environment Configuration

### Persistent Environment Variables

Added to `~/.bashrc`:

```bash
export PATH="/opt/flutter/bin:$PATH"
export ANDROID_HOME="/opt/android/sdk"
export ANDROID_SDK_ROOT="/opt/android/sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"
```

**Activation:** `source ~/.bashrc`

---

## Quick Start Guide

### 1. Set up environment for current session
```bash
source ~/.bashrc
# OR
bash setup_flutter_env.sh
```

### 2. Build a single project
```bash
cd <project-directory>
flutter pub get          # Get dependencies
flutter build apk --debug  # Build debug APK
flutter build apk --release  # Build release APK
```

### 3. Build all projects
```bash
./build_all_apps.sh debug    # Build all debug APKs
./build_all_apps.sh release  # Build all release APKs
```

### 4. Run tests
```bash
cd <project-directory>
flutter test
```

---

## Flutter Projects in Workspace

Discovered projects ready for development:

1. **Assignment2/**
   - Type: Profile Card Application
   - Status: Ready to build
   - Output: `build/app/outputs/flutter-apk/app-*.apk`

2. **dice_roll_game/**
   - Type: Game Application
   - Status: Ready to build

3. **Lab Assignment 1/**
   - Type: Full Flutter Application
   - Status: Ready to build

4. **lab01/myapp/**
   - Type: Sample Flutter App
   - Status: Ready to build

5. **magic_8_ball/**
   - Type: Game Application
   - Status: Ready to build

6. **mid-term/**
   - Type: Task Manager Application
   - Dependencies: sqflite, provider, pdf, notifications
   - Status: Ready to build

7. **simple_api_app/**
   - Type: API Integration Application
   - Status: Ready to build

---

## Available Helper Scripts

### setup_flutter_env.sh
Sets up environment variables and verifies all installations.
```bash
bash setup_flutter_env.sh
```
**Output:** Displays Flutter doctor status and confirms all tools are working.

### build_all_apps.sh
Batch builds all Flutter projects in the workspace.
```bash
./build_all_apps.sh debug      # Build all debug APKs
./build_all_apps.sh release    # Build all release APKs
```
**Output:** APKs in each project's `build/app/outputs/flutter-apk/` directory

---

## Common Tasks

### Verify Environment
```bash
flutter doctor
flutter doctor -v  # More details
```

### Get Project Dependencies
```bash
cd <project>
flutter pub get
```

### Run Tests
```bash
flutter test
flutter test -v  # Verbose output
```

### Build & Deploy

**Debug APK (faster, larger):**
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

**Release APK (optimized):**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Split APKs by architecture:**
```bash
flutter build apk --split-per-abi
# Output: separate APKs for arm64-v8a, armeabi-v7a, x86_64, x86
```

### Run on Connected Device/Emulator
```bash
flutter run              # Debug mode with hot reload
flutter run -v          # Verbose output
flutter run --release   # Release build on device
```

### Clean Build
```bash
flutter clean            # Remove build artifacts
flutter pub get          # Re-fetch dependencies
```

---

## Development Features Available

- ✅ **Hot Reload:** Fast development cycle (Ctrl+R in terminal)
- ✅ **Hot Restart:** Full app restart (Ctrl+Shift+R)
- ✅ **Widget Testing:** Full test suite framework
- ✅ **DevTools:** Flutter performance profiler and debugger
- ✅ **Dart Analysis:** Built-in code quality analysis
- ✅ **Multi-platform:** Build for Android, Web, Linux desktop

---

## System Information

- **OS:** Ubuntu 24.04.4 LTS (24.04 - Noble Numbat)
- **Kernel:** Linux 6.8.0-1044-azure
- **Architecture:** x86_64
- **Container:** Codespace

### System Resources
```bash
# View available resources
free -h              # Memory
df -h               # Disk space
nproc              # CPU cores
```

---

## Troubleshooting

### Flutter not found
```bash
echo $PATH
# Should include /opt/flutter/bin
source ~/.bashrc
```

### Android SDK not found
```bash
echo $ANDROID_HOME
# Should be /opt/android/sdk
# If not set: export ANDROID_HOME="/opt/android/sdk"
```

### APK build fails
```bash
flutter clean
flutter pub get
flutter build apk --debug -v  # Verbose for details
```

### No devices found
```bash
flutter devices              # List available devices
adb devices                  # ADB devices (Android)
# For emulator: start Android Studio or use `emulator -list-avds`
```

---

## Documentation & Resources

- [Flutter Official Docs](https://flutter.dev)
- [Flutter for Android Setup](https://flutter.dev/to/linux-android-setup)
- [APK Building Guide](https://flutter.dev/docs/deployment/android)
- [Dart Language](https://dart.dev)
- [Android Studio](https://developer.android.com/studio)

---

## What's Next

1. **Navigate to a project:**
   ```bash
   cd Assignment2
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run tests:**
   ```bash
   flutter test
   ```

4. **Build APK:**
   ```bash
   flutter build apk --debug
   ```

---

## Support & Maintenance

### Update Flutter
```bash
cd /opt/flutter
git pull
./bin/flutter doctor
```

### Update Android SDK
```bash
export ANDROID_HOME="/opt/android/sdk"
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --list
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "packages;to;install"
```

### Verify Current State
```bash
flutter doctor -v
```

---

**Setup Status:** ✅ Complete and Verified  
**Flutter Doctor:** No issues found  
**Ready to:** Develop, Test, Build, and Deploy Flutter applications
