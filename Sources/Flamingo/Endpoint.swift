@available(iOS 11.0, *)
public struct Endpoint {
    /// The base url of a url.
    public let baseURL: BaseURL
    /// The path subcomponent of a url.
    @Path public var path: String
    
    public init(baseURL: BaseURL, path: String) {
        self.baseURL = baseURL
        self.path = path
    }
}

@available(iOS 11.0, *)
@propertyWrapper public struct Path {
    public var wrappedValue: String {
        didSet {
            wrappedValue = "/" + wrappedValue.trimmingCharacters(in: [" ", "/"])
        }
    }
    
    public init(wrappedValue: String) {
        self.wrappedValue = "/" + wrappedValue.trimmingCharacters(in: [" ", "/"])
    }
}
