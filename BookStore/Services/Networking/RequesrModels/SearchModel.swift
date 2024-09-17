import Foundation

public struct Doc: Codable {

    public let title_suggest: String?
    public let author_name: [String]?
    public let first_publish_year: Int?
    public let cover_i: Int?
    public let subject_key: [String]?
    public let has_fulltext: Bool?
    public let key: String?
    public let ia: [String]?
}

public struct BookObject: Codable {

    public let start: Int?
    public let numFound: Int?
    public let docs: [Doc]
}

enum CodingKeys: String, CodingKey {

    case title_suggest = "title_suggest"
    case subtitle = "subtitle"
    case author_name = "author_name"
    case first_publish_year = "first_publish_year"
    case cover_i = "cover_i"
    case publisher = "publisher"
    case author_alternative_name = "author_alternative_name"
    case numFound = "num_found"
}
