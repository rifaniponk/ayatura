package com.ayatura.app.widget

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.view.View
import android.widget.RemoteViews
import com.ayatura.app.R
import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Locale

private val widgetCurrentTitleColor = Color.parseColor("#D4AF37")
private val widgetCurrentTimeColor = Color.parseColor("#61FFFFFF")
private val widgetCurrentRowColor = Color.parseColor("#E6FFFFFF")
private val widgetNextTitleColor = Color.parseColor("#6BFFFFFF")
private val widgetNextTimeColor = Color.parseColor("#42FFFFFF")
private val widgetNextRowColor = Color.parseColor("#80FFFFFF")

private val widgetCurrentRowIds =
    intArrayOf(
        R.id.widget_current_row_1,
        R.id.widget_current_row_2,
        R.id.widget_current_row_3,
        R.id.widget_current_row_4,
    )
private val widgetNextRowIds =
    intArrayOf(
        R.id.widget_next_row_1,
        R.id.widget_next_row_2,
        R.id.widget_next_row_3,
        R.id.widget_next_row_4,
    )

abstract class SurahPlannerWidgetProviderBase : AppWidgetProvider() {
    /** When true, always uses the wide two column layout (4x2 widget entry). */
    protected abstract val preferWideLayout: Boolean

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
            val ids = manager.getAppWidgetIds(ComponentName(context, javaClass))
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
        val layoutId =
            if (preferWideLayout || minWidth >= 250) {
                R.layout.surah_planner_widget_medium
            } else {
                R.layout.surah_planner_widget_small
            }
        val views = RemoteViews(context.packageName, layoutId)
        val payload = readPayload(context)
        val status = payload?.optString("status") ?: "no_plan"
        val widgetStrings = payload?.optJSONObject("strings")

        if (status != "ready" || payload == null) {
            bindEmptyState(context, views, status, widgetStrings)
            setTapOpenApp(context, views)
            manager.updateAppWidget(appWidgetId, views)
            return
        }

        val localeTag = payload.optString("locale", "en")
        val todayIso = LocalDate.now().toString()
        val days = payload.optJSONObject("days")
        if (days == null || !days.has(todayIso)) {
            bindEmptyState(context, views, STATUS_WIDGET_STALE, widgetStrings)
            setTapOpenApp(context, views)
            manager.updateAppWidget(appWidgetId, views)
            return
        }

        if (!bindReadyState(context, views, days, widgetStrings, localeTag)) {
            bindEmptyState(context, views, STATUS_WIDGET_STALE, widgetStrings)
            setTapOpenApp(context, views)
            manager.updateAppWidget(appWidgetId, views)
            return
        }

