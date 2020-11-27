import Foundation

@available(iOS 11.0, *)
public protocol HeaderField {
    var key: String { get }
    var value: String { get }
}

@available(iOS 11.0, *)
extension Array where Element == HeaderField {
    var headersFields: [String: String] {
        var dict: [String: String] = [:]
        forEach {
            dict[$0.key] = $0.value
        }
        return dict
    }
}

@available(iOS 11.0, *)
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

@available(iOS 11.0, *)
public enum ContentType: HeaderField {
    case json
    
    public var key: String { "Content-Type" }
    
    public var value: String {
        switch self {
            case .json: return "application/json"
        }
    }
}
