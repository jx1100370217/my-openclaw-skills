---
name: ios-swiftui-development
description: Build modern iOS apps with SwiftUI. Use when creating UI components, implementing navigation, handling state management, building lists/forms, adding animations, or integrating with UIKit. Covers SwiftUI best practices, common patterns, and performance optimization for iOS/iPadOS/macOS/watchOS/visionOS.
---

# iOS SwiftUI Development

Build beautiful, performant iOS applications using SwiftUI's declarative syntax.

## Quick Reference

### View Basics

```swift
struct ContentView: View {
    @State private var count = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Count: \(count)")
                .font(.title)
            Button("Increment") { count += 1 }
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
```

### Property Wrappers

| Wrapper | Use Case |
|---------|----------|
| `@State` | Local view state (value types) |
| `@Binding` | Two-way connection to parent state |
| `@StateObject` | Own an ObservableObject |
| `@ObservedObject` | Reference external ObservableObject |
| `@EnvironmentObject` | Shared data through view hierarchy |
| `@Environment` | System values (colorScheme, locale) |
| `@AppStorage` | UserDefaults persistence |
| `@FocusState` | Keyboard focus management |

### Navigation (iOS 16+)

```swift
// NavigationStack with typed destinations
NavigationStack {
    List(items) { item in
        NavigationLink(value: item) {
            Text(item.title)
        }
    }
    .navigationDestination(for: Item.self) { item in
        DetailView(item: item)
    }
}

// Programmatic navigation
@State private var path = NavigationPath()

NavigationStack(path: $path) {
    Button("Go to Detail") {
        path.append(someItem)
    }
}
```

### Lists & Grids

```swift
// Dynamic List
List(items) { item in
    ItemRow(item: item)
}
.listStyle(.insetGrouped)

// LazyVGrid
LazyVGrid(columns: [
    GridItem(.flexible()),
    GridItem(.flexible())
], spacing: 16) {
    ForEach(items) { item in
        ItemCard(item: item)
    }
}
```

### Async Data Loading

```swift
struct AsyncContentView: View {
    @State private var data: [Item] = []
    @State private var isLoading = false
    
    var body: some View {
        List(data) { item in
            Text(item.name)
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
        .task {
            isLoading = true
            data = await fetchData()
            isLoading = false
        }
        .refreshable {
            data = await fetchData()
        }
    }
}
```

### Animations

```swift
// Implicit animation
Text("Hello")
    .scaleEffect(isExpanded ? 1.5 : 1.0)
    .animation(.spring(response: 0.3), value: isExpanded)

// Explicit animation
withAnimation(.easeInOut(duration: 0.3)) {
    isExpanded.toggle()
}

// Transition
if showDetail {
    DetailView()
        .transition(.move(edge: .trailing).combined(with: .opacity))
}
```

### Custom Modifiers

```swift
struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
            .shadow(radius: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}
```

## Common Patterns

### MVVM with ObservableObject

```swift
@MainActor
class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    func loadItems() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            items = try await apiService.fetchItems()
        } catch {
            self.error = error
        }
    }
}

struct ItemListView: View {
    @StateObject private var viewModel = ItemViewModel()
    
    var body: some View {
        List(viewModel.items) { item in
            Text(item.name)
        }
        .task { await viewModel.loadItems() }
    }
}
```

### Dependency Injection

```swift
// Environment key
struct APIServiceKey: EnvironmentKey {
    static let defaultValue: APIService = LiveAPIService()
}

extension EnvironmentValues {
    var apiService: APIService {
        get { self[APIServiceKey.self] }
        set { self[APIServiceKey.self] = newValue }
    }
}

// Usage
@Environment(\.apiService) var apiService
```

## Performance Tips

1. **Use `@ViewBuilder` wisely** - Avoid complex logic in body
2. **Prefer `LazyVStack`/`LazyHStack`** for long lists
3. **Use `equatable()` modifier** to prevent unnecessary redraws
4. **Extract subviews** to isolate state changes
5. **Use `task(id:)` for cancellable async work**

## Resources

See [references/swiftui-components.md](references/swiftui-components.md) for component catalog.
See [references/swiftui-tips.md](references/swiftui-tips.md) for advanced tips.

## External Links

- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Hacking with Swift](https://www.hackingwithswift.com/quick-start/swiftui)
- [SwiftUI Lab](https://swiftui-lab.com)
- [Point-Free TCA](https://github.com/pointfreeco/swift-composable-architecture)
