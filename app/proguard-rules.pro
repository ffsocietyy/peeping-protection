# ML Kit rules
-keep class com.google.mlkit.vision.objects.** { *; }
-keep interface com.google.mlkit.vision.objects.** { *; }

# CameraX rules
-keep class androidx.camera.** { *; }
-keep interface androidx.camera.** { *; }

# Keep generic signature of Call, Response (R8 issue)
-keepattributes Signature
-keepattributes *Annotation*
