import Foundation

struct SocialActivitiesRequestModel: Encodable {
    let page: Int
    let perPage: Int
}

struct ActivitiesResponseModel: Decodable {
    let items: [ActivityModel]
    let pagination: PaginationModel
}

struct SocialActivitiesResponseModel: Decodable {
    let items: [SocialActivityModel]
    let pagination: PaginationModel
}

struct ActivityRequestModel: Encodable {
    let startsAt: Date
    let endsAt: Date
    let activityTypeId: Int
    let geoTrack: [LocationModel]
}

struct ActivityModel: Decodable {
    let id: Int
    let createdAt: Date
    let startsAt: Date
    let endsAt: Date
    let activityType: ActivityTypeModel
    let geoTrack: [LocationModel]
}

struct SocialActivityModel: Decodable {
    let id: Int
    let createdAt: Date
    let startsAt: Date
    let endsAt: Date
    let activityType: ActivityTypeModel
    let geoTrack: [LocationModel]
    let user: SocialUserModel
}

struct ActivityTypeModel: Decodable {
    let id: Int
    let name: String
}
