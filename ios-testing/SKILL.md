---
name: ios-testing
description: Implement comprehensive testing strategies for iOS apps. Use when writing unit tests, UI tests, integration tests, snapshot tests, setting up test coverage, mocking dependencies, or implementing TDD. Part of the idea-to-App-Store workflow between development and CI/CD.
---

# iOS Testing

Comprehensive testing strategies for robust iOS applications.

## Testing Pyramid

```
          /\
         /  \     UI Tests (10%)
        /----\    Integration Tests (20%)
       /      \   
      /--------\  Unit Tests (70%)
     /          \
```

## Unit Testing

### Setup with XCTest
```swift
import XCTest
@testable import MyApp

final class UserServiceTests: XCTestCase {
    
    var sut: UserService!  // System Under Test
    var mockNetworkService: MockNetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkService = MockNetworkService()
        sut = UserService(networkService: mockNetworkService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockNetworkService = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    func test_fetchUser_success() async throws {
        // Given
        let expectedUser = User(id: "1", name: "John")
        mockNetworkService.result = .success(expectedUser)
        
        // When
        let user = try await sut.fetchUser(id: "1")
        
        // Then
        XCTAssertEqual(user.id, "1")
        XCTAssertEqual(user.name, "John")
    }
    
    func test_fetchUser_failure() async {
        // Given
        mockNetworkService.result = .failure(NetworkError.notFound)
        
        // When/Then
        do {
            _ = try await sut.fetchUser(id: "1")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .notFound)
        }
    }
}
```

### Test Naming Conventions
```swift
// Pattern: test_[method]_[scenario]_[expectedResult]

func test_login_withValidCredentials_returnsUser() { }
func test_login_withInvalidPassword_throwsAuthError() { }
func test_calculateTotal_withEmptyCart_returnsZero() { }
func test_formatDate_withNilDate_returnsPlaceholder() { }
```

### Async Testing
```swift
// Modern async/await
func test_asyncOperation() async throws {
    let result = try await sut.fetchData()
    XCTAssertFalse(result.isEmpty)
}

// With timeout
func test_asyncWithTimeout() async throws {
    try await withTimeout(seconds: 5) {
        let result = try await sut.slowOperation()
        XCTAssertNotNil(result)
    }
}

// Combine testing
func test_publisher() {
    let expectation = expectation(description: "Publisher completes")
    var receivedValues: [String] = []
    
    sut.dataPublisher
        .sink(
            receiveCompletion: { _ in expectation.fulfill() },
            receiveValue: { receivedValues.append($0) }
        )
        .store(in: &cancellables)
    
    wait(for: [expectation], timeout: 2)
    XCTAssertEqual(receivedValues, ["expected"])
}
```

## Mocking & Dependency Injection

### Protocol-Based Mocking
```swift
// Production code
protocol UserRepositoryProtocol {
    func getUser(id: String) async throws -> User
    func saveUser(_ user: User) async throws
}

// Mock for testing
class MockUserRepository: UserRepositoryProtocol {
    var getUserResult: Result<User, Error>!
    var saveUserCalled = false
    var savedUser: User?
    
    func getUser(id: String) async throws -> User {
        switch getUserResult! {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }
    
    func saveUser(_ user: User) async throws {
        saveUserCalled = true
        savedUser = user
    }
}
```

### Dependency Injection
```swift
// Constructor injection (preferred)
class UserViewModel {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
}

// In tests
func test_example() {
    let mockRepo = MockUserRepository()
    let viewModel = UserViewModel(repository: mockRepo)
    // Test with mock
}
```

## UI Testing

### Basic UI Test
```swift
import XCTest

final class LoginUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }
    
    func test_login_withValidCredentials_showsHomeScreen() {
        // Given
        let emailField = app.textFields["email-field"]
        let passwordField = app.secureTextFields["password-field"]
        let loginButton = app.buttons["login-button"]
        
        // When
        emailField.tap()
        emailField.typeText("test@example.com")
        
        passwordField.tap()
        passwordField.typeText("password123")
        
        loginButton.tap()
        
        // Then
        XCTAssertTrue(app.staticTexts["Welcome"].waitForExistence(timeout: 5))
    }
}
```

### Accessibility Identifiers
```swift
// In production code
TextField("Email", text: $email)
    .accessibilityIdentifier("email-field")

Button("Login") { }
    .accessibilityIdentifier("login-button")
```

