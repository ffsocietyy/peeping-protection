#!/bin/bash
set -e

echo "Building Peeping Protection APK..."

# Clean build directory
./gradlew clean

# Build debug APK (faster, for testing)
./gradlew assembleDebug

echo "\n✅ Debug APK Build Complete!"
echo "APK Location: app/build/outputs/apk/debug/app-debug.apk"
echo "\nTo install on device:"
echo "adb install -r app/build/outputs/apk/debug/app-debug.apk"
