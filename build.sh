#!/bin/bash
set -e

echo "Building Peeping Protection APK..."

# Clean build directory
./gradlew clean

# Build release APK
./gradlew assembleRelease

echo "\n✅ Build Complete!"
echo "APK Location: app/build/outputs/apk/release/app-release.apk"
echo "\nTo install on device:"
echo "adb install -r app/build/outputs/apk/release/app-release.apk"
