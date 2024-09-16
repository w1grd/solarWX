import WidgetKit
import SwiftUI

import WidgetKit

struct SolarWeatherEntry: TimelineEntry {
    let date: Date
    let updated: String
    let solarFlux: String
    let aIndex: String
    let kIndex: String
    let xray: String
    let sunspots: String
    let heliumLine: String
    let protonFlux: String
    let electronFlux: String
    let aurora: String
    let latDegree: String
    let solarWind: String
    let magneticField: String
}


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SolarWeatherEntry {
        SolarWeatherEntry(
            date: Date(), updated: "--", solarFlux: "--", aIndex: "--", kIndex: "--",
            xray: "--", sunspots: "--", heliumLine: "--", protonFlux: "--",
            electronFlux: "--", aurora: "--", latDegree: "--", solarWind: "--",
            magneticField: "--"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SolarWeatherEntry) -> Void) {
        let entry = SolarWeatherEntry(
            date: Date(), updated: "16 Sep 2024 1631 GMT", solarFlux: "173", aIndex: "19",
            kIndex: "4", xray: "C1.7", sunspots: "103", heliumLine: "156.0",
            protonFlux: "934", electronFlux: "20400", aurora: "2", latDegree: "66.5",
            solarWind: "467.5", magneticField: "6.9"
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SolarWeatherEntry>) -> Void) {
        NetworkManager.shared.fetchSolarData { solarData in
            let currentDate = Date()
            let entry: SolarWeatherEntry
            if let data = solarData {
                entry = SolarWeatherEntry(
                    date: currentDate, updated: data.updated, solarFlux: data.solarFlux,
                    aIndex: data.aIndex, kIndex: data.kIndex, xray: data.xray,
                    sunspots: data.sunspots, heliumLine: data.heliumLine,
                    protonFlux: data.protonFlux, electronFlux: data.electronFlux,
                    aurora: data.aurora, latDegree: data.latDegree,
                    solarWind: data.solarWind, magneticField: data.magneticField
                )
            } else {
                entry = SolarWeatherEntry(
                    date: currentDate, updated: "--", solarFlux: "--", aIndex: "--",
                    kIndex: "--", xray: "--", sunspots: "--", heliumLine: "--",
                    protonFlux: "--", electronFlux: "--", aurora: "--", latDegree: "--",
                    solarWind: "--", magneticField: "--"
                )
            }
            // Refresh every hour
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}




struct spaceWXWidgetEntryView: View {
    var entry: SolarWeatherEntry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Updated: \(entry.updated)")
                .font(.caption)
                .foregroundColor(.yellow)
            Text("SFI \(entry.solarFlux)  SN \(entry.sunspots)")
                .foregroundColor(.yellow)
            Text("A \(entry.aIndex)  K \(entry.kIndex)")
                .foregroundColor(.green)
            Text("X-ray \(entry.xray)")
                .foregroundColor(.orange)
            Text("Solar Wind \(entry.solarWind) km/s")
                .foregroundColor(.blue)
            Text("Magnetic Field \(entry.magneticField)")
                .foregroundColor(.red)
        }
        .padding()
        .containerBackground(Color.black, for: .widget) // Add background material
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
        spaceWXWidgetEntryView(entry: SolarWeatherEntry(
            date: Date(),
            updated: "16 Sep 2024 1631 GMT",
            solarFlux: "173",
            aIndex: "19",
            kIndex: "4",
            xray: "C1.7",
            sunspots: "103",
            heliumLine: "156.0",
            protonFlux: "934",
            electronFlux: "20400",
            aurora: "2",
            latDegree: "66.5",
            solarWind: "467.5",
            magneticField: "6.9"
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

