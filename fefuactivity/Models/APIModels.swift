import Foundation

struct ErrorModel: Decodable {
    let message: String
}

struct GenderModel: Decodable {
    let name: String
    let code: Int
}
    
