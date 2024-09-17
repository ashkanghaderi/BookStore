//
//  BookModel.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import UIKit

// Mock Data

enum UserDefaultsKeys: String {
    case likedBook = "likedBook"
}

struct BookDetailsModel: Codable {
    var key: String = ""
    var image: Int = 0
    var title: String = ""
    var authorName: String = ""
    var hasFullText: Bool = true
    var ia: String = ""
    var category: String = ""
    var raiting: Double
    var descriptionText: String = """
"""

    var dictionaryRepresentation: [String: Any] {
        return [
            "key": key,
            "title": title,
            "authorName": authorName,
            "hasFullText": hasFullText,
            "ia": ia,
            "category": category,
            "raiting": raiting,
            "descriptionText": descriptionText
        ]
    }

    init(key: String, image: Int, title: String,
         authorName: String, hasFullText: Bool, ia: String,
         category: String, raiting: Double, descriptionText: String) {
        self.key = key
        self.image = image
        self.title = title
        self.authorName = authorName
        self.hasFullText = hasFullText
        self.ia = ia
        self.category = category
        self.raiting = raiting
        self.descriptionText = descriptionText
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        title = try container.decode(String.self, forKey: .title)
        authorName = try container.decode(String.self, forKey: .authorName)
        hasFullText = try container.decode(Bool.self, forKey: .hasFullText)
        ia = try container.decode(String.self, forKey: .ia)
        category = try container.decode(String.self, forKey: .category)
        raiting = try container.decode(Double.self, forKey: .raiting)
        descriptionText = try container.decode(String.self, forKey: .descriptionText)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(key, forKey: .key)
        try container.encode(title, forKey: .title)
        try container.encode(authorName, forKey: .authorName)
        try container.encode(hasFullText, forKey: .hasFullText)
        try container.encode(ia, forKey: .ia)
        try container.encode(category, forKey: .category)
        try container.encode(raiting, forKey: .raiting)
        try container.encode(descriptionText, forKey: .descriptionText)
    }
}

//MARK: Extension

extension BookDetailsModel {
    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authorName
        case hasFullText
        case ia
        case category
        case raiting
        case descriptionText
    }
}

extension UserDefaultsManager.Keys {
    static let bookDetails = UserDefaultsManager.Keys(rawValue: "bookDetails")
}
