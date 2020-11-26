import Foundation

public struct Request: CustomStringConvertible {
    public let method: HTTPMethod
    public let endpoint: Endpoint
    public let queryParameters: [URLQueryItem]?
    public let headers: [HeaderField]?
    
    public var description: String {
        (try? toURLRequest().description) ?? urlComponents().description
    }
    
    public init(method: HTTPMethod, endpoint: Endpoint, queryParameters: [QueryParameter]? = nil, headers: [HeaderField]? = nil) {
        self.method = method
        self.endpoint = endpoint
        self.queryParameters = queryParameters?.urlQueryItems
        self.headers = headers
    }
    
    func urlComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.host = endpoint.baseURL.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = queryParameters
        urlComponents.scheme = endpoint.baseURL.scheme
        return urlComponents
    }
    
    func url() throws -> URL {
        guard let url = urlComponents().url else { throw URLError.invalidURLFormat }
        return url
    }
    
    public func toURLRequest(body: Data? = nil) throws -> URLRequest {
        var request = URLRequest(url: try url())
        request.httpBody = body
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers?.headersFields
        return request
    }
}
