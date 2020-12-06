import XCTest
@testable import Flamingo

fileprivate extension BaseURL {
    static let jsonPlaceholder = BaseURL(host: "jsonplaceholder.typicode.com")
}

fileprivate extension Endpoint {
    static let users = Endpoint(baseURL: .jsonPlaceholder, path: "/users")
}

fileprivate struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
}

final class FlamingoTests: XCTestCase {
    
    func testCodableTaskWithCorrectRequestShouldNotThrow() {
        let request = Request(method: .get, endpoint: .users)
        XCTAssertNoThrow(try Flamingo.codableTask(request, responseType: [User].self) { _ in })
    }
    
    func testCodableTaskRequestShouldExecuteCorrectly() throws {
        // Given
        let request = Request(method: .get, endpoint: .users)
        let expectation = XCTestExpectation(description: "Reqeust should execute correctly")
        let task = try Flamingo.codableTask(request, responseType: [User].self, completion: { result in
            // Then
            switch result {
                case .success(let users):
                    XCTAssertEqual(users.count, 10)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        })
        
        // When
        task.resume()
        
        wait(for: [expectation], timeout: 10.0)
    }
    
}
