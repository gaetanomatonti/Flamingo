import Foundation

@available(iOS 11.0, *)
/// An object representing an HTTP request.
public struct Request: CustomStringConvertible {
    /// The HTTP method of the request.
    public let method: HTTPMethod
    /// The endpoint of the request.
    public let endpoint: Endpoint
    /// The body of the request.
    public var body: Data?
    /// The query parameters of the request.
    public var queryParameters: Set<QueryParameter>?
    /// The headers of the request.
    public var headers: [HeaderField]?
    /// The query items of the request.
    public var queryItems: [URLQueryItem]? {
        get { queryParameters?.urlQueryItems }
        set { newValue.flatMap { queryParameters = Set($0.queryParameters) } }
    }
    
    public var description: String {
        (try? toURLRequest().description) ?? urlComponents().description
    }
    
    /// Creates a `Request` object.
    /// - Parameters:
    ///   - method: The HTTP method of the request.
    ///   - endpoint: The endpoint of the request.
    ///   - queryParameters: The query parameters of the request (optional).
    ///   - headers: The headers of the request (optional).
    public init(method: HTTPMethod, endpoint: Endpoint, queryParameters: Set<QueryParameter>? = nil, headers: [HeaderField]? = nil) {
        self.method = method
        self.endpoint = endpoint
        self.queryParameters = queryParameters
        self.headers = headers
    }
    
    /// Constructs a `Request` object from a `URL`.
    /// - Parameters:
    ///   - method: The HTTP method of the request.
    ///   - url: The URL of the request
    public init?(method: HTTPMethod, url: URL) {
        self.method = method
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let host = components.host else { return nil }
        self.endpoint = Endpoint(baseURL: BaseURL(host: host), path: url.path)
        self.queryItems = components.queryItems
    }
    
    /// Adds new query parameters to the request.
    /// - Parameter parameters: The query parameters to add to the request.
    /// - Returns: A copy of the original request with added query parameters.
    public func appending(query parameters: Set<QueryParameter>) -> Self {
        var newRequest = self
        
        if newRequest.queryParameters == nil {
            newRequest.queryParameters = []
        }

        parameters.forEach { newRequest.queryParameters?.update(with: $0) }
        return newRequest
    }
            
    /// Creates a `URLComponents` object from the attributes of the request.
    /// - Returns: A `URLComponents` object representing the url for the request.
    func urlComponents() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.host = endpoint.baseURL.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = queryItems
        urlComponents.scheme = endpoint.baseURL.scheme
        return urlComponents
    }
    
    /// Creates a `URL` object for the request.
    /// - Throws: `URLError`
    /// - Returns: A `URL` for the request.
    func makeURL() throws -> URL {
        guard let url = urlComponents().url else { throw URLError.invalidURLFormat }
        return url
    }
    
    /// Converts `Request` to a `URLRequest` object.
    /// - Parameter body: An optional `Data` object to send as the body of the request.
    /// - Throws: `URLError`
    /// - Returns: A `URLRequest` object representing the request.
    public func toURLRequest() throws -> URLRequest {
        var request = URLRequest(url: try makeURL())
        request.httpBody = body
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers?.headersFields
        return request
    }
}
