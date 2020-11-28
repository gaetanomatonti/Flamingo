import XCTest
@testable import Flamingo

extension BaseURL {
    static let unsecurePokeApi = BaseURL(host: "pokeapi.co", isSecure: false)
    static let pokeApi = BaseURL(host: "pokeapi.co")
}

extension Endpoint {
    static let unsecurePokemons = Endpoint(baseURL: .unsecurePokeApi, path: "/api/v2/pokemon")
    static let pokemons = Endpoint(baseURL: .pokeApi, path: "/api/v2/pokemon")
}

final class RequestTests: XCTestCase {
    
    func test_RequestFormatShouldBeCorrect() {
        let request = Request(method: .get, endpoint: .pokemons)
        
        XCTAssertNoThrow(try request.makeURL())
        XCTAssertEqual(try request.makeURL().absoluteString, "https://pokeapi.co/api/v2/pokemon")
    }
    
    func test_UnsecureRequestFormatShouldBeCorrect() {
        let request = Request(method: .get, endpoint: .unsecurePokemons)
        
        XCTAssertNoThrow(try request.makeURL())
        XCTAssertEqual(try request.makeURL().absoluteString, "http://pokeapi.co/api/v2/pokemon")
    }
    
    func test_URLRequestConversionShouldNotThrow() {
        let request = Request(method: .get, endpoint: .pokemons, queryParameters: [
            QueryParameter(key: "offset", value: 20)
        ], headers: [
            ContentType.json,
            Authentication.bearer(token: "somerandomtoken")
        ])

        XCTAssertNoThrow(try request.toURLRequest())
    }
    
    func test_AddingQueryParametersToRequest_QueryItemsShouldNotBeNil() {
        let request = Request(method: .get, endpoint: .pokemons)
            .appending(query: [
                QueryParameter(key: "offset", value: 20)
            ])
        
        XCTAssertNotNil(request.queryItems)
    }
    
    func test_AddingQueryParametersToRequest_QueryItemsCountShouldBeCorrect() {
        let request = Request(method: .get, endpoint: .pokemons)
            .appending(query: [
                QueryParameter(key: "offset", value: 20)
            ])
        
        guard let items = request.queryItems else { XCTFail("queryItems on Request should not be nil"); return }
        XCTAssertEqual(items.count, 1)
    }
    
    func test_AddingQueryParametersToRequestWithQueryParameters_QueryItemsCountShouldBeCorrect() {
        let request = Request(method: .get, endpoint: .pokemons, queryParameters: [
            QueryParameter(key: "limit", value: 20)
        ])
        .appending(query: [
            QueryParameter(key: "offset", value: 20),
            QueryParameter(key: "limit", value: 10)
        ])
        
        guard let items = request.queryItems else { XCTFail("queryItems on Request should not be nil"); return }
        XCTAssertEqual(items.count, 2)
    }
    
    func test_AddingQueryParametersToRequestWithQueryParameters_ShouldReplacedQueryItem() {
        let request = Request(method: .get, endpoint: .pokemons, queryParameters: [
            QueryParameter(key: "limit", value: 20)
        ])
        .appending(query: [
            QueryParameter(key: "offset", value: 20),
            QueryParameter(key: "limit", value: 10)
        ])
        
        guard let items = request.queryItems else { XCTFail("queryItems on Request should not be nil"); return }
        XCTAssertTrue(items.contains(URLQueryItem(name: "limit", value: "10")))
    }
    
    func test_RequestFromURL_AttributesShouldBeCorrect() {
        let request = Request(method: .get, url: URL(string: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20")!)
        
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.endpoint.baseURL.host, "pokeapi.co")
        XCTAssertEqual(request?.endpoint.path, "/api/v2/pokemon")
        XCTAssertEqual(request?.queryParameters, Set([QueryParameter(key: "offset", value: 20), QueryParameter(key: "limit", value: 20)]))
    }
    
}