        setTapOpenApp(context, views)
        manager.updateAppWidget(appWidgetId, views)
        scheduleNextRefresh(context, payload)
    }

    /** @return false if prayer/slot data for today is unusable */
    private fun bindReadyState(
        context: Context,
        views: RemoteViews,
        days: JSONObject,
        widgetStrings: JSONObject?,
        localeTag: String,
    ): Boolean {
        val now = LocalDateTime.now()
        val resolved =
            resolvePrayerSlotsFromDays(days, now, widgetStrings, localeTag) ?: return false
        val current = resolved.current
        val next = resolved.next

        views.setViewVisibility(R.id.widget_ready_container, View.VISIBLE)
        views.setViewVisibility(R.id.widget_empty_container, View.GONE)

        bindSlot(
            views = views,
            isCurrent = true,
            title = current.title,
            trailing = current.time,
            rows = current.rows,
            useMutedPalette = resolved.muteCurrentColumn,
        )
        bindSlot(
            views = views,
            isCurrent = false,
            title = next.title,
            trailing = next.time,
            rows = next.rows,
        )
        return true
    }

    /**
     * Derives current/next from date-keyed [days] at [now]. Expects today and
     * (when needed) tomorrow entries under ISO date keys.
     *
     * When there is no active current prayer (before Fajr, or after sunrise until
     * the next salat), the top slot still shows **Fajr** readings with the muted
     * palette; only the Fajr to sunrise window uses the gold "current" styling.
     */
    private fun resolvePrayerSlotsFromDays(
        days: JSONObject,
        now: LocalDateTime,
        widgetStrings: JSONObject?,
        localeTag: String,
    ): ResolvedWidgetSlots? {
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

        val muteCurrentColumn: Boolean
        val currentSlot: Slot
        if (currentKey == null) {
            muteCurrentColumn = true
            val at = fajrAt
            currentSlot =
                buildLiveSlot(
                    prayerKey = "fajr",
                    at = at,
                    rowsSource = slotsToday,
                    isTomorrow = false,
                    widgetStrings = widgetStrings,
                    localeTag = localeTag,
                )
        } else {
            muteCurrentColumn = false
            val at = parsedToday[currentKey] ?: return null
            currentSlot =
                buildLiveSlot(
                    prayerKey = currentKey,
                    at = at,
                    rowsSource = slotsToday,
                    isTomorrow = false,
                    widgetStrings = widgetStrings,
                    localeTag = localeTag,
                )
        }

        val rowsSourceNext = if (nextIsTomorrow) slotsTomorrow else slotsToday
        val nextSlot =
            buildLiveSlot(
                prayerKey = effectiveNextKey,
                at = nextAt,
                rowsSource = rowsSourceNext,
                isTomorrow = nextIsTomorrow,
                widgetStrings = widgetStrings,
                localeTag = localeTag,
            )

        return ResolvedWidgetSlots(
            current = currentSlot,
            next = nextSlot,
            muteCurrentColumn = muteCurrentColumn,
        )
    }

    private fun buildLiveSlot(
        prayerKey: String,
        at: LocalDateTime,
        rowsSource: JSONObject,
        isTomorrow: Boolean,
        widgetStrings: JSONObject?,
        localeTag: String,
    ): Slot {
        val label = prayerDisplayLabel(widgetStrings, prayerKey)
        val locale = titleCaseLocale(localeTag)
        val titleBase = label.uppercase(locale)
        val tomorrowMarker =
            widgetStrings?.optString("widgetTomorrowMarker")?.trim().orEmpty()
                .ifEmpty { "TOMORROW" }
        val title =
            if (isTomorrow) {
                "$titleBase · $tomorrowMarker"
            } else {
                titleBase
            }
        val timeStr = HH_MM.format(at.toLocalTime())
        val rows = rowsForPrayer(rowsSource, prayerKey)
        return Slot(title = title, time = timeStr, rows = rows)
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

    private fun bindEmptyState(
        context: Context,
        views: RemoteViews,
        status: String,
        widgetStrings: JSONObject?,
    ) {
        views.setViewVisibility(R.id.widget_ready_container, View.GONE)
        views.setViewVisibility(R.id.widget_empty_container, View.VISIBLE)
        when (status) {
            "plan_expired" -> {
                views.setTextViewText(
                    R.id.widget_empty_title,
                    localizedUiString(
                        widgetStrings,
                        "widgetEmptyPlanExpiredTitle",
                        context,
                        R.string.widget_empty_plan_expired_title,
                    ),
                )
                views.setTextViewText(
                    R.id.widget_empty_subtitle,
                    localizedUiString(
                        widgetStrings,
                        "widgetEmptyPlanExpiredSubtitle",
                        context,
                        R.string.widget_empty_plan_expired_subtitle,
                    ),
                )
            }
            STATUS_WIDGET_STALE -> {
                views.setTextViewText(
                    R.id.widget_empty_title,
                    localizedUiString(
                        widgetStrings,
                        "widgetEmptyStaleTitle",
                        context,
                        R.string.widget_empty_stale_title,
                    ),
                )
                views.setTextViewText(
                    R.id.widget_empty_subtitle,
                    localizedUiString(
                        widgetStrings,
                        "widgetEmptyStaleSubtitle",
                        context,
                        R.string.widget_empty_stale_subtitle,
                    ),
                )
            }
            else -> {
                views.setTextViewText(
                    R.id.widget_empty_title,
                    localizedUiString(
                        widgetStrings,
                        "widgetEmptyNoPlanTitle",
                        context,
                        R.string.widget_empty_no_plan_title,
                    ),
                )
                views.setTextViewText(
                    R.id.widget_empty_subtitle,
                    localizedUiString(
                        widgetStrings,
                        "widgetEmptyNoPlanSubtitle",
                        context,
                        R.string.widget_empty_no_plan_subtitle,
                    ),
                )
            }
        }
    }

    private fun localizedUiString(
        strings: JSONObject?,
        key: String,
        context: Context,
        fallbackResId: Int,
    ): String {
        val fromPayload = strings?.optString(key)?.trim().orEmpty()
        return fromPayload.ifEmpty { context.getString(fallbackResId) }
    }

    private fun prayerDisplayLabel(strings: JSONObject?, prayerKey: String): String {
        val labels = strings?.optJSONObject("prayerLabels") ?: return prayerKey.fallbackPrayerLabel()
        val raw = labels.optString(prayerKey).trim()
        return raw.ifEmpty { prayerKey.fallbackPrayerLabel() }
    }

    private fun String.fallbackPrayerLabel(): String =
        replaceFirstChar { ch ->
            if (ch.isLowerCase()) {
                ch.titlecase(Locale.ENGLISH)
            } else {
                ch.toString()
            }
        }

    private fun titleCaseLocale(localeTag: String): Locale {
        val code =
            localeTag.ifBlank { "en" }.substringBefore('-').lowercase(Locale.ENGLISH)
        return when (code) {
            "id" -> Locale.forLanguageTag("id-ID")
            else -> Locale.forLanguageTag("en")
        }
    }

    private fun bindSlot(
        views: RemoteViews,
        isCurrent: Boolean,
        title: String,
        trailing: String,
        rows: List<String>,
        useMutedPalette: Boolean = false,
    ) {
        if (isCurrent) {
            views.setTextViewText(R.id.widget_current_title, title)
            views.setTextViewText(R.id.widget_current_time, trailing)
            bindRows(views, true, rows)
            applyCurrentColumnPalette(views, muted = useMutedPalette)
        } else {
            views.setTextViewText(R.id.widget_next_title, title)
            views.setTextViewText(R.id.widget_next_time, trailing)
            bindRows(views, false, rows)
            applyNextColumnPalette(views)
        }
    }

    private fun applyCurrentColumnPalette(views: RemoteViews, muted: Boolean) {
        if (muted) {
            views.setTextColor(R.id.widget_current_title, widgetNextTitleColor)
            views.setTextColor(R.id.widget_current_time, widgetNextTimeColor)
        } else {
            views.setTextColor(R.id.widget_current_title, widgetCurrentTitleColor)
            views.setTextColor(R.id.widget_current_time, widgetCurrentTimeColor)
        }
        val rowColor = if (muted) widgetNextRowColor else widgetCurrentRowColor
        for (id in widgetCurrentRowIds) {
            views.setTextColor(id, rowColor)
        }
    }

    private fun applyNextColumnPalette(views: RemoteViews) {
        views.setTextColor(R.id.widget_next_title, widgetNextTitleColor)
        views.setTextColor(R.id.widget_next_time, widgetNextTimeColor)
        for (id in widgetNextRowIds) {
            views.setTextColor(id, widgetNextRowColor)
        }
    }

    private fun bindRows(views: RemoteViews, isCurrent: Boolean, rows: List<String>) {
        val ids = if (isCurrent) widgetCurrentRowIds else widgetNextRowIds
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
        const val ACTION_REFRESH = "com.ayatura.app.widget.ACTION_REFRESH"

        /** Internal empty-state bucket for outdated / missing window coverage */
        private const val STATUS_WIDGET_STALE = "widget_stale"

        private val HH_MM: DateTimeFormatter = DateTimeFormatter.ofPattern("HH:mm")
        private val PRAYER_ORDER = listOf("fajr", "dhuhr", "asr", "maghrib", "isha")

        fun requestRefresh(context: Context) {
            for (receiverClass in widgetReceiverClasses) {
                val refreshIntent = Intent(context, receiverClass).apply {
                    action = ACTION_REFRESH
                }
                context.sendBroadcast(refreshIntent)
            }
        }

        private val widgetReceiverClasses: Array<Class<out SurahPlannerWidgetProviderBase>> =
            arrayOf(
                SurahPlannerWidget2x2Receiver::class.java,
                SurahPlannerWidget4x2Receiver::class.java,
            )
    }
}

private data class Slot(
    val title: String,
    val time: String,
    val rows: List<String>,
)

private data class ResolvedWidgetSlots(
    val current: Slot,
    val next: Slot,
    val muteCurrentColumn: Boolean,
)
