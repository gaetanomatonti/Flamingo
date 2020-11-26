import Foundation

public struct Endpoint {
    public let baseURL: BaseURL
    public let path: String
    
    public init(baseURL: BaseURL, path: String) {
        self.baseURL = baseURL
        self.path = path
    }
}
