import Foundation

public protocol HeaderField {
    var key: String { get }
    var value: String { get }
}

extension Array where Element == HeaderField {
    var headersFields: [String: String] {
        var dict: [String: String] = [:]
        forEach {
            dict[$0.key] = $0.value
        }
        return dict
    }
}

public enum Authentication: HeaderField {
    case bearer(token: String), basic(token: String)
    
    public var key: String { return "Authentication" }
    
    public var value: String {
        switch self {
            case .basic(let token): return "Basic \(token)"
            case .bearer(let token): return "Bearer \(token)"
        }
    }
}

public enum ContentType: HeaderField {
    case json
    
    public var key: String { "Content-Type" }
    
    public var value: String {
        switch self {
            case .json: return "application/json"
        }
    }
}
