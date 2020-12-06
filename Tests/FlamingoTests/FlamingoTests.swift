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
        let task = FlamingoTask(request: request)
        
        XCTAssertNoThrow(try task.decode([User].self, completion: { _ in }))
    }
    
    func testCodableTaskRequestShouldExecuteCorrectly() throws {
        // Given
        let request = Request(method: .get, endpoint: .users)
        let expectation = XCTestExpectation(description: "Request should execute correctly")
        let task = try FlamingoTask(request: request).decode([User].self, completion: { result in
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
        task.start()
        
        wait(for: [expectation], timeout: 5)
    }
    
}
