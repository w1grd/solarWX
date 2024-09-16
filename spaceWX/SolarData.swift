import Foundation

struct SolarData: Decodable {
    let aindex: String
    let kindex: String

    enum CodingKeys: String, CodingKey {
        case aindex = "aindex"
        case kindex = "kindex"
    }

    // Function to parse XML data
    static func parseXML(data: Data) -> SolarData? {
        let parser = XMLSolarParser()
        if parser.parse(data: data) {
            return SolarData(aindex: parser.aindex ?? "--", kindex: parser.kindex ?? "--")
        }
        return nil
    }
}

class XMLSolarParser: NSObject, XMLParserDelegate {
    var aindex: String?
    var kindex: String?
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
            case "aindex":
                aindex = trimmed
            case "kindex":
                kindex = trimmed
            default:
                break
            }
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("XML Parse Error: \(parseError.localizedDescription)")
    }
}
