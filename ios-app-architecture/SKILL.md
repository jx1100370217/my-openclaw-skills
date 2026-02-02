---
name: ios-app-architecture
description: Design scalable iOS app architectures. Use when setting up project structure, implementing MVVM/TCA/VIPER patterns, managing dependencies, organizing modules, or designing data flow. Covers clean architecture, composition, testing strategies, and modularization for maintainable iOS apps.
---

# iOS App Architecture

Design and implement scalable, testable, and maintainable iOS applications.

## Architecture Patterns

### MVVM (Recommended for SwiftUI)

```
View ←→ ViewModel ←→ Model
         ↓
      Services
```

```swift
// Model
struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
}

// ViewModel
@MainActor
class UserViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var state: ViewState = .idle
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func loadUsers() async {
        state = .loading
        do {
            users = try await userService.fetchUsers()
            state = .loaded
        } catch {
            state = .error(error)
        }
    }
}

// View
struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
            case .loaded:
                List(viewModel.users) { user in
                    UserRow(user: user)
                }
            case .error(let error):
                ErrorView(error: error)
            }
        }
        .task { await viewModel.loadUsers() }
    }
}
```

### The Composable Architecture (TCA)

Best for complex apps needing predictable state management.

```swift
import ComposableArchitecture

@Reducer
struct UserFeature {
    @ObservableState
    struct State: Equatable {
        var users: [User] = []
        var isLoading = false
    }
    
    enum Action {
        case loadUsers
        case usersResponse(Result<[User], Error>)
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadUsers:
                state.isLoading = true
                return .run { send in
                    await send(.usersResponse(
                        Result { try await userClient.fetchUsers() }
                    ))
                }
            case .usersResponse(.success(let users)):
                state.isLoading = false
                state.users = users
                return .none
            case .usersResponse(.failure):
                state.isLoading = false
                return .none
            }
        }
    }
}
```

## Project Structure

```
MyApp/
├── App/
│   ├── MyAppApp.swift
│   └── AppDelegate.swift
├── Features/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeViewModel.swift
│   │   └── Components/
│   ├── Profile/
│   └── Settings/
├── Core/
│   ├── Models/
│   ├── Services/
│   │   ├── Networking/
│   │   └── Persistence/
│   └── Utilities/
├── UI/
│   ├── Components/
│   ├── Styles/
│   └── Extensions/
└── Resources/
    ├── Assets.xcassets
    └── Localizable.strings
```

## Dependency Injection

### Protocol-Based DI

```swift
// Protocol
protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
}

// Live Implementation
class UserService: UserServiceProtocol {
    func fetchUsers() async throws -> [User] {
        // Real API call
    }
}

// Mock for Testing
class MockUserService: UserServiceProtocol {
    var usersToReturn: [User] = []
    
    func fetchUsers() async throws -> [User] {
        usersToReturn
    }
}
```

### Environment-Based DI

```swift
// Dependency Container
class Dependencies: ObservableObject {
    let userService: UserServiceProtocol
    let analyticsService: AnalyticsProtocol
    
    init(
        userService: UserServiceProtocol = UserService(),
        analyticsService: AnalyticsProtocol = AnalyticsService()
    ) {
        self.userService = userService
        self.analyticsService = analyticsService
    }
    
    static let preview = Dependencies(
        userService: MockUserService(),
        analyticsService: MockAnalyticsService()
    )
}

// Usage
@main
struct MyApp: App {
    @StateObject private var dependencies = Dependencies()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dependencies)
        }
    }
}
```

## Modularization

### Swift Package Structure

```
Packages/
├── Core/
│   └── Package.swift
├── Networking/
│   └── Package.swift
├── FeatureHome/
│   └── Package.swift
└── DesignSystem/
    └── Package.swift
```

```swift
// Package.swift
let package = Package(
    name: "FeatureHome",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "FeatureHome", targets: ["FeatureHome"])
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../DesignSystem")
    ],
    targets: [
        .target(
            name: "FeatureHome",
            dependencies: ["Core", "DesignSystem"]
        ),
        .testTarget(
            name: "FeatureHomeTests",
            dependencies: ["FeatureHome"]
        )
    ]
)
```

## Testing Strategy

### Unit Tests
```swift
@Test
func testUserViewModel() async {
    let mockService = MockUserService()
    mockService.usersToReturn = [User(id: UUID(), name: "Test", email: "test@test.com")]
    
    let viewModel = UserViewModel(userService: mockService)
    await viewModel.loadUsers()
    
    #expect(viewModel.users.count == 1)
    #expect(viewModel.state == .loaded)
}
```

### Snapshot Tests
```swift
import SnapshotTesting

func testUserRowSnapshot() {
    let view = UserRow(user: .preview)
    assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
}
```

## Best Practices

1. **Single Responsibility** - Each component does one thing well
2. **Dependency Inversion** - Depend on abstractions, not implementations
3. **Composition over Inheritance** - Prefer protocols and structs
4. **Unidirectional Data Flow** - State flows down, actions flow up
5. **Testability First** - Design for testing from the start

## Resources

See [references/architecture-patterns.md](references/architecture-patterns.md) for detailed patterns.
See [references/testing-guide.md](references/testing-guide.md) for testing strategies.
