package com.peepingprotection

import android.content.Context
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.objects.ObjectDetection
import com.google.mlkit.vision.objects.defaults.ObjectDetectorOptions

class FrameProcessor(
    context: Context,
    private val onPersonCountChanged: (Int) -> Unit
) {
    private val objectDetector = ObjectDetection.getClient(
        ObjectDetectorOptions.Builder()
            .setDetectorMode(ObjectDetectorOptions.STREAM_MODE)
            .enableMultipleObjects()
            .enableClassification()
            .build()
    )

    fun processFrame(image: InputImage) {
        objectDetector.process(image)
            .addOnSuccessListener { detectedObjects ->
                val personCount = detectedObjects.count { obj ->
                    obj.labels.any { label ->
                        label.text.lowercase() == "person" && label.confidence > 0.5f
                    }
                }
                onPersonCountChanged(personCount)
            }
            .addOnFailureListener { exception ->
                // Log error silently to avoid spam
            }
    }
}
