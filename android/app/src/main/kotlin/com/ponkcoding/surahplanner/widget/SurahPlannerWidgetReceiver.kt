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
import java.time.format.DateTimeFormatter
import java.util.Locale

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
            bindEmptyState(context, views, status)
            setTapOpenApp(context, views)
            manager.updateAppWidget(appWidgetId, views)
            return
        }

        val todayIso = LocalDate.now().toString()
        val days = payload.optJSONObject("days")
        if (days == null || !days.has(todayIso)) {
            bindEmptyState(context, views, STATUS_WIDGET_STALE)
            setTapOpenApp(context, views)
            manager.updateAppWidget(appWidgetId, views)
            return
        }

        if (!bindReadyState(views, days)) {
            bindEmptyState(context, views, STATUS_WIDGET_STALE)
            setTapOpenApp(context, views)
            manager.updateAppWidget(appWidgetId, views)
            return
        }

        setTapOpenApp(context, views)
        manager.updateAppWidget(appWidgetId, views)
        scheduleNextRefresh(context, payload)
    }

    /** @return false if prayer/slot data for today is unusable */
    private fun bindReadyState(views: RemoteViews, days: JSONObject): Boolean {
        val now = LocalDateTime.now()
        val resolved = resolvePrayerSlotsFromDays(days, now) ?: return false
        val current = resolved.first
        val next = resolved.second

        views.setViewVisibility(R.id.widget_ready_container, View.VISIBLE)
        views.setViewVisibility(R.id.widget_empty_container, View.GONE)

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
            title = next.title,
            trailing = next.countdownText,
            rows = next.rows,
        )
        return true
    }

    /**
     * Derives current/next from date-keyed [days] at [now]. Expects today and
     * (when needed) tomorrow entries under ISO date keys.
     */
    private fun resolvePrayerSlotsFromDays(
        days: JSONObject,
        now: LocalDateTime,
    ): Pair<Slot?, Slot>? {
        val today = now.toLocalDate()
        val todayIso = today.toString()
        val tomorrowIso = today.plusDays(1).toString()

        val dayToday = days.optJSONObject(todayIso) ?: return null
        val prayerTimes = dayToday.optJSONObject("prayerTimes") ?: return null
        val slotsToday = dayToday.optJSONObject("slots") ?: return null
        val dayTomorrow = days.optJSONObject(tomorrowIso)
        val tomorrowPrayerTimes = dayTomorrow?.optJSONObject("prayerTimes")
        val slotsTomorrow = dayTomorrow?.optJSONObject("slots") ?: JSONObject()

        val parsedToday = LinkedHashMap<String, LocalDateTime>()
        for (key in PRAYER_ORDER) {
            val hhmm = prayerTimes.optString(key)
            if (hhmm.isBlank()) return null
            parsedToday[key] = parseTodayTime(today, hhmm)
        }

        val sunriseStr = dayToday.optString("sunrise", "")
        val sunriseAt =
            if (sunriseStr.isNotBlank()) parseTodayTime(today, sunriseStr) else null

        val fajrAt = parsedToday["fajr"] ?: return null

        var currentKey: String? = null
        if (sunriseAt != null && !now.isBefore(fajrAt) && now.isBefore(sunriseAt)) {
            currentKey = "fajr"
        } else {
            for (key in PRAYER_ORDER) {
                val at = parsedToday[key] ?: continue
                if (at.isAfter(now)) break
                if (key == "fajr" && sunriseAt != null) continue
                currentKey = key
            }
        }

        var nextKey: String? = null
        for (key in PRAYER_ORDER) {
            val at = parsedToday[key] ?: continue
            if (at.isAfter(now)) {
                nextKey = key
                break
            }
        }

        val nextIsTomorrow = nextKey == null
        val effectiveNextKey = nextKey ?: "fajr"

        val tomorrow = today.plusDays(1)
        val nextAt =
            if (nextIsTomorrow) {
                val hhmm =
                    tomorrowPrayerTimes?.optString("fajr")?.takeIf { it.isNotBlank() }
                        ?: prayerTimes.optString("fajr")
                if (hhmm.isBlank()) return null
                parseTodayTime(tomorrow, hhmm)
            } else {
                parsedToday[effectiveNextKey] ?: return null
            }

        val currentSlot =
            if (currentKey == null) {
                null
            } else {
                val at = parsedToday[currentKey] ?: return null
                buildLiveSlot(
                    prayerKey = currentKey,
                    at = at,
                    rowsSource = slotsToday,
                    isTomorrow = false,
                    now = now,
                    isCurrent = true,
                )
            }

        val rowsSourceNext = if (nextIsTomorrow) slotsTomorrow else slotsToday
        val nextSlot =
            buildLiveSlot(
                prayerKey = effectiveNextKey,
                at = nextAt,
                rowsSource = rowsSourceNext,
                isTomorrow = nextIsTomorrow,
                now = now,
                isCurrent = false,
            )

        return currentSlot to nextSlot
    }

    private fun buildLiveSlot(
        prayerKey: String,
        at: LocalDateTime,
        rowsSource: JSONObject,
        isTomorrow: Boolean,
        now: LocalDateTime,
        isCurrent: Boolean,
    ): Slot {
        val label = PRAYER_LABELS[prayerKey] ?: prayerKey
        val titleBase = label.uppercase(Locale.US)
        val title = if (isTomorrow) "$titleBase · TOMORROW" else titleBase
        val timeStr = HH_MM.format(at.toLocalTime())
        val rows = rowsForPrayer(rowsSource, prayerKey)
        val countdownText =
            if (isCurrent) {
                timeStr
            } else {
                val mins = java.time.Duration.between(now, at).toMinutes().toInt()
                if (mins > 0) formatCountdown(mins) else timeStr
            }
        return Slot(title = title, time = timeStr, countdownText = countdownText, rows = rows)
    }

    private fun rowsForPrayer(rowsSource: JSONObject, prayerKey: String): List<String> {
        val rows = mutableListOf<String>()
        val source = rowsSource.optJSONArray(prayerKey) ?: JSONArray()
        for (i in 0 until minOf(source.length(), 4)) {
            val row = source.optJSONObject(i) ?: continue
            val index = i + 1
            val name = row.optString("name")
            val ayat = row.optString("ayat")
            val suffix = if (ayat.isBlank()) name else "$name  $ayat"
            rows.add("$index  $suffix")
        }
        return rows
    }

    private fun bindEmptyState(context: Context, views: RemoteViews, status: String) {
        views.setViewVisibility(R.id.widget_ready_container, View.GONE)
        views.setViewVisibility(R.id.widget_empty_container, View.VISIBLE)
        when (status) {
            "plan_expired" -> {
                views.setTextViewText(
                    R.id.widget_empty_title,
                    context.getString(R.string.widget_empty_plan_expired_title),
                )
                views.setTextViewText(
                    R.id.widget_empty_subtitle,
                    context.getString(R.string.widget_empty_plan_expired_subtitle),
                )
            }
            STATUS_WIDGET_STALE -> {
                views.setTextViewText(
                    R.id.widget_empty_title,
                    context.getString(R.string.widget_empty_stale_title),
                )
                views.setTextViewText(
                    R.id.widget_empty_subtitle,
                    context.getString(R.string.widget_empty_stale_subtitle),
                )
            }
            else -> {
                views.setTextViewText(
                    R.id.widget_empty_title,
                    context.getString(R.string.widget_empty_no_plan_title),
                )
                views.setTextViewText(
                    R.id.widget_empty_subtitle,
                    context.getString(R.string.widget_empty_no_plan_subtitle),
                )
            }
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

    private fun scheduleNextRefresh(context: Context, payload: JSONObject) {
        val todayIso = LocalDate.now().toString()
        val days = payload.optJSONObject("days") ?: return
        val todayDay = days.optJSONObject(todayIso) ?: return
        val prayerTimes = todayDay.optJSONObject("prayerTimes") ?: return
        val tomorrowIso = LocalDate.now().plusDays(1).toString()
        val tomorrowDay = days.optJSONObject(tomorrowIso)
        val tomorrowPrayerTimes = tomorrowDay?.optJSONObject("prayerTimes")

        val now = LocalDateTime.now()
        val todayDate = now.toLocalDate()
        val tomorrowDate = todayDate.plusDays(1)
        val candidates = mutableListOf<LocalDateTime>()

        val sunriseStr = todayDay.optString("sunrise", "")
        if (sunriseStr.isNotBlank()) {
            val sunriseAt = parseTodayTime(todayDate, sunriseStr)
            if (sunriseAt.isAfter(now)) {
                candidates.add(sunriseAt)
            }
        }

        for (prayer in PRAYER_ORDER) {
            val hhmm = prayerTimes.optString(prayer)
            if (hhmm.isBlank()) continue
            val todayTime = parseTodayTime(todayDate, hhmm)
            if (todayTime.isAfter(now)) {
                candidates.add(todayTime)
            } else {
                val tm =
                    tomorrowPrayerTimes?.optString(prayer)?.takeIf { it.isNotBlank() }
                        ?: hhmm
                candidates.add(parseTodayTime(tomorrowDate, tm))
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

        /** Internal empty-state bucket for outdated / missing window coverage */
        private const val STATUS_WIDGET_STALE = "widget_stale"

        private val HH_MM: DateTimeFormatter = DateTimeFormatter.ofPattern("HH:mm")
        private val PRAYER_ORDER = listOf("fajr", "dhuhr", "asr", "maghrib", "isha")
        private val PRAYER_LABELS =
            mapOf(
                "fajr" to "Fajr",
                "dhuhr" to "Dhuhr",
                "asr" to "Asr",
                "maghrib" to "Maghrib",
                "isha" to "Isha",
            )

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
