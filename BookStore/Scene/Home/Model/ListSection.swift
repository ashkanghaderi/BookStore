//
//  ListSection.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import Foundation

enum ListSection {
    case topBooks([ListItem])
    case recentBooks([ListItem])
    
    var items: [ListItem] {
        switch self {
        case .topBooks(let items),
                .recentBooks(let items):
            return items
        }
    }
    
    var count: Int {
        items.count
    }

    var title: String {
        switch self {
            
        case .topBooks(_):
            return "Top Books"
        case .recentBooks(_):
            return "Recent Books"
        }
    }
}
