//
//  BookAPITests.swift
//  BookStoreTests
//
//  Created by Ashkan Ghaderi on 2024-09-18.
//

import XCTest
@testable import BookStore
import Networking

// Mock NetworkManager
class MockNetworkManager: NetworkManagerProtocol {
    var dataToReturn: Codable?
    var errorToThrow: Error?

    func fetchData<T: Codable>(from urlString: String) async throws -> T {
        if let error = errorToThrow {
            throw error
        }
        if let data = dataToReturn as? T {
            return data
        }
        throw NetworkError.dataDecodingFailed(NSError(domain: "MockError", code: 0, userInfo: nil))
    }
}

class BookAPITests: XCTestCase {

    var sut: BookAPI!  // System Under Test
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        sut = BookAPI(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    // Test searchBooks function with valid data
    func testSearchBooksSuccess() async throws {
        // Given
        let mockResponse = BookObject(start: 1, numFound: 1, docs: [Doc(title_suggest: "Test Book", author_name: ["Author 1"], first_publish_year: 2021, cover_i: 1120, subject_key: ["sub1"], has_fulltext: true, key: "1", ia: ["test"])])

        mockNetworkManager.dataToReturn = mockResponse

        // When
        let result = try await sut.searchBooks(keyword: "Test")

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.docs.first?.title_suggest, "Test Book")
        XCTAssertEqual(result?.docs.first?.author_name?.first, "Author 1")
    }

    // Test searchBooks with empty keyword
    func testSearchBooksWithEmptyKeyword() async throws {
        // When
        let result = try await sut.searchBooks(keyword: "")

        // Then
        XCTAssertNil(result, "Expected nil when the keyword is empty.")
    }

    // Test getTrendingBooks function with valid data
    func testGetTrendingBooksSuccess() async throws {
        // Given
        let mockResponse = TrendingBooks(query: "testKey", works: [TrendingBooks.Book(key: "1", title: "Trending Book", first_publish_year: 2021, has_fulltext: true, ia: ["test"], ia_collection_s: "test", cover_edition_key: "testKey", cover_i: 123, author_key: ["Author key"], author_name: ["Author 1"])])

        mockNetworkManager.dataToReturn = mockResponse

        // When
        let result = try await sut.getTrendingBooks(for: .weekly)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result.first?.title, "Trending Book")
        XCTAssertEqual(result.first?.author_name?.first, "Author 1")
    }

    // Test getTrendingBooks with network error
    func testGetTrendingBooksFailure() async throws {
        // Given
        mockNetworkManager.errorToThrow = NetworkError.requestFailed(NSError(domain: "TestError", code: -1, userInfo: nil))

        do {
            // When
            _ = try await sut.getTrendingBooks(for: .weekly)
            XCTFail("Expected an error but got success.")
        } catch {
            // Then
            XCTAssertEqual(error as? NetworkError, NetworkError.requestFailed(NSError(domain: "TestError", code: -1, userInfo: nil)))
        }
    }

    // Test getCategoryCollection function with valid data
    func testGetCategoryCollectionSuccess() async throws {
        // Given

        let mockResponse = CategoryCollection(key: "1", name: "name", work_count: 1, works: [CategoryCollection.Work(key: "1", title: "Category Book", cover_id: 123, edition_count: 123, authors: [CategoryCollection.Work.Author(name: "Author 1", key: "Author")], first_publish_year: 2021, has_fulltext: true, ia: "test")])

        mockNetworkManager.dataToReturn = mockResponse

        // When
        let result = try await sut.getCategoryCollection(for: .fiction)

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result.first?.works.first?.title, "Category Book")
    }

    // Test getBookDetails function with valid data
    func testGetBookDetailsSuccess() async throws {
        // Given
        let mockResponse = DetailsModel(description: DetailsModel.Description(value: "Description"), key: "1", title: "Book Title", authors: [DetailsModel.Authors(key: "Authors 1")], averageRating: 1.0)

        mockNetworkManager.dataToReturn = mockResponse

        // When
        let result = try await sut.getBookDetails(for: "/works/OL12345W")

        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result.title, "Book Title")
    }
}
