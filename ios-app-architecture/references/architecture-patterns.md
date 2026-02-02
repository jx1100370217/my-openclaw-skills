# iOS Architecture Patterns Deep Dive

## Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│    (Views, ViewModels, Coordinators)    │
├─────────────────────────────────────────┤
│            Domain Layer                 │
│  (Use Cases, Entities, Repositories)    │
├─────────────────────────────────────────┤
│             Data Layer                  │
│ (API, Database, Repository Impl)        │
└─────────────────────────────────────────┘
```

## Coordinator Pattern

Handles navigation logic separately from views.

```swift
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}
```

## Repository Pattern

Abstracts data access.

```swift
protocol UserRepository {
    func getUsers() async throws -> [User]
    func getUser(id: UUID) async throws -> User
    func saveUser(_ user: User) async throws
}

class UserRepositoryImpl: UserRepository {
    private let apiClient: APIClient
    private let database: Database
    
    func getUsers() async throws -> [User] {
        // Try local first, then remote
        if let cached = try? await database.fetchUsers(), !cached.isEmpty {
            return cached
        }
        let remote = try await apiClient.fetchUsers()
        try await database.saveUsers(remote)
        return remote
    }
}
```

## Use Case Pattern

Encapsulates business logic.

```swift
protocol GetUsersUseCase {
    func execute() async throws -> [User]
}

class GetUsersUseCaseImpl: GetUsersUseCase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [User] {
        let users = try await repository.getUsers()
        return users.filter { $0.isActive }.sorted { $0.name < $1.name }
    }
}
```

## State Machine

Manage view states predictably.

```swift
enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var data: T? {
        if case .loaded(let data) = self { return data }
        return nil
    }
}
```

## Event-Driven Communication

```swift
// Using Combine
class EventBus {
    static let shared = EventBus()
    
    let userUpdated = PassthroughSubject<User, Never>()
    let sessionExpired = PassthroughSubject<Void, Never>()
}

// Subscribe
eventBus.userUpdated
    .receive(on: DispatchQueue.main)
    .sink { user in
        // Handle update
    }
    .store(in: &cancellables)
```

## Feature Flags

```swift
protocol FeatureFlagService {
    func isEnabled(_ flag: FeatureFlag) -> Bool
}

enum FeatureFlag: String {
    case newOnboarding
    case betaFeature
    case darkModeDefault
}

// Usage in View
if featureFlags.isEnabled(.newOnboarding) {
    NewOnboardingView()
} else {
    LegacyOnboardingView()
}
```
