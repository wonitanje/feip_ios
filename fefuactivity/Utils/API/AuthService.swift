import Foundation

class AuthService: APIService {
    static let groupUrl: String = baseUrl + "/auth"

    static func register(_ data: Data,
                         resolve: @escaping((AuthResponseModel) -> Void),
                         reject: @escaping((AuthErrorModel) -> Void)) {

        guard let url = URL(string: groupUrl + "/register") else {
            return
        }

        let request = super.postRequest(url: url, body: data)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }

            guard let res = response as? HTTPURLResponse else {
                return
            }
            print(res.statusCode)

            switch res.statusCode {
            case 201:
                do {
                    let authResponse = try super.decoder.decode(AuthResponseModel.self, from: data)
                    resolve(authResponse)
                } catch let e {
                    print("Decode error: \(e)")
                }

            case 422:
                do {
                    let error = try super.decoder.decode(AuthErrorModel.self, from: data)
                    reject(error)
                } catch {
                    print("Decode error: \(error)")
                }

            default:
                break
            }
        }
        task.resume()
    }
    
    static func login(_ data: Data,
                      resolve: @escaping((AuthResponseModel) -> Void),
                      reject: @escaping((AuthErrorModel) -> Void)) {

        guard let url = URL(string: groupUrl + "/login") else {
            return
        }

        let request = super.postRequest(url: url, body: data)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }

            guard let res = response as? HTTPURLResponse else {
                return
            }
            print(res.statusCode)

            switch res.statusCode {
            case 200:
                do {
                    let authResponse = try super.decoder.decode(AuthResponseModel.self, from: data)
                    resolve(authResponse)
                } catch let e {
                    print("Decode error: \(e)")
                }

            case 422:
                do {
                    let error = try super.decoder.decode(AuthErrorModel.self, from: data)
                    reject(error)
                } catch {
                    print("Decode error: \(error)")
                }

            default:
                break
            }
        }
        task.resume()
    }

    static func errorMessage(error: AuthErrorModel) -> String {
        return error.errors.map { (_: String, value: [String]) in
            value.joined(separator: "\n")
        }.joined(separator: "\n")
    }
}
