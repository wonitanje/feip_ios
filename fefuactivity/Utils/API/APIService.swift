import Foundation

class APIService {
    static let baseUrl = "https://fefu.t.feip.co/api"
    
    static let decoder: JSONDecoder = ({
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    })()
    static let encoder: JSONEncoder = ({
        let decoder = JSONEncoder()
        decoder.keyEncodingStrategy = .convertToSnakeCase

        return decoder
    })()
    
    static func createRequest(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)

        if let token = UserDefaults.standard.string(forKey: "token") {
            request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }

    static func postRequest(url: URL, body: Data) -> URLRequest {
        var request = self.createRequest(url)

        request.httpMethod = "POST"
        request.httpBody = body

        return request
    }

    static func getRequest(url: URL) -> URLRequest {
        var request = self.createRequest(url)

        request.httpMethod = "GET"

        return request
    }
}
