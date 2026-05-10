import SwiftUI
import WidgetKit

struct SurahPlannerWidgetEntry: TimelineEntry {
    let date: Date
    let payload: WidgetPayload?
    let resolved: ResolvedWidgetSlots?
    let emptyReason: WidgetEmptyReason?
}

struct SurahPlannerWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> SurahPlannerWidgetEntry {
        sampleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SurahPlannerWidgetEntry) -> Void) {
        completion(entry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SurahPlannerWidgetEntry>) -> Void) {
        let current = entry(date: Date())
        let refreshDate = current.resolved?.nextRefreshDate ?? Calendar.current.date(byAdding: .hour, value: 1, to: current.date) ?? current.date
        completion(Timeline(entries: [current], policy: .after(refreshDate)))
    }

    private func entry(date: Date) -> SurahPlannerWidgetEntry {
        let payload = WidgetResolver.loadPayload()
        if let reason = WidgetResolver.emptyReason(for: payload) {
            return SurahPlannerWidgetEntry(date: date, payload: payload, resolved: nil, emptyReason: reason)
        }
        guard let payload,
              let resolved = WidgetResolver.resolve(payload: payload, now: date) else {
            return SurahPlannerWidgetEntry(date: date, payload: payload, resolved: nil, emptyReason: .stale)
        }
        return SurahPlannerWidgetEntry(date: date, payload: payload, resolved: resolved, emptyReason: nil)
    }

    private func sampleEntry(date: Date) -> SurahPlannerWidgetEntry {
        let current = WidgetSlot(title: "DHUHR", time: "12:08", rows: ["1  Al-Kahf  1 - 10", "2  Yasin"])
        let next = WidgetSlot(title: "ASR", time: "15:21", rows: ["1  Ar-Rahman  1 - 20"])
        let resolved = ResolvedWidgetSlots(current: current, next: next, muteCurrentColumn: false, nextRefreshDate: nil)
        return SurahPlannerWidgetEntry(date: date, payload: nil, resolved: resolved, emptyReason: nil)
    }
}

struct SurahPlannerWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: SurahPlannerWidgetEntry

    var body: some View {
        ZStack {
            if let resolved = entry.resolved {
                readyView(resolved)
            } else {
                emptyView(entry.emptyReason ?? .noPlan)
            }
        }
        .widgetBackground()
    }

    @ViewBuilder
    private func readyView(_ resolved: ResolvedWidgetSlots) -> some View {
        if family == .systemMedium {
            mediumReadyView(resolved)
        } else {
            smallReadyView(resolved)
        }
    }

    private func smallReadyView(_ resolved: ResolvedWidgetSlots) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            WidgetHeader()
            PrayerBlock(slot: resolved.current, palette: resolved.muteCurrentColumn ? .muted : .active, topRowPadding: 2)
                .padding(.top, 4)
            Rectangle()
                .fill(WidgetPalette.divider)
                .frame(height: 1)
                .padding(.vertical, 3)
            PrayerBlock(slot: resolved.next, palette: .muted, topRowPadding: 2)
        }
        .padding(.horizontal, -4)
        .padding(.top, 0)
        .padding(.bottom, -2)
    }

    private func mediumReadyView(_ resolved: ResolvedWidgetSlots) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            WidgetHeader()
                .padding(.leading, 2)
            HStack(spacing: 0) {
                PrayerBlock(slot: resolved.current, palette: resolved.muteCurrentColumn ? .muted : .active, topRowPadding: 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 2)
                Rectangle()
                    .fill(WidgetPalette.divider)
                    .frame(width: 1)
                PrayerBlock(slot: resolved.next, palette: .muted, topRowPadding: 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 2)
            }
            .padding(.top, 3)
        }
        .padding(.horizontal, -2)
        .padding(.top, 2)
        .padding(.bottom, 2)
    }

    private func emptyView(_ reason: WidgetEmptyReason) -> some View {
        let text = WidgetResolver.emptyText(reason: reason, strings: entry.payload?.strings)
        return VStack(spacing: 2) {
            CrescentMark()
                .fill(WidgetPalette.emptyMark, style: FillStyle(eoFill: true))
                .frame(width: 52, height: 60)
                .padding(.bottom, 2)
            Text(text.title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(WidgetPalette.emptyTitle)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Text(text.subtitle)
                .font(.system(size: 13))
                .foregroundColor(WidgetPalette.emptySubtitle)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
        }
        .padding(.horizontal, 14)
    }
}

