import Foundation

@available(iOS 11.0, *)
public struct QueryParameter {
    let key: String
    let value: LosslessStringConvertible
}

@available(iOS 11.0, *)
extension Array where Element == QueryParameter {
    var urlQueryItems: [URLQueryItem] {
        map { URLQueryItem(name: $0.key, value: $0.value.description) }
    }
}
