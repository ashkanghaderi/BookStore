import Foundation

public enum NetworkError: Error, Equatable {
    case invalidURL
    case requestFailed(Error)
    case responseError(Int)
    case dataDecodingFailed(Error)

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.requestFailed(let lhsError), .requestFailed(let rhsError)):
            return (lhsError as NSError).domain == (rhsError as NSError).domain && (lhsError as NSError).code == (rhsError as NSError).code
        case (.responseError(let lhsCode), .responseError(let rhsCode)):
            return lhsCode == rhsCode
        case (.dataDecodingFailed(let lhsError), .dataDecodingFailed(let rhsError)):
            return (lhsError as NSError).domain == (rhsError as NSError).domain && (lhsError as NSError).code == (rhsError as NSError).code
        default:
            return false
        }
    }
}

public protocol NetworkManagerProtocol {
    func fetchData<T: Codable>(from urlString: String) async throws -> T
}

public class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetchData<T: Codable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(for: URLRequest(url: url))

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw NetworkError.responseError(statusCode)
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.dataDecodingFailed(error)
        }
    }
}
