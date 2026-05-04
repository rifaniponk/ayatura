import SwiftUI
import WidgetKit

private let appGroupId = "group.com.ponkcoding.surahplanner"
private let payloadKey = "widget_payload"

struct SurahPlannerEntry: TimelineEntry {
  let date: Date
  let payload: WidgetPayload
}

struct SurahPlannerProvider: TimelineProvider {
  func placeholder(in context: Context) -> SurahPlannerEntry {
    SurahPlannerEntry(date: Date(), payload: .placeholder)
  }

  func getSnapshot(in context: Context, completion: @escaping (SurahPlannerEntry) -> Void) {
    completion(SurahPlannerEntry(date: Date(), payload: readPayload()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<SurahPlannerEntry>) -> Void) {
    let entry = SurahPlannerEntry(date: Date(), payload: readPayload())
    let nextRefresh =
      Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
    completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
  }

  private func readPayload() -> WidgetPayload {
    let defaults = UserDefaults(suiteName: appGroupId) ?? .standard
    guard
      let json = defaults.string(forKey: payloadKey),
      let data = json.data(using: .utf8),
      let payload = try? JSONDecoder().decode(WidgetPayload.self, from: data)
    else {
      return .empty
    }
    return payload
  }
}

struct SurahPlannerWidgetEntryView: View {
  var entry: SurahPlannerProvider.Entry

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(hex: "0F3D2E"), Color(hex: "1F7A6B")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      if entry.payload.state != "ready" {
        VStack(spacing: 6) {
          Text(entry.payload.state == "expired" ? "Plan expired" : "No plan generated yet")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white.opacity(0.86))
          Text(
            entry.payload.state == "expired"
              ? "Open app to regenerate" : "Open the app to get started"
          )
          .font(.system(size: 11, weight: .regular))
          .foregroundColor(.white.opacity(0.58))
        }
        .padding(12)
      } else {
        VStack(alignment: .leading, spacing: 6) {
          Text("Surah Planner")
            .font(.system(size: 9, weight: .medium))
            .foregroundColor(.white.opacity(0.48))
          if let current = entry.payload.current {
            PrayerBlockView(block: current, isCurrent: true)
          } else {
            Text("BEFORE FAJR")
              .font(.system(size: 10, weight: .bold))
              .foregroundColor(.white.opacity(0.65))
          }
          Divider().overlay(Color.white.opacity(0.1))
          if let next = entry.payload.next {
            PrayerBlockView(block: next, isCurrent: false)
          }
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 11)
      }
    }
  }
}

struct PrayerBlockView: View {
  let block: WidgetPrayerBlock
  let isCurrent: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      HStack {
        Text(block.isTomorrow ? "\(block.prayer.uppercased()) · TOMORROW" : block.prayer.uppercased())
          .font(.system(size: isCurrent ? 10 : 9, weight: .bold))
          .foregroundColor(isCurrent ? Color(hex: "D4AF37") : .white.opacity(0.45))
        Spacer()
        Text(timeText)
          .font(.system(size: 8.5, weight: .regular))
          .foregroundColor(.white.opacity(isCurrent ? 0.42 : 0.26))
      }
      ForEach(Array(block.surahs.prefix(4).enumerated()), id: \.offset) { index, row in
        Text("\(index + 1)  \(row.name)   \(row.ayat)")
          .font(.system(size: isCurrent ? 10 : 9, weight: .regular))
          .foregroundColor(.white.opacity(isCurrent ? 0.9 : 0.45))
          .lineLimit(1)
      }
    }
  }

  private var timeText: String {
    if let countdown = block.countdownMinutes {
      let hours = countdown / 60
      let mins = countdown % 60
      if hours > 0 && mins > 0 { return "in \(hours)h\(mins)m" }
      if hours > 0 { return "in \(hours)h" }
      return "in \(mins)m"
    }
    return block.time
  }
}

/// Widget kind **must** match `HomeWidget.updateWidget(iOSName:)` in Flutter (`SurahPlannerWidget`).
struct SurahPlannerWidget: Widget {
  let kind: String = "SurahPlannerWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: SurahPlannerProvider()) { entry in
      SurahPlannerWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Surah Planner")
    .description("Shows current and next prayer surah assignments.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}

struct WidgetPayload: Codable {
  let state: String
  let current: WidgetPrayerBlock?
  let next: WidgetPrayerBlock?

  static let empty = WidgetPayload(state: "no_plan", current: nil, next: nil)
  static let placeholder = WidgetPayload(
    state: "ready",
    current: WidgetPrayerBlock(
      prayer: "Dhuhr",
      time: "12:00",
      countdownMinutes: nil,
      isTomorrow: false,
      surahs: [WidgetSurahRow(name: "Al-Baqarah", ayat: "1 - 15")]
    ),
    next: WidgetPrayerBlock(
      prayer: "Asr",
      time: "15:30",
      countdownMinutes: 150,
      isTomorrow: false,
      surahs: [WidgetSurahRow(name: "Al-Baqarah", ayat: "16 - 30")]
    )
  )
}

struct WidgetPrayerBlock: Codable {
  let prayer: String
  let time: String
  let countdownMinutes: Int?
  let isTomorrow: Bool
  let surahs: [WidgetSurahRow]
}

struct WidgetSurahRow: Codable {
  let name: String
  let ayat: String
}

private extension Color {
  init(hex: String) {
    let value = Int(hex, radix: 16) ?? 0
    let red = Double((value >> 16) & 0xFF) / 255
    let green = Double((value >> 8) & 0xFF) / 255
    let blue = Double(value & 0xFF) / 255
    self.init(red: red, green: green, blue: blue)
  }
}
