import Foundation

public struct QueryParameter {
    let key: String
    let value: LosslessStringConvertible
}

extension Array where Element == QueryParameter {
    var urlQueryItems: [URLQueryItem] {
        map { URLQueryItem(name: $0.key, value: $0.value.description) }
    }
}
