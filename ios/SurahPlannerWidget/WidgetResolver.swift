import Foundation

enum WidgetResolver {
    static let appGroupId = "group.com.ponkcoding.surahplanner"
    static let payloadKey = "widget_payload"
    static let prayerOrder = ["fajr", "dhuhr", "asr", "maghrib", "isha"]

    private static let isoFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func loadPayload() -> WidgetPayload? {
        guard let payload = UserDefaults(suiteName: appGroupId)?.string(forKey: payloadKey),
              let data = payload.data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(WidgetPayload.self, from: data)
    }

    static func emptyReason(for payload: WidgetPayload?) -> WidgetEmptyReason? {
        guard let payload else {
            return .noPlan
        }
        switch payload.status {
        case .ready:
            return nil
        case .planExpired:
            return .planExpired
        case .noPlan:
            return .noPlan
        }
    }

    static func resolve(payload: WidgetPayload, now: Date = Date()) -> ResolvedWidgetSlots? {
        guard payload.status == .ready,
              let days = payload.days,
              let resolved = resolvePrayerSlots(days: days, now: now, strings: payload.strings, localeTag: payload.locale ?? "en") else {
            return nil
        }
        return ResolvedWidgetSlots(
            current: resolved.current,
            next: resolved.next,
            muteCurrentColumn: resolved.muteCurrentColumn,
            nextRefreshDate: nextRefreshDate(days: days, now: now)
        )
    }

    static func todayIso(now: Date = Date()) -> String {
        isoFormatter.string(from: Calendar.current.startOfDay(for: now))
    }

    static func emptyText(reason: WidgetEmptyReason, strings: WidgetStrings?) -> (title: String, subtitle: String) {
        switch reason {
        case .planExpired:
            return (
                text(strings?.widgetEmptyPlanExpiredTitle, fallback: "Plan expired"),
                text(strings?.widgetEmptyPlanExpiredSubtitle, fallback: "Open Surah Planner to create this month.")
            )
        case .stale:
            return (
                text(strings?.widgetEmptyStaleTitle, fallback: "Widget needs refresh"),
                text(strings?.widgetEmptyStaleSubtitle, fallback: "Open Surah Planner to sync the latest plan.")
            )
        case .noPlan:
            return (
                text(strings?.widgetEmptyNoPlanTitle, fallback: "No plan yet"),
                text(strings?.widgetEmptyNoPlanSubtitle, fallback: "Open Surah Planner to build your schedule.")
            )
        }
    }

    private static func resolvePrayerSlots(
        days: [String: WidgetDay],
        now: Date,
        strings: WidgetStrings?,
        localeTag: String
    ) -> (current: WidgetSlot, next: WidgetSlot, muteCurrentColumn: Bool)? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        let todayIso = isoFormatter.string(from: today)
        let tomorrowIso = isoFormatter.string(from: tomorrow)

        guard let dayToday = days[todayIso] else {
            return nil
        }
        let dayTomorrow = days[tomorrowIso]
        guard let prayerTimes = dayToday.prayerTimes,
              let slotsToday = dayToday.slots else {
            return nil
        }

        var parsedToday: [String: Date] = [:]
        for key in prayerOrder {
            guard let hhmm = prayerTimes[key]?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !hhmm.isEmpty,
                  let parsed = parse(date: today, hhmm: hhmm) else {
                return nil
            }
            parsedToday[key] = parsed
        }

        let sunriseText = dayToday.sunrise?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let sunriseAt = sunriseText.isEmpty ? nil : parse(date: today, hhmm: sunriseText)
        guard let fajrAt = parsedToday["fajr"] else {
            return nil
        }

        var currentKey: String?
        if let sunriseAt, now >= fajrAt, now < sunriseAt {
            currentKey = "fajr"
        } else {
            for key in prayerOrder {
                guard let at = parsedToday[key] else {
                    continue
                }
                if at > now {
                    break
                }
                if key == "fajr", sunriseAt != nil {
                    continue
                }
                currentKey = key
            }
        }

        let nextKey = prayerOrder.first { key in
            guard let at = parsedToday[key] else {
                return false
            }
            return at > now
        }
        let nextIsTomorrow = nextKey == nil
        let effectiveNextKey = nextKey ?? "fajr"

        let nextAt: Date
        if nextIsTomorrow {
            let hhmm = dayTomorrow?.prayerTimes?["fajr"]?.nilIfBlank ?? prayerTimes["fajr"]?.nilIfBlank
            guard let hhmm, let parsed = parse(date: tomorrow, hhmm: hhmm) else {
                return nil
            }
            nextAt = parsed
        } else {
            guard let at = parsedToday[effectiveNextKey] else {
                return nil
            }
            nextAt = at
        }

