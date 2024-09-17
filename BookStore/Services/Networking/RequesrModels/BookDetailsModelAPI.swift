import Foundation

public struct DetailsModel: Codable {

    let description: Description?
    let key: String?
    let title: String?
    let authors: [Authors]?
    let averageRating: Double?

    struct Authors: Codable {
        let key: String?
    }

    struct Description: Codable {
        let value: String?
    }
}
