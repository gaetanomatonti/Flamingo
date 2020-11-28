import Foundation

public struct Flamingo {
    
    /// Creates a data task using `URLSession`
    /// - Parameters:
    ///   - request: The Request object representing an http request.
    ///   - body: The body of the request (optional).
    ///   - responseType: The `Decodable` type expected in the response.
    ///   - decoder: The decoder with which to decode the response.
    ///   - completion: A completion handler which returns a `Result` with the decodable type of `responseType`.
    public static func codableTask<D: Decodable>(_ request: Request, with body: Data? = nil, responseType: D.Type, decodeResponseWith decoder: JSONDecoder? = nil, completion: @escaping (Result<D, Error>) -> Void) {
        do {
            URLSession.shared.dataTask(with: try request.toURLRequest(body: body)) { (data, _, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    do {
                        let decoder = decoder ?? JSONDecoder()
                        let decodedData = try decoder.decode(responseType, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            .resume()
        } catch {
            completion(.failure(error))
        }
    }
    
}
