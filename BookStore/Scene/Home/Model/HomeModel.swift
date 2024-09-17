import UIKit

struct HomeModel {
    
    static let shared = HomeModel()
    
    private let topBooks: ListSection = {
        .topBooks([])
    }()
    
    private let recentBooks: ListSection = {
        .recentBooks([])
    }()
    
    var pageData: [ListSection] {
        [topBooks, recentBooks]
    }
}
