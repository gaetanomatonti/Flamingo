import Foundation

public struct FlamingoTask {
    public typealias CodableTaskCompletion<D: Decodable> = (Result<D, Error>) -> Void
    /// The request of the task.
    public var request: Request
    /// The body of the request.
    public var body: Data? {
        willSet {
            request.body = newValue
        }
    }
    private var session: URLSession = .shared
    /// The underlying URLSessionDataTask.
    private var urlSessionDataTask: URLSessionDataTask?
    
    public init(request: Request, body: Data? = nil) {
        self.request = request
        self.body = body
    }
    
    /// Encodes an object in json format.
    /// - Parameters:
    ///   - value: The `Encodable` object to encode.
    ///   - encoder: The `JSONEncoder` encoder to use for the encoding.
    /// - Throws: `EncodingError`
    /// - Returns: The task that is currently being set up.
    @discardableResult
    public func encode<E: Encodable>(_ value: E, with encoder: JSONEncoder? = JSONEncoder()) throws -> FlamingoTask {
        var copy = self
        copy.body = try encoder?.encode(value)
        return copy
    }
    
    @discardableResult
    public func set(_ session: URLSession = .shared) -> FlamingoTask {
        var copy = self
        copy.session = session
        return copy
    }
    
    /// Sets up the task ready to be executed.
    /// - Parameters:
    ///   - session: The `URLSession` object to use for the task. Defaults to `shared`.
    ///   - responseType: The `Decodable` type expected in the response.
    ///   - decoder: The `JSONDecoder` to use for the decoding.
    ///   - completion: The completion handler for the request.
    /// - Returns: The task after setup.
    @discardableResult
    public func decode<D: Decodable>(
        _ responseType: D.Type,
        with decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping CodableTaskCompletion<D>
    ) throws -> FlamingoTask {
        var copy = self
        copy.urlSessionDataTask = session.dataTask(with: try request.toURLRequest()) { (data, response, error) in
            if let error = RequestError.error(from: response) {
                completion(.failure(error))
                return
            }
            if let error = RequestError.error(from: error) {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let decodedData = try decoder.decode(responseType, from: data)
                    completion(.success(decodedData))
                } catch let error as DecodingError {
                    completion(.failure(RequestError.decodingError(error)))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        return copy
    }
    
    /// Executes the task.
    @discardableResult
    public func start() -> FlamingoTask {
        urlSessionDataTask?.resume()
        return self
    }
    
    /// Cancels the task.
    @discardableResult
    public func cancel() -> FlamingoTask {
        urlSessionDataTask?.cancel()
        return self
    }
}