        let currentSlot: WidgetSlot
        let muteCurrentColumn: Bool
        if let currentKey {
            guard let at = parsedToday[currentKey] else {
                return nil
            }
            muteCurrentColumn = false
            currentSlot = buildSlot(
                prayerKey: currentKey,
                at: at,
                rowsSource: slotsToday,
                isTomorrow: false,
                strings: strings,
                localeTag: localeTag
            )
        } else {
            muteCurrentColumn = true
            currentSlot = buildSlot(
                prayerKey: "fajr",
                at: fajrAt,
                rowsSource: slotsToday,
                isTomorrow: false,
                strings: strings,
                localeTag: localeTag
            )
        }

        let nextRowsSource = nextIsTomorrow ? (dayTomorrow?.slots ?? [:]) : slotsToday
        let nextSlot = buildSlot(
            prayerKey: effectiveNextKey,
            at: nextAt,
            rowsSource: nextRowsSource,
            isTomorrow: nextIsTomorrow,
            strings: strings,
            localeTag: localeTag
        )
        return (currentSlot, nextSlot, muteCurrentColumn)
    }

    private static func buildSlot(
        prayerKey: String,
        at: Date,
        rowsSource: [String: [WidgetSurah]],
        isTomorrow: Bool,
        strings: WidgetStrings?,
        localeTag: String
    ) -> WidgetSlot {
        let label = strings?.prayerLabels?[prayerKey]?.nilIfBlank ?? fallbackPrayerLabel(prayerKey)
        let locale = titleLocale(localeTag)
        let titleBase = label.uppercased(with: locale)
        let tomorrowMarker = strings?.widgetTomorrowMarker?.nilIfBlank ?? "TOMORROW"
        let title = isTomorrow ? "\(titleBase) · \(tomorrowMarker)" : titleBase
        return WidgetSlot(
            title: title,
            time: hhmmFormatter.string(from: at),
            rows: rowsForPrayer(rowsSource: rowsSource, prayerKey: prayerKey)
        )
    }

    private static func rowsForPrayer(rowsSource: [String: [WidgetSurah]], prayerKey: String) -> [String] {
        Array((rowsSource[prayerKey] ?? []).prefix(4).enumerated()).map { index, surah in
            let ayat = surah.ayat?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let suffix = ayat.isEmpty ? surah.name : "\(surah.name)  \(ayat)"
            return "\(index + 1)  \(suffix)"
        }
    }

    private static func nextRefreshDate(days: [String: WidgetDay], now: Date) -> Date? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        let todayIso = isoFormatter.string(from: today)
        let tomorrowIso = isoFormatter.string(from: tomorrow)
        guard let todayDay = days[todayIso] else {
            return nil
        }
        guard let todayPrayerTimes = todayDay.prayerTimes else {
            return nil
        }
        let tomorrowPrayerTimes = days[tomorrowIso]?.prayerTimes
        var candidates: [Date] = []

        if let sunrise = todayDay.sunrise?.nilIfBlank,
           let sunriseAt = parse(date: today, hhmm: sunrise),
           sunriseAt > now {
            candidates.append(sunriseAt)
        }

        for prayer in prayerOrder {
            guard let hhmm = todayPrayerTimes[prayer]?.nilIfBlank,
                  let todayAt = parse(date: today, hhmm: hhmm) else {
                continue
            }
            if todayAt > now {
                candidates.append(todayAt)
            } else {
                let tomorrowHhmm = tomorrowPrayerTimes?[prayer]?.nilIfBlank ?? hhmm
                if let tomorrowAt = parse(date: tomorrow, hhmm: tomorrowHhmm) {
                    candidates.append(tomorrowAt)
                }
            }
        }
        return candidates.min()
    }

    private static func parse(date: Date, hhmm: String) -> Date? {
        let parts = hhmm.split(separator: ":")
        guard parts.count >= 2,
              let hour = Int(parts[0]),
              let minute = Int(parts[1]) else {
            return nil
        }
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: date)
    }

    private static let hhmmFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private static func titleLocale(_ localeTag: String) -> Locale {
        localeTag.lowercased().hasPrefix("id") ? Locale(identifier: "id_ID") : Locale(identifier: "en")
    }

    private static func fallbackPrayerLabel(_ prayerKey: String) -> String {
        prayerKey.prefix(1).uppercased() + prayerKey.dropFirst()
    }

    private static func text(_ value: String?, fallback: String) -> String {
        value?.nilIfBlank ?? fallback
    }
}

private extension String {
    var nilIfBlank: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