struct WidgetHeader: View {
    var body: some View {
        HStack(spacing: 6) {
            Text("◐")
            Text("Ayatura")
        }
        .font(.system(size: 11))
        .foregroundColor(WidgetPalette.header)
    }
}

struct PrayerBlock: View {
    let slot: WidgetSlot
    let palette: PrayerPalette
    let topRowPadding: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 6) {
                Text(slot.title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(palette.titleColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer(minLength: 4)
                Text(slot.time)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(palette.timeColor)
            }
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(slot.rows.prefix(4).enumerated()), id: \.offset) { _, row in
                    Text(row)
                        .font(.system(size: 12))
                        .foregroundColor(palette.rowColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }
            .padding(.top, topRowPadding)
        }
    }
}

struct CrescentMark: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let scaleX = rect.width / 60
        let scaleY = rect.height / 75
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)

        var crescent = Path()
        crescent.addArc(center: CGPoint(x: 27, y: 27), radius: 23, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        crescent.addArc(center: CGPoint(x: 38, y: 20), radius: 19, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        path.addPath(crescent.applying(transform), transform: .identity)

        for x in [4, 16, 28, 40, 52] {
            var dot = Path()
            dot.addArc(center: CGPoint(x: x, y: 65), radius: 4.2, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
            path.addPath(dot.applying(transform), transform: .identity)
        }
        return path
    }
}

enum PrayerPalette {
    case active
    case muted

    var titleColor: Color {
        switch self {
        case .active:
            return WidgetPalette.currentTitle
        case .muted:
            return WidgetPalette.nextTitle
        }
    }

    var timeColor: Color {
        switch self {
        case .active:
            return WidgetPalette.currentTime
        case .muted:
            return WidgetPalette.nextTime
        }
    }

    var rowColor: Color {
        switch self {
        case .active:
            return WidgetPalette.currentRow
        case .muted:
            return WidgetPalette.nextRow
        }
    }
}

enum WidgetPalette {
    static let backgroundStart = Color(hex: 0x0F3D2E)
    static let backgroundEnd = Color(hex: 0x1F7A6B)
    static let header = Color(argb: 0x7AFFFFFF)
    static let currentTitle = Color(hex: 0xD4AF37)
    static let currentTime = Color(argb: 0x61FFFFFF)
    static let currentRow = Color(argb: 0xE6FFFFFF)
    static let nextTitle = Color(argb: 0x6BFFFFFF)
    static let nextTime = Color(argb: 0x42FFFFFF)
    static let nextRow = Color(argb: 0x80FFFFFF)
    static let divider = Color(argb: 0x26FFFFFF)
    static let emptyMark = Color(argb: 0x29FFFFFF)
    static let emptyTitle = Color(argb: 0xD9FFFFFF)
    static let emptySubtitle = Color(argb: 0x8CFFFFFF)
}

extension Color {
    init(hex: Int) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }

    init(argb: Int) {
        self.init(
            red: Double((argb >> 16) & 0xFF) / 255,
            green: Double((argb >> 8) & 0xFF) / 255,
            blue: Double(argb & 0xFF) / 255,
            opacity: Double((argb >> 24) & 0xFF) / 255
        )
    }
}

private extension View {
    @ViewBuilder
    func widgetBackground() -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            containerBackground(for: .widget) {
                LinearGradient(
                    colors: [WidgetPalette.backgroundStart, WidgetPalette.backgroundEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        } else {
            background(
                LinearGradient(
                    colors: [WidgetPalette.backgroundStart, WidgetPalette.backgroundEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
}

@main
struct SurahPlannerWidget: Widget {
    let kind = "SurahPlannerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SurahPlannerWidgetProvider()) { entry in
            SurahPlannerWidgetView(entry: entry)
        }
        .configurationDisplayName("Ayatura")
        .description("Shows your current and next prayer reading slots from your Ayatura plan.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
