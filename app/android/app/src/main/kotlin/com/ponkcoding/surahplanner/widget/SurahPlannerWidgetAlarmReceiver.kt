package com.ponkcoding.surahplanner.widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class SurahPlannerWidgetAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        SurahPlannerWidgetReceiver.requestRefresh(context)
    }
}
