package com.ponkcoding.surahplanner.widget

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import com.ponkcoding.surahplanner.R
import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.ZoneId

class SurahPlannerWidgetReceiver : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            updateOne(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_REFRESH) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, SurahPlannerWidgetReceiver::class.java),
            )
            onUpdate(context, manager, ids)
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        requestRefresh(context)
    }

    private fun updateOne(context: Context, manager: AppWidgetManager, appWidgetId: Int) {
        val options = manager.getAppWidgetOptions(appWidgetId)
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
        val layoutId = if (minWidth >= 250) {
            R.layout.surah_planner_widget_medium
        } else {
            R.layout.surah_planner_widget_small
        }
        val views = RemoteViews(context.packageName, layoutId)
        val payload = readPayload(context)
        val status = payload?.optString("status") ?: "no_plan"
        if (status != "ready" || payload == null) {
            bindEmptyState(views, status)
            manager.updateAppWidget(appWidgetId, views)
            return
        }

        bindReadyState(views, payload)
        setTapOpenApp(context, views)
        manager.updateAppWidget(appWidgetId, views)
        scheduleNextRefresh(context, payload)
    }

    private fun bindReadyState(views: RemoteViews, payload: JSONObject) {
        views.setViewVisibility(R.id.widget_ready_container, View.VISIBLE)
        views.setViewVisibility(R.id.widget_empty_container, View.GONE)
        val current = payload.optJSONObject("current")?.let { parseSlotFromPayload(it) }
        val next = payload.optJSONObject("next")?.let { parseSlotFromPayload(it) }
        bindSlot(
            views = views,
            isCurrent = true,
            title = current?.title ?: "BEFORE FAJR",
            trailing = current?.time ?: "",
            rows = current?.rows ?: emptyList(),
        )
        bindSlot(
            views = views,
            isCurrent = false,
            title = next?.title ?: "",
            trailing = next?.countdownText ?: "",
            rows = next?.rows ?: emptyList(),
        )
    }

    private fun bindEmptyState(views: RemoteViews, status: String) {
        views.setViewVisibility(R.id.widget_ready_container, View.GONE)
        views.setViewVisibility(R.id.widget_empty_container, View.VISIBLE)
        if (status == "plan_expired") {
            views.setTextViewText(R.id.widget_empty_title, "Plan expired")
            views.setTextViewText(R.id.widget_empty_subtitle, "Open app to regenerate")
        } else {
            views.setTextViewText(R.id.widget_empty_title, "No plan generated yet")
            views.setTextViewText(R.id.widget_empty_subtitle, "Open the app to get started")
        }
    }

    private fun bindSlot(
        views: RemoteViews,
        isCurrent: Boolean,
        title: String,
        trailing: String,
        rows: List<String>,
    ) {
        if (isCurrent) {
            views.setTextViewText(R.id.widget_current_title, title)
            views.setTextViewText(R.id.widget_current_time, trailing)
            bindRows(views, true, rows)
        } else {
            views.setTextViewText(R.id.widget_next_title, title)
            views.setTextViewText(R.id.widget_next_time, trailing)
            bindRows(views, false, rows)
        }
    }

    private fun bindRows(views: RemoteViews, isCurrent: Boolean, rows: List<String>) {
        val ids = if (isCurrent) {
            intArrayOf(
                R.id.widget_current_row_1,
                R.id.widget_current_row_2,
                R.id.widget_current_row_3,
                R.id.widget_current_row_4,
            )
        } else {
            intArrayOf(
                R.id.widget_next_row_1,
                R.id.widget_next_row_2,
                R.id.widget_next_row_3,
                R.id.widget_next_row_4,
            )
        }
        for (i in ids.indices) {
            val text = rows.getOrNull(i) ?: ""
            views.setTextViewText(ids[i], text)
            views.setViewVisibility(ids[i], if (text.isBlank()) View.GONE else View.VISIBLE)
        }
    }

    private fun setTapOpenApp(context: Context, views: RemoteViews) {
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pendingIntent = PendingIntent.getActivity(
            context,
            1001,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
    }

    private fun parseSlotFromPayload(slot: JSONObject): Slot {
        val prayer = slot.optString("label").ifBlank { slot.optString("prayer") }
        val isTomorrow = slot.optBoolean("isTomorrow", false)
        val titleBase = prayer.uppercase()
        val title = if (isTomorrow) "$titleBase · TOMORROW" else titleBase
        val time = slot.optString("time")
        val countdownMinutes = slot.optInt("countdownMinutes", -1)
        val countdownText = if (countdownMinutes >= 0) {
            formatCountdown(countdownMinutes)
        } else {
            time
        }
        val rows = mutableListOf<String>()
        val source = slot.optJSONArray("surahs") ?: JSONArray()
        for (i in 0 until minOf(source.length(), 4)) {
            val row = source.optJSONObject(i) ?: continue
            val index = i + 1
            val name = row.optString("name")
            val ayat = row.optString("ayat")
            val suffix = if (ayat.isBlank()) name else "$name  $ayat"
            rows.add("$index  $suffix")
        }
        return Slot(
            title = title,
            time = time,
            countdownText = countdownText,
            rows = rows,
        )
    }

    private fun scheduleNextRefresh(context: Context, payload: JSONObject) {
        val prayerTimes = payload.optJSONObject("prayerTimes") ?: return
        val now = LocalDateTime.now()
        val candidates = mutableListOf<LocalDateTime>()
        for (prayer in PRAYER_ORDER) {
            val hhmm = prayerTimes.optString(prayer)
            if (hhmm.isBlank()) continue
            val todayTime = parseTodayTime(now.toLocalDate(), hhmm)
            if (todayTime.isAfter(now)) {
                candidates.add(todayTime)
            } else {
                candidates.add(todayTime.plusDays(1))
            }
        }
        val next = candidates.minOrNull() ?: return
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, SurahPlannerWidgetAlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            2001,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val triggerMillis = next.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
            !alarmManager.canScheduleExactAlarms()
        ) {
            alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerMillis, pendingIntent)
            return
        }
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            triggerMillis,
            pendingIntent,
        )
    }

    private fun readPayload(context: Context): JSONObject? {
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val payload = prefs.getString("widget_payload", null) ?: return null
        return runCatching { JSONObject(payload) }.getOrNull()
    }

    private fun parseTodayTime(date: LocalDate, hhmm: String): LocalDateTime {
        val parts = hhmm.split(":")
        val hour = parts.getOrNull(0)?.toIntOrNull() ?: 0
        val minute = parts.getOrNull(1)?.toIntOrNull() ?: 0
        return date.atTime(LocalTime.of(hour, minute))
    }

    companion object {
        const val ACTION_REFRESH = "com.ponkcoding.surahplanner.widget.ACTION_REFRESH"
        private val PRAYER_ORDER = listOf("fajr", "dhuhr", "asr", "maghrib", "isha")

        fun requestRefresh(context: Context) {
            val intent = Intent(context, SurahPlannerWidgetReceiver::class.java).apply {
                action = ACTION_REFRESH
            }
            context.sendBroadcast(intent)
        }

        private fun formatCountdown(totalMinutes: Int): String {
            val hours = totalMinutes / 60
            val minutes = totalMinutes % 60
            return if (hours > 0) "in ${hours}h${minutes}m" else "in ${minutes}m"
        }
    }
}

data class Slot(
    val title: String,
    val time: String,
    val countdownText: String,
    val rows: List<String>,
)
