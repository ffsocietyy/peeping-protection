# Peeping Protection - Build Instructions

## Prerequisites

- Android SDK (API 34)
- Android NDK (for some ML Kit models)
- Java 11 or later
- Gradle 8.0+

## Build APK

### Release Build (Optimized)
```bash
./gradlew assembleRelease
```

Output: `app/build/outputs/apk/release/app-release.apk`

### Debug Build (Faster for Testing)
```bash
./gradlew assembleDebug
```

Output: `app/build/outputs/apk/debug/app-debug.apk`

## Install on Device

```bash
adb install -r app/build/outputs/apk/release/app-release.apk
```

## Permissions Required

- **CAMERA** - Access back camera for real-time detection
- **POST_NOTIFICATIONS** - Send security alerts (Android 13+)

## Runtime Requirements

- Android 5.0 (API 21) or later
- Camera device
- ML Kit Object Detection model (auto-downloaded on first run)

## Testing

1. Grant camera and notification permissions
2. Point camera at people
3. Single person visible for >1 second → notification appears
4. 2+ people visible → high priority alert with vibration
5. Alerts have 5-second cooldown between triggers

## APK Size

- Debug: ~50-60 MB (includes symbols)
- Release: ~30-35 MB (optimized, ML Kit models excluded - download on first use)

## Troubleshooting

**App crashes on startup:**
- Ensure camera permission is granted
- Check Android API level (minimum 21)

**No detections showing:**
- ML Kit model downloading on first run (wait 1-2 minutes)
- Ensure good lighting
- Face camera toward people

**Notifications not appearing:**
- Grant POST_NOTIFICATIONS permission
- Check device notification settings
