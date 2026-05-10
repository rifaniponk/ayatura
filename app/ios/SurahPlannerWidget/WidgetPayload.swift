import Foundation

enum WidgetStatus: String, Codable {
    case ready
    case noPlan = "no_plan"
    case planExpired = "plan_expired"
}

struct WidgetPayload: Codable {
    let generatedAt: String?
    let status: WidgetStatus
    let locale: String?
    let strings: WidgetStrings?
    let days: [String: WidgetDay]?
}

struct WidgetStrings: Codable {
    let widgetEmptyNoPlanTitle: String?
    let widgetEmptyNoPlanSubtitle: String?
    let widgetEmptyPlanExpiredTitle: String?
    let widgetEmptyPlanExpiredSubtitle: String?
    let widgetEmptyStaleTitle: String?
    let widgetEmptyStaleSubtitle: String?
    let widgetTomorrowMarker: String?
    let prayerLabels: [String: String]?
}

struct WidgetDay: Codable {
    let sunrise: String?
    let prayerTimes: [String: String]?
    let slots: [String: [WidgetSurah]]?
}

struct WidgetSurah: Codable {
    let name: String
    let ayat: String?
}

enum WidgetEmptyReason {
    case noPlan
    case planExpired
    case stale
}

struct WidgetSlot {
    let title: String
    let time: String
    let rows: [String]
}

struct ResolvedWidgetSlots {
    let current: WidgetSlot
    let next: WidgetSlot
    let muteCurrentColumn: Bool
    let nextRefreshDate: Date?
}
