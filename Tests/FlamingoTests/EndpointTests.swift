import XCTest
@testable import Flamingo

final class EndpointTests: XCTestCase {
    
    func test_AfterInitialization_PathFormatShouldBeCorrect() {
        let endpoint = Endpoint(baseURL: BaseURL(host: "host.com"), path: "api")
        
        XCTAssertEqual(endpoint.path, "/api")
    }
    
}
