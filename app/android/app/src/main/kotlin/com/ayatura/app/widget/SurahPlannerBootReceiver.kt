package com.ayatura.app.widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class SurahPlannerBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action == Intent.ACTION_BOOT_COMPLETED) {
            SurahPlannerWidgetReceiver.requestRefresh(context)
        }
    }
}
