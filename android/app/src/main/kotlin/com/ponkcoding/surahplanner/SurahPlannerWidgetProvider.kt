package com.ponkcoding.surahplanner

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject

class SurahPlannerWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { appWidgetId ->
            updateSingleWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        val manager = AppWidgetManager.getInstance(context)
        val ids = manager.getAppWidgetIds(
            ComponentName(context, SurahPlannerWidgetProvider::class.java)
        )
        if (ids.isNotEmpty()) {
            onUpdate(context, manager, ids)
        }
    }

    private fun updateSingleWidget(
        context: Context,
        manager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val views = RemoteViews(context.packageName, R.layout.widget_surah_planner)
        val payloadString = HomeWidgetPlugin.getData(context).getString("widget_payload", null)
        val payload = payloadString?.let {
            runCatching { JSONObject(it) }.getOrNull()
        }

        bindPayload(views, payload)
        bindTapIntent(context, views)
        manager.updateAppWidget(appWidgetId, views)
    }

    private fun bindPayload(views: RemoteViews, payload: JSONObject?) {
        val state = payload?.optString("state") ?: "no_plan"
        if (state != "ready") {
            views.setViewVisibility(R.id.content_container, View.GONE)
            views.setViewVisibility(R.id.empty_container, View.VISIBLE)
            val title = if (state == "expired") {
                "Plan expired"
            } else {
                "No plan generated yet"
            }
            val subtitle = if (state == "expired") {
                "Open app to regenerate"
            } else {
                "Open the app to get started"
            }
            views.setTextViewText(R.id.tv_empty_title, title)
            views.setTextViewText(R.id.tv_empty_subtitle, subtitle)
            return
        }

        views.setViewVisibility(R.id.content_container, View.VISIBLE)
        views.setViewVisibility(R.id.empty_container, View.GONE)

        val current = payload?.optJSONObject("current")
        val next = payload?.optJSONObject("next")

        bindPrayerHeader(
            views = views,
            prayerObj = current,
            prayerViewId = R.id.tv_current_prayer,
            timeViewId = R.id.tv_current_time,
            isNext = false,
        )
        bindPrayerHeader(
            views = views,
            prayerObj = next,
            prayerViewId = R.id.tv_next_prayer,
            timeViewId = R.id.tv_next_time,
            isNext = true,
        )

        val currentRows = current?.optJSONArray("surahs") ?: JSONArray()
        val nextRows = next?.optJSONArray("surahs") ?: JSONArray()
        bindRows(
            views,
            currentRows,
            intArrayOf(R.id.tv_current_row_1, R.id.tv_current_row_2, R.id.tv_current_row_3, R.id.tv_current_row_4)
        )
        bindRows(
            views,
            nextRows,
            intArrayOf(R.id.tv_next_row_1, R.id.tv_next_row_2, R.id.tv_next_row_3, R.id.tv_next_row_4)
        )
    }

    private fun bindPrayerHeader(
        views: RemoteViews,
        prayerObj: JSONObject?,
        prayerViewId: Int,
        timeViewId: Int,
        isNext: Boolean,
    ) {
        if (prayerObj == null) {
            if (isNext) {
                views.setTextViewText(prayerViewId, "FAJR")
            } else {
                views.setTextViewText(prayerViewId, "BEFORE FAJR")
            }
            views.setTextViewText(timeViewId, "")
            return
        }
        val prayer = prayerObj.optString("prayer", "").uppercase()
        val isTomorrow = prayerObj.optBoolean("isTomorrow", false)
        val prayerLabel = if (isTomorrow) "$prayer · TOMORROW" else prayer
        views.setTextViewText(prayerViewId, prayerLabel)

        val countdownMinutes = prayerObj.optInt("countdownMinutes", -1)
        val time = prayerObj.optString("time", "")
        if (isNext && countdownMinutes >= 0) {
            views.setTextViewText(timeViewId, formatCountdown(countdownMinutes))
        } else {
            views.setTextViewText(timeViewId, time)
        }
    }

    private fun bindRows(
        views: RemoteViews,
        list: JSONArray,
        targetIds: IntArray
    ) {
        targetIds.forEachIndexed { index, viewId ->
            if (index >= list.length()) {
                views.setViewVisibility(viewId, View.GONE)
                return@forEachIndexed
            }
            val row = list.optJSONObject(index)
            val name = row?.optString("name").orEmpty()
            val ayat = row?.optString("ayat").orEmpty()
            views.setTextViewText(viewId, "${index + 1}  $name   $ayat")
            views.setViewVisibility(viewId, View.VISIBLE)
        }
    }

    private fun formatCountdown(totalMinutes: Int): String {
        val hours = totalMinutes / 60
        val minutes = totalMinutes % 60
        return when {
            hours > 0 && minutes > 0 -> "in ${hours}h${minutes}m"
            hours > 0 -> "in ${hours}h"
            else -> "in ${minutes}m"
        }
    }

    private fun bindTapIntent(context: Context, views: RemoteViews) {
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val pendingIntent = PendingIntent.getActivity(
            context,
            1901,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
    }
}
