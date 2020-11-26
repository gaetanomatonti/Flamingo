public struct BaseURL {
    public var host: String
    public var isSecure: Bool
    
    var scheme: String {
        isSecure ? "https" : "http"
    }
    
    public init(host: String, isSecure: Bool = true) {
        self.host = host
        self.isSecure = isSecure
    }
}
