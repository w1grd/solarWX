import Foundation

import Foundation

struct SolarData {
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

    static func parseXML(data: Data) -> SolarData? {
        let parser = XMLSolarParser()
        if parser.parse(data: data) {
            return SolarData(
                updated: parser.updated ?? "--",
                solarFlux: parser.solarFlux ?? "--",
                aIndex: parser.aIndex ?? "--",
                kIndex: parser.kIndex ?? "--",
                xray: parser.xray ?? "--",
                sunspots: parser.sunspots ?? "--",
                heliumLine: parser.heliumLine ?? "--",
                protonFlux: parser.protonFlux ?? "--",
                electronFlux: parser.electronFlux ?? "--",
                aurora: parser.aurora ?? "--",
                latDegree: parser.latDegree ?? "--",
                solarWind: parser.solarWind ?? "--",
                magneticField: parser.magneticField ?? "--"
            )
        }
        return nil
    }
}


class XMLSolarParser: NSObject, XMLParserDelegate {
    var updated: String?
    var solarFlux: String?
    var aIndex: String?
    var kIndex: String?
    var xray: String?
    var sunspots: String?
    var heliumLine: String?
    var protonFlux: String?
    var electronFlux: String?
    var aurora: String?
    var latDegree: String?
    var solarWind: String?
    var magneticField: String?

    private var currentElement = ""

    func parse(data: Data) -> Bool {
        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = self
        return xmlParser.parse()
    }

    // XMLParserDelegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            switch currentElement {
            case "updated":
                updated = trimmed
            case "solarflux":
                solarFlux = trimmed
            case "aindex":
                aIndex = trimmed
            case "kindex":
                kIndex = trimmed
            case "xray":
                xray = trimmed
            case "sunspots":
                sunspots = trimmed
            case "heliumline":
                heliumLine = trimmed
            case "protonflux":
                protonFlux = trimmed
            case "electonflux":
                electronFlux = trimmed
            case "aurora":
                aurora = trimmed
            case "latdegree":
                latDegree = trimmed
            case "solarwind":
                solarWind = trimmed
            case "magneticfield":
                magneticField = trimmed
            default:
                break
            }
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("XML Parse Error: \(parseError.localizedDescription)")
    }
}

