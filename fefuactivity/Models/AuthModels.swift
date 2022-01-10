import Foundation

struct RegisterRequestModel: Encodable {
    let login: String
    let password: String
    let name: String
    let gender: Int
}

struct LoginRequestModel: Encodable {
    let login: String
    let password: String
}

struct LoginErrorModel: Decodable {
    let login: [String]
}

struct UserModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let login: String
    let gender: GenderModel
}

struct AuthResponseModel: Decodable {
    let token: String
    let user: UserModel
}

struct AuthErrorModel: Decodable {
    let errors: Dictionary<String, [String]>
}
