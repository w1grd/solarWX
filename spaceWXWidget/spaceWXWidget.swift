import WidgetKit
import SwiftUI

struct SolarWeatherEntry: TimelineEntry {
    let date: Date
    let aIndex: String
    let kIndex: String
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SolarWeatherEntry {
        SolarWeatherEntry(date: Date(), aIndex: "--", kIndex: "--")
    }

    func getSnapshot(in context: Context, completion: @escaping (SolarWeatherEntry) -> ()) {
        let entry = SolarWeatherEntry(date: Date(), aIndex: "19", kIndex: "4")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SolarWeatherEntry>) -> ()) {
        NetworkManager.shared.fetchSolarData { solarData in
            let currentDate = Date()
            let entryDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!

            let entry: SolarWeatherEntry
            if let data = solarData {
                entry = SolarWeatherEntry(date: currentDate, aIndex: data.aindex, kIndex: data.kindex)
            } else {
                entry = SolarWeatherEntry(date: currentDate, aIndex: "--", kIndex: "--")
            }

            // Refresh every hour
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}


struct spaceWXWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("spaceWX")
                .font(.headline)
            HStack {
                VStack {
                    Text("A Index")
                        .font(.subheadline)
                    Text(entry.aIndex)
                        .font(.largeTitle)
                        .foregroundColor(entry.aIndex == "--" ? .red : .primary)
                }
                VStack {
                    Text("K Index")
                        .font(.subheadline)
                    Text(entry.kIndex)
                        .font(.largeTitle)
                        .foregroundColor(entry.kIndex == "--" ? .red : .primary)
                }
            }
        }
        .padding()
        .containerBackground(.thinMaterial, for: .widget) // <-- Define the background material
    }
}



@main
struct spaceWXWidget: Widget {
    let kind: String = "spaceWXWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            spaceWXWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("spaceWX")
        .description("Displays current A and K solar indices.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct spaceWXWidget_Previews: PreviewProvider {
    static var previews: some View {
        spaceWXWidgetEntryView(entry: SolarWeatherEntry(date: Date(), aIndex: "19", kIndex: "4"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
