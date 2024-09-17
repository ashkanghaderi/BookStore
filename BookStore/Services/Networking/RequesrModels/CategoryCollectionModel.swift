//
//  CategoryCollection Model.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import Foundation

public struct CategoryCollection: Codable {
    let key: String?
    let name: String?
    let work_count: Int?
    let works: [Work]

    struct Work: Codable {
        let key: String?
        let title: String?
        let cover_id: Int?
//        let cover_edition_key: String?
//        let subject: [Subject]
        let edition_count: Int?
        let authors: [Author]
        let first_publish_year: Int?
        let has_fulltext: Bool? 
        let ia: String?

        struct Author: Codable {
            let name: String?
            let key: String?
        }
    }
}
