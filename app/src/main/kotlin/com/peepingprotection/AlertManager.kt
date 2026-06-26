package com.peepingprotection

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.RingtoneManager
import android.os.Build
import androidx.core.app.NotificationCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class AlertManager(private val context: Context) {
    private val notificationManager =
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    private var lastAlertTime = 0L
    private var lastPersonCount = -1
    private var singlePersonTimer: Job? = null
    private val scope = CoroutineScope(Dispatchers.Main + Job())

    companion object {
        private const val CHANNEL_ID = "person_detection_alerts"
        private const val ALERT_COOLDOWN_MS = 5000L
        private const val SINGLE_PERSON_THRESHOLD_MS = 1000L
        private const val NOTIFICATION_ID_SINGLE = 1
        private const val NOTIFICATION_ID_MULTIPLE = 2
    }

    init {
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                context.getString(R.string.channel_name),
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = context.getString(R.string.channel_description)
                enableVibration(true)
                setSound(
                    RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION),
                    android.media.AudioAttributes.Builder()
                        .setUsage(android.media.AudioAttributes.USAGE_NOTIFICATION)
                        .build()
                )
            }
            notificationManager.createNotificationChannel(channel)
        }
    }

    fun checkAndTriggerAlert(personCount: Int) {
        val currentTime = System.currentTimeMillis()

        // Reset timer if person count changes
        if (personCount != lastPersonCount) {
            singlePersonTimer?.cancel()
            singlePersonTimer = null
            lastPersonCount = personCount
        }

        when {
            personCount >= 2 -> {
                // Immediate high priority alert for 2+ people
                if (currentTime - lastAlertTime >= ALERT_COOLDOWN_MS) {
                    sendMultiplePeopleAlert()
                    lastAlertTime = currentTime
                }
                singlePersonTimer?.cancel()
                singlePersonTimer = null
            }

            personCount == 1 -> {
                // Start timer for single person
                if (singlePersonTimer == null) {
                    singlePersonTimer = scope.launch {
                        delay(SINGLE_PERSON_THRESHOLD_MS)
                        if (currentTime - lastAlertTime >= ALERT_COOLDOWN_MS) {
                            sendSinglePersonNotification()
                            lastAlertTime = System.currentTimeMillis()
                        }
                    }
                }
            }

            personCount == 0 -> {
                // No people detected, cancel timer
                singlePersonTimer?.cancel()
                singlePersonTimer = null
            }
        }
    }

    private fun sendSinglePersonNotification() {
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle(context.getString(R.string.notification_title))
            .setContentText(context.getString(R.string.single_person_detected))
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setAutoCancel(true)
            .build()

        notificationManager.notify(NOTIFICATION_ID_SINGLE, notification)
    }

    private fun sendMultiplePeopleAlert() {
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setContentTitle(context.getString(R.string.notification_title))
            .setContentText(context.getString(R.string.multiple_people_alert))
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setAutoCancel(true)
            .setVibrate(longArrayOf(0, 500, 250, 500))
            .build()

        notificationManager.notify(NOTIFICATION_ID_MULTIPLE, notification)
    }
}