### Page Object Pattern
```swift
// LoginPage.swift
struct LoginPage {
    let app: XCUIApplication
    
    var emailField: XCUIElement { app.textFields["email-field"] }
    var passwordField: XCUIElement { app.secureTextFields["password-field"] }
    var loginButton: XCUIElement { app.buttons["login-button"] }
    var errorMessage: XCUIElement { app.staticTexts["error-message"] }
    
    func login(email: String, password: String) {
        emailField.tap()
        emailField.typeText(email)
        passwordField.tap()
        passwordField.typeText(password)
        loginButton.tap()
    }
}

// In test
func test_login() {
    let loginPage = LoginPage(app: app)
    loginPage.login(email: "test@example.com", password: "password")
    XCTAssertTrue(app.staticTexts["Welcome"].exists)
}
```

## Snapshot Testing

### Using swift-snapshot-testing
```swift
import SnapshotTesting
import SwiftUI
import XCTest
@testable import MyApp

final class HomeViewSnapshotTests: XCTestCase {
    
    func test_homeView_lightMode() {
        let view = HomeView()
            .preferredColorScheme(.light)
        
        assertSnapshot(
            matching: view,
            as: .image(layout: .device(config: .iPhone13Pro))
        )
    }
    
    func test_homeView_darkMode() {
        let view = HomeView()
            .preferredColorScheme(.dark)
        
        assertSnapshot(
            matching: view,
            as: .image(layout: .device(config: .iPhone13Pro))
        )
    }
    
    func test_homeView_dynamicTypeXXL() {
        let view = HomeView()
            .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
        
        assertSnapshot(
            matching: view,
            as: .image(layout: .device(config: .iPhone13Pro))
        )
    }
}
```

### Device Configurations
```swift
// Test across devices
func test_responsiveLayout() {
    let view = MyView()
    
    assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhoneSe)))
    assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone13Pro)))
    assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone13ProMax)))
    assertSnapshot(matching: view, as: .image(layout: .device(config: .iPadPro11)))
}
```

## Test Coverage

### Enable Code Coverage
```
1. Edit Scheme → Test → Options
2. Check "Gather coverage for:"
3. Select targets

# View coverage
Product → Test → Show Test Report → Coverage tab
```

### Coverage Targets
```
Recommended minimums:
- Models: 90%+
- ViewModels: 80%+
- Services: 80%+
- Utilities: 90%+
- Views: 60%+ (UI tests)

Overall target: 70-80%
```

## Testing Best Practices

### Test Isolation
```swift
// Each test should be independent
// Use setUp/tearDown for fresh state
// Never rely on test execution order

override func setUp() {
    // Create fresh instance
    sut = ViewModel()
}

override func tearDown() {
    // Clean up
    sut = nil
}
```

### Test Data Builders
```swift
// UserBuilder.swift
struct UserBuilder {
    private var id = "default-id"
    private var name = "Default User"
    private var email = "default@example.com"
    
    func withId(_ id: String) -> Self {
        var copy = self
        copy.id = id
        return copy
    }
    
    func withName(_ name: String) -> Self {
        var copy = self
        copy.name = name
        return copy
    }
    
    func build() -> User {
        User(id: id, name: name, email: email)
    }
}

// Usage
let user = UserBuilder()
    .withName("John")
    .build()
```

### Flakey Test Prevention
```swift
// Avoid:
- sleep() or fixed delays
- Real network calls
- File system dependencies
- Date/time dependencies

// Use instead:
- Proper async/await
- Mocked services
- In-memory storage
- Injected date providers
```

## Running Tests

### Command Line
```bash
# Run all tests
xcodebuild test \
    -workspace MyApp.xcworkspace \
    -scheme MyApp \
    -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test
xcodebuild test \
    -only-testing:MyAppTests/UserServiceTests/test_fetchUser_success \
    ...

# With coverage
xcodebuild test \
    -enableCodeCoverage YES \
    ...
```

### Xcode Shortcuts
```
Cmd + U           Run all tests
Ctrl + Opt + Cmd + U   Run test under cursor
Ctrl + Opt + Cmd + G   Re-run last test
```

## Test Organization

```
Tests/
├── UnitTests/
│   ├── Models/
│   │   └── UserTests.swift
│   ├── ViewModels/
│   │   └── HomeViewModelTests.swift
│   ├── Services/
│   │   └── UserServiceTests.swift
│   └── Mocks/
│       ├── MockUserRepository.swift
│       └── MockNetworkService.swift
├── IntegrationTests/
│   └── APIIntegrationTests.swift
├── SnapshotTests/
│   └── HomeViewSnapshotTests.swift
└── UITests/
    ├── Pages/
    │   └── LoginPage.swift
    └── Flows/
        └── LoginFlowTests.swift
```

## Resources

See [references/testing-patterns.md](references/testing-patterns.md) for advanced patterns.
See [references/tdd-guide.md](references/tdd-guide.md) for TDD workflow.
