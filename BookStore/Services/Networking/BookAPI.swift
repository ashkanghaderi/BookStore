import UIKit
import Networking

enum TrendingPeriod: String {
    case weekly = "weekly"
    case monthly = "monthly"
    case yearly = "yearly"
}

enum Categories: String {
    case love = "love"
    case fiction = "fiction"
    case horror = "horror"
    case crime = "crime"
    case drama = "drama"
    case classics = "classics"
    case forChildren = "children"
    case sci_fi = "sci-fi"
    case humor = "humor"
    case poetry = "poetry"
    case art = "history_of_art__art__design_styles"
    case history = "history"
    case biography = "biography"
    case business = "business"
    case fantasy = "fantasy"
}

protocol BookAPIProtocol: AnyObject {
    func searchBooks(keyword: String) async throws -> BookObject?
    func getTrendingBooks(for period: TrendingPeriod) async throws -> [TrendingBooks.Book]
    func getCategoryCollection(for category: Categories) async throws -> [CategoryCollection]
    func getBookDetails(for key: String) async throws -> DetailsModel
}

public class BookAPI:  BookAPIProtocol{

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func searchBooks(keyword: String) async throws -> BookObject? {
        guard !keyword.isEmpty else {
            return nil
        }

        let url = "https://openlibrary.org/search.json?q=\(keyword.replacingOccurrences(of: " ", with: "+"))"

        let bookObject: BookObject = try await networkManager.fetchData(from: url)
        return bookObject
    }

    func getTrendingBooks(for period: TrendingPeriod) async throws -> [TrendingBooks.Book] {
        let trendingURL = "https://openlibrary.org/trending/\(period.rawValue).json"

        // Fetch trending books using NetworkManager
        let trendingBooks: TrendingBooks = try await networkManager.fetchData(from: trendingURL)
        return trendingBooks.works
    }

    func getCategoryCollection(for category: Categories) async throws -> [CategoryCollection] {
        let categoryURL = "https://openlibrary.org/subjects/\(category.rawValue).json"

        let categoryCollection: CategoryCollection = try await networkManager.fetchData(from: categoryURL)
        return [categoryCollection]
    }

    func getBookDetails(for key: String) async throws -> DetailsModel {
        let detailsURL = "https://openlibrary.org\(key).json"

        let bookDetails: DetailsModel = try await networkManager.fetchData(from: detailsURL)
        return bookDetails
    }
}
