import Foundation

@available(iOS 11.0, *)
public struct QueryParameter: Hashable, Equatable {
    let key: String
    let value: LosslessStringConvertible
    
    public init(key: String, value: LosslessStringConvertible) {
        self.key = key
        self.value = value
    }

    public static func ==(lhs: QueryParameter, rhs: QueryParameter) -> Bool {
        lhs.key == rhs.key
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

@available(iOS 11.0, *)
extension Set where Element == QueryParameter {
    var urlQueryItems: [URLQueryItem] {
        map { URLQueryItem(name: $0.key, value: $0.value.description) }
    }
}

@available(iOS 11.0, *)
extension Array where Element == URLQueryItem {
    var queryParameters: [QueryParameter] {
        compactMap {
            guard let value = $0.value else { return nil }
            return QueryParameter(key: $0.name, value: value)
        }
    }
}
