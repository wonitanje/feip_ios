import Foundation

class UserService: APIService {
    static let groupUrl: String = baseUrl + "/user"

    static func profile(resolve: @escaping((UserModel) -> Void),
                        reject: @escaping((ErrorModel) -> Void)) {

        guard let url = URL(string: groupUrl + "/profile") else {
            return
        }

        let request = super.getRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            guard let res = response as? HTTPURLResponse else {
                return
            }

            switch res.statusCode {
            case 200:
                do {
                    let user = try super.decoder.decode(UserModel.self, from: data)
                    resolve(user)
                } catch let e {
                    print("Decode error: \(e)")
                }

            case 401:
                do {
                    let error = try super.decoder.decode(ErrorModel.self, from: data)
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

    static func activities(resolve: @escaping((ActivitiesResponseModel) -> Void),
                           reject: @escaping((FieldsErrorModel?) -> Void)) {

        guard let url = URL(string: groupUrl + "/activities") else {
            return
        }

        let request = super.getRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                return
            }
            guard let res = response as? HTTPURLResponse else {
                return
            }

            switch res.statusCode {
            case 200:
                do {
                    let activities = try super.decoder.decode(ActivitiesResponseModel.self, from: data)
                    print(activities)
                    if (activities.items.count > 0) {
                        resolve(activities)
                    } else {
                        reject(nil)
                    }
                } catch let e {
                    print("Decode error: \(e)")
                }

            case 422:
                do {
                    let error = try super.decoder.decode(FieldsErrorModel.self, from: data)
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
    
    static func saveActivity(_ data: ActivityRequestModel,
                             resolve: @escaping((ActivitiesResponseModel) -> Void),
                             reject: @escaping((FieldsErrorModel?) -> Void)) {

        guard let url = URL(string: groupUrl + "/activities") else {
            return
        }

        let reqData: Data
        do {
            reqData = try encoder.encode(data)
            if let JSONString = String(data: reqData, encoding: .utf8) {
                print(JSONString)
            }
//            print(reqData.startsAt)
        } catch {
            print(error)
            return
        }

        let request = super.postRequest(url: url, data: reqData)
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
                    let activities = try super.decoder.decode(ActivitiesResponseModel.self, from: data)
                    
                    print(activities)
                    resolve(activities)
                } catch let e {
                    print("Decode error: \(e)")
                }

            case 422:
                do {
                    let error = try super.decoder.decode(FieldsErrorModel.self, from: data)
                    reject(error)
                } catch {
                    print("Decode error: \(error)")
                }
                
            case 401:
                do {
                    let error = try super.decoder.decode(FieldsErrorModel.self, from: data)
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
}
