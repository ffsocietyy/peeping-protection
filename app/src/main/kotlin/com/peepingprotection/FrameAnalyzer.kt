package com.peepingprotection

import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import com.google.mlkit.vision.common.InputImage

class FrameAnalyzer(private val frameProcessor: FrameProcessor) : ImageAnalysis.Analyzer {
    override fun analyze(imageProxy: ImageProxy) {
        try {
            val mediaImage = imageProxy.image ?: run {
                imageProxy.close()
                return
            }

            val inputImage = InputImage.fromMediaImage(
                mediaImage,
                imageProxy.imageInfo.rotationDegrees
            )

            frameProcessor.processFrame(inputImage)
        } finally {
            imageProxy.close()
        }
    }
}
