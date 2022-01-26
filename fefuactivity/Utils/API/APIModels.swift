import Foundation

struct UserModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let login: String
    let gender: GenderModel
}

struct SocialUserModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let login: String
}

struct ErrorModel: Decodable {
    let message: String
}

struct FieldsErrorModel: Decodable {
    let errors: Dictionary<String, [String]>
}

struct GenderModel: Decodable {
    let name: String
    let code: Int
}

struct LocationModel: Codable {
    let lat: Double
    let lon: Double
}

struct PaginationModel: Decodable {
    let total: Int
    let count: Int
    let perPage: Int
    let currentPage: Int
    let totalPages: Int
}
