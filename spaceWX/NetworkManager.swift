import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    let urlString = "https://www.hamqsl.com/solarxml.php"

    func fetchSolarData(completion: @escaping (SolarData?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Data Task Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }

            let solarData = SolarData.parseXML(data: data)
            completion(solarData)
        }

        task.resume()
    }
}
