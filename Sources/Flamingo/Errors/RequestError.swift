import Foundation

public enum RequestError: Swift.Error {
    /// The response is not an `HTTPURLResponse`
    case unknownResponse
    /// The request could not be made because of a timeout or a connectivity issue
    case networkError(Error)
    /// The request was made but the response indicated the request was invalid. (HTTP 4xx)
    case requestError(Int)
    /// The request was made but the response indicated the server had an error. (HTTP 5xx)
    case serverError(Int)
    /// The response format could not be decoded into the expected type
    case decodingError(DecodingError)
    /// Catch all the errors we're not handling
    case unhandledResponse
}

extension RequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknownResponse: return "Unknown response"
        case .networkError(let error): return "Network Error: " + error.localizedDescription
        case .requestError(let code): return "Request error: \(code)"
        case .serverError(let code): return "Server error: \(code)"
        case .decodingError(let error):
            return "Decoding error: " + decodingErrorMessage(from: error)
        case .unhandledResponse: return "Unhandled Response"
        }
    }
    
    public func decodingErrorMessage(from error: DecodingError) -> String {
        switch error {
            case .dataCorrupted(let context),
                 .keyNotFound(_, let context),
                 .valueNotFound(_, let context),
                 .typeMismatch(_, let context):
                return context.debugDescription
            @unknown default:
                return error.localizedDescription
        }
    }
}

public extension RequestError {
    static func error(from response: URLResponse?) -> RequestError? {
        guard let http = response as? HTTPURLResponse else { return .unknownResponse }
        
        switch http.statusCode {
        case 200...299: return nil
        case 400...499: return .requestError(http.statusCode)
        case 500...599: return .serverError(http.statusCode)
        default: return .unhandledResponse
        }
    }
}
