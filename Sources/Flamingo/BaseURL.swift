@available(iOS 11.0, *)
public struct BaseURL {
    /// The host subcomponent of a url.
    public var host: String
    /// Whether the connection should use SSL.
    public var isSecure: Bool
    
    var scheme: String {
        isSecure ? "https" : "http"
    }
    
    public init(host: String, isSecure: Bool = true) {
        self.host = host
        self.isSecure = isSecure
    }
}
