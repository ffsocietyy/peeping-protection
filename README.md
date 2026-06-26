# Peeping Protection

Android app using CameraX and ML Kit Object Detection for real-time person detection with intelligent alerting.

## Features

- Real-time camera frame processing using CameraX
- ML Kit Object Detection for person detection
- Intelligent alert system:
  - Single person detected for >1 second → local notification
  - 2+ people detected → high priority alert
  - 5-second cooldown between alerts
- State tracking across frames
- Proper lifecycle management

## Requirements

- Android 5.0 (API 21+)
- CameraX dependencies
- ML Kit Object Detection API
- AndroidX libraries

## Architecture

- `MainActivity`: Camera setup and analysis orchestration
- `FrameProcessor`: ML Kit frame analysis logic
- `AlertManager`: Notification handling and cooldown management