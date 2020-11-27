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
        
        XCTAssertNoThrow(try request.url())
        XCTAssertEqual(try request.url().absoluteString, "https://pokeapi.co/api/v2/pokemon")
    }
    
    func test_UnsecureRequestFormatShouldBeCorrect() {
        let request = Request(method: .get, endpoint: .unsecurePokemons)
        
        XCTAssertNoThrow(try request.url())
        XCTAssertEqual(try request.url().absoluteString, "http://pokeapi.co/api/v2/pokemon")
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
            .adding(query: [
                QueryParameter(key: "offset", value: 20)
            ])
        
        XCTAssertNotNil(request.queryItems)
    }
    
    func test_AddingQueryParametersToRequest_QueryItemsCountShouldBeCorrect() {
        let request = Request(method: .get, endpoint: .pokemons)
            .adding(query: [
                QueryParameter(key: "offset", value: 20)
            ])
        
        guard let items = request.queryItems else { XCTFail("queryItems on Request should not be nil"); return }
        XCTAssertEqual(items.count, 1)
    }
    
    func test_AddingQueryParametersToRequestWithQueryParameters_QueryItemsCountShouldBeCorrect() {
        let request = Request(method: .get, endpoint: .pokemons, queryParameters: [
            QueryParameter(key: "limit", value: 20)
        ])
        .adding(query: [
            QueryParameter(key: "offset", value: 20)
        ])
        
        guard let items = request.queryItems else { XCTFail("queryItems on Request should not be nil"); return }
        XCTAssertEqual(items.count, 2)
    }
    
}
