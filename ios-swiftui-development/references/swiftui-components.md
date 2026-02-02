# SwiftUI Components Catalog

## Input Controls

### TextField
```swift
@State private var text = ""
@FocusState private var isFocused: Bool

TextField("Placeholder", text: $text)
    .textFieldStyle(.roundedBorder)
    .focused($isFocused)
    .onSubmit { handleSubmit() }
```

### SecureField
```swift
SecureField("Password", text: $password)
    .textContentType(.password)
```

### TextEditor
```swift
TextEditor(text: $longText)
    .frame(minHeight: 100)
    .overlay(
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray.opacity(0.2))
    )
```

### Picker
```swift
// Segmented
Picker("Option", selection: $selected) {
    Text("A").tag(0)
    Text("B").tag(1)
}
.pickerStyle(.segmented)

// Menu
Picker("Select", selection: $selected) {
    ForEach(options) { option in
        Text(option.name).tag(option)
    }
}
.pickerStyle(.menu)
```

### Toggle & Slider
```swift
Toggle("Enable", isOn: $isEnabled)
    .toggleStyle(.switch)

Slider(value: $value, in: 0...100, step: 1) {
    Text("Volume")
} minimumValueLabel: {
    Image(systemName: "speaker")
} maximumValueLabel: {
    Image(systemName: "speaker.wave.3")
}
```

## Layout

### Stacks
```swift
// Adaptive spacing
VStack(alignment: .leading, spacing: 12) {
    // ...
}

// Priority
HStack {
    Text("Fixed")
    Spacer()
    Text("Flexible")
        .layoutPriority(1)
}
```

### Grid (iOS 16+)
```swift
Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 8) {
    GridRow {
        Text("Name:")
        Text(user.name)
    }
    GridRow {
        Text("Email:")
        Text(user.email)
            .gridCellColumns(2)
    }
}
```

### GeometryReader
```swift
GeometryReader { proxy in
    VStack {
        Text("Width: \(proxy.size.width)")
        Text("Safe Area: \(proxy.safeAreaInsets.top)")
    }
}
```

## Containers

### Sheet
```swift
.sheet(isPresented: $showSheet) {
    SheetContent()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
}

// Item-based
.sheet(item: $selectedItem) { item in
    DetailView(item: item)
}
```

### Alert & Confirmation
```swift
.alert("Title", isPresented: $showAlert) {
    Button("Cancel", role: .cancel) { }
    Button("Delete", role: .destructive) { delete() }
} message: {
    Text("Are you sure?")
}

.confirmationDialog("Choose", isPresented: $showDialog) {
    Button("Option 1") { }
    Button("Option 2") { }
}
```

### Menu & Context Menu
```swift
Menu("Actions") {
    Button("Edit", action: edit)
    Button("Share", action: share)
    Divider()
    Button("Delete", role: .destructive, action: delete)
}

.contextMenu {
    Button("Copy") { }
    Button("Paste") { }
}
```

## Images

### AsyncImage
```swift
AsyncImage(url: imageURL) { phase in
    switch phase {
    case .empty:
        ProgressView()
    case .success(let image):
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
    case .failure:
        Image(systemName: "photo")
            .foregroundColor(.gray)
    @unknown default:
        EmptyView()
    }
}
.frame(width: 100, height: 100)
.clipShape(RoundedRectangle(cornerRadius: 8))
```

### SF Symbols
```swift
Image(systemName: "star.fill")
    .symbolRenderingMode(.hierarchical)
    .foregroundStyle(.yellow)
    .font(.system(size: 24))

// Variable color (iOS 17+)
Image(systemName: "wifi", variableValue: signalStrength)
```

## Advanced

### ViewThatFits
```swift
ViewThatFits {
    HStack { /* Wide layout */ }
    VStack { /* Narrow layout */ }
}
```

### ContentUnavailableView (iOS 17+)
```swift
if items.isEmpty {
    ContentUnavailableView {
        Label("No Items", systemImage: "tray")
    } description: {
        Text("Add items to get started")
    } actions: {
        Button("Add Item") { }
    }
}
```

### ScrollViewReader
```swift
ScrollViewReader { proxy in
    ScrollView {
        ForEach(messages) { message in
            MessageRow(message: message)
                .id(message.id)
        }
    }
    .onChange(of: messages.count) {
        withAnimation {
            proxy.scrollTo(messages.last?.id, anchor: .bottom)
        }
    }
}
```
