import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {

    var networkManager: NetworkManager!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManager(session: mockSession)
    }

    override func tearDown() {
        networkManager = nil
        mockSession = nil
        super.tearDown()
    }

    func testFetchData_Success() async throws {
        let jsonData = """
            {
                "name": "Test",
                "age": 30
            }
            """.data(using: .utf8)!
        mockSession.nextData = jsonData
        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)

        struct User: Codable {
            let name: String
            let age: Int
        }

        let user: User = try await networkManager.fetchData(from: "https://example.com")
        XCTAssertEqual(user.name, "Test")
        XCTAssertEqual(user.age, 30)
    }

    func testFetchData_InvalidURL() async {
        do {
            struct User: Codable {}
            _ = try await networkManager.fetchData(from: "invalid-url")
            XCTFail("Expected to throw invalidURL error")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
        }
    }

    func testFetchData_ResponseError() async {
        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                   statusCode: 404,
                                                   httpVersion: nil,
                                                   headerFields: nil)

        do {
            struct User: Codable {}
            _ = try await networkManager.fetchData(from: "https://example.com")
            XCTFail("Expected to throw responseError")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.responseError(404))
        }
    }

    func testFetchData_DecodingError() async {
        let jsonData = "invalid json".data(using: .utf8)!
        mockSession.nextData = jsonData
        mockSession.nextResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)

        do {
            struct User: Codable {}
            _ = try await networkManager.fetchData(from: "https://example.com")
            XCTFail("Expected to throw dataDecodingFailed error")
        } catch {
            if case let NetworkError.dataDecodingFailed(error) = error {
                XCTAssertTrue(error is DecodingError)
            } else {
                XCTFail("Expected dataDecodingFailed error")
            }
        }
    }
}

class MockURLSession: URLSession {
    var nextData: Data?
    var nextError: Error?
    var nextResponse: URLResponse?

    override func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = nextError {
            throw error
        }
        return (nextData ?? Data(), nextResponse ?? URLResponse())
    }
}
