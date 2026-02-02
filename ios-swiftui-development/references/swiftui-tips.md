# SwiftUI Advanced Tips

## Performance Optimization

### 1. Avoid Recomputation
```swift
// ❌ Bad - recomputes on every render
var body: some View {
    List(items.sorted()) { item in ... }
}

// ✅ Good - compute outside body
let sortedItems = items.sorted()
var body: some View {
    List(sortedItems) { item in ... }
}
```

### 2. Use Equatable Views
```swift
struct ExpensiveView: View, Equatable {
    let data: SomeData
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.data.id == rhs.data.id
    }
    
    var body: some View { ... }
}

// Usage
ExpensiveView(data: data)
    .equatable()
```

### 3. Lazy Loading
```swift
// Use LazyVStack for long lists
ScrollView {
    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
        ForEach(sections) { section in
            Section(header: SectionHeader(section)) {
                ForEach(section.items) { item in
                    ItemRow(item: item)
                }
            }
        }
    }
}
```

## State Management

### Derived Bindings
```swift
// Create binding from optional
func binding(for item: Item) -> Binding<Bool> {
    Binding(
        get: { selectedItem?.id == item.id },
        set: { if $0 { selectedItem = item } }
    )
}
```

### Task Cancellation
```swift
@State private var task: Task<Void, Never>?

var body: some View {
    List { ... }
        .onAppear {
            task = Task {
                await loadData()
            }
        }
        .onDisappear {
            task?.cancel()
        }
}
```

## Debugging

### View Identity
```swift
// Track view updates
let _ = Self._printChanges()

// In body:
var body: some View {
    let _ = print("ContentView body called")
    // ...
}
```

### Preview Variants
```swift
#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}

#Preview("Large Text") {
    ContentView()
        .dynamicTypeSize(.accessibility3)
}
```

## Common Gotchas

### 1. NavigationLink in List
```swift
// ❌ Initializes all destinations
List(items) { item in
    NavigationLink {
        ExpensiveDetailView(item: item) // Created immediately!
    } label: {
        Text(item.name)
    }
}

// ✅ Lazy destination (iOS 16+)
List(items) { item in
    NavigationLink(value: item) {
        Text(item.name)
    }
}
.navigationDestination(for: Item.self) { item in
    ExpensiveDetailView(item: item)
}
```

### 2. Keyboard Avoidance
```swift
// Disable automatic keyboard avoidance
.ignoresSafeArea(.keyboard)

// Custom keyboard handling
@FocusState private var focused: Bool

TextField("Input", text: $text)
    .focused($focused)
    .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") { focused = false }
        }
    }
```

### 3. Safe Area
```swift
// Extend content to edges
.ignoresSafeArea(edges: .bottom)

// Read safe area
GeometryReader { proxy in
    let safeArea = proxy.safeAreaInsets
    // Use safeArea.top, .bottom, etc.
}
```

## iOS 17+ Features

### Observable Macro
```swift
@Observable
class Store {
    var items: [Item] = []
    var isLoading = false
}

// No need for @Published or ObservableObject
struct ContentView: View {
    var store = Store()
    
    var body: some View {
        List(store.items) { ... }
    }
}
```

### Sensory Feedback
```swift
@State private var trigger = false

Button("Tap") {
    trigger.toggle()
}
.sensoryFeedback(.impact, trigger: trigger)
```

### Scroll Transitions
```swift
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ItemCard(item: item)
                .scrollTransition { content, phase in
                    content
                        .opacity(phase.isIdentity ? 1 : 0.5)
                        .scaleEffect(phase.isIdentity ? 1 : 0.9)
                }
        }
    }
}
```
