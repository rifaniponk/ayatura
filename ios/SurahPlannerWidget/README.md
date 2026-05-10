# SurahPlannerWidget

WidgetKit reads `widget_payload` from the shared app group
`group.com.ponkcoding.surahplanner` and reloads timelines for the
`SurahPlannerWidget` kind used by `HomeWidget.updateWidget`.

For `ready` payloads, the extension schedules `TimelineReloadPolicy.after` at
the same next boundary Android uses: the next future sunrise or prayer change,
falling back to tomorrow's prayer time when today's time has passed. iOS treats
that as a requested reload time, not an exact alarm. The app still calls
`WidgetCenter` through `home_widget` whenever Flutter syncs fresh payload data.
