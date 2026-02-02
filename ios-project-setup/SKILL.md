---
name: ios-project-setup
description: Initialize and configure iOS/SwiftUI projects with best practices. Use when creating new Xcode projects, setting up project structure, configuring dependencies (SPM), setting up git, configuring build settings, or establishing coding standards. Fifth step in the idea-to-App-Store workflow after UI/UX design.
---

# iOS Project Setup

Set up a well-structured iOS project with modern best practices.

## Quick Start

### Create New Project

```bash
# Using Xcode (recommended)
1. File → New → Project
2. iOS → App
3. Configure:
   - Product Name: [AppName]
   - Organization Identifier: com.yourcompany
   - Interface: SwiftUI
   - Language: Swift
   - Storage: SwiftData (or Core Data)
   - Include Tests: ✅
```

## Project Structure

### Recommended Folder Structure

```
[AppName]/
├── App/
│   ├── [AppName]App.swift         # App entry point
│   └── AppDelegate.swift          # If needed for push, etc.
├── Features/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeViewModel.swift
│   │   └── Components/
│   │       └── HomeCard.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   └── SettingsViewModel.swift
│   └── Onboarding/
│       └── OnboardingView.swift
├── Core/
│   ├── Models/
│   │   └── User.swift
│   ├── Services/
│   │   ├── AuthService.swift
│   │   └── NetworkService.swift
│   └── Utilities/
│       ├── Extensions/
│       │   ├── View+Extensions.swift
│       │   └── Date+Extensions.swift
│       └── Helpers/
│           └── Validator.swift
├── UI/
│   ├── Components/
│   │   ├── PrimaryButton.swift
│   │   └── LoadingView.swift
│   ├── Styles/
│   │   └── ButtonStyles.swift
│   └── Theme/
│       ├── Colors.swift
│       └── Typography.swift
├── Resources/
│   ├── Assets.xcassets/
│   ├── Localizable.xcstrings
│   └── Info.plist
└── Tests/
    ├── [AppName]Tests/
    └── [AppName]UITests/
```

### Xcode Groups Setup
```bash
# Create folder structure (run in project directory)
mkdir -p App Features Core/{Models,Services,Utilities/{Extensions,Helpers}} \
         UI/{Components,Styles,Theme} Resources
```

## Dependencies (Swift Package Manager)

### Essential Packages

```swift
// Package.swift dependencies or via Xcode:
// File → Add Packages...

// Networking
https://github.com/Alamofire/Alamofire.git          // HTTP networking
https://github.com/Moya/Moya.git                    // Network abstraction

// Architecture
https://github.com/pointfreeco/swift-composable-architecture.git  // TCA

// UI
https://github.com/airbnb/lottie-ios.git           // Animations
https://github.com/onevcat/Kingfisher.git          // Image loading

// Storage
https://github.com/realm/realm-swift.git           // Realm database

// Analytics/Monitoring
https://github.com/firebase/firebase-ios-sdk.git   // Firebase

// Utilities
https://github.com/SwiftyJSON/SwiftyJSON.git       // JSON parsing
https://github.com/apple/swift-algorithms.git      // Swift algorithms
```

### Adding Packages in Xcode
```
1. File → Add Packages...
2. Enter package URL
3. Set version rules (Up to Next Major recommended)
4. Select target(s)
5. Add Package
```

## Build Configuration

### Schemes Setup
```
[AppName] (Development)
├── Debug: Development server, verbose logging
└── Release: Development server, optimized

[AppName] Staging
├── Debug: Staging server, verbose logging
└── Release: Staging server, optimized

[AppName] Production
├── Debug: Production server, verbose logging
└── Release: Production server, optimized
```

### Configuration Files
```swift
// Config.swift
enum Config {
    enum Environment {
        case development
        case staging
        case production
    }
    
    static var current: Environment {
        #if DEBUG
        return .development
        #elseif STAGING
        return .staging
        #else
        return .production
        #endif
    }
    
    static var apiBaseURL: String {
        switch current {
        case .development: return "https://dev-api.example.com"
        case .staging: return "https://staging-api.example.com"
        case .production: return "https://api.example.com"
        }
    }
}
```

### Build Settings
```
// Essential Build Settings

// Swift Compiler - Custom Flags
OTHER_SWIFT_FLAGS = -D DEBUG (Debug configuration)
OTHER_SWIFT_FLAGS = -D STAGING (Staging configuration)

// Asset Catalog Compiler
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon

// Versioning
CURRENT_PROJECT_VERSION = 1
MARKETING_VERSION = 1.0.0
```

## Git Setup

### .gitignore
```gitignore
# Xcode
*.xcuserstate
*.xccheckout
*.moved-aside
DerivedData/
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# Swift Package Manager
.build/
.swiftpm/
Packages/

# CocoaPods (if used)
Pods/

# Carthage (if used)
Carthage/Build/

# Fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output/

# Other
*.DS_Store
*.log
xcuserdata/

# Secrets (NEVER commit)
*.p8
*.p12
*.mobileprovision
**/Secrets.swift
.env*
```

### Git Hooks (pre-commit)
```bash
#!/bin/sh
# .git/hooks/pre-commit

# Run SwiftLint
if which swiftlint >/dev/null; then
  swiftlint --strict
else
  echo "warning: SwiftLint not installed"
fi

# Run SwiftFormat
if which swiftformat >/dev/null; then
  swiftformat --lint .
fi
```

## Code Quality

### SwiftLint Configuration
```yaml
# .swiftlint.yml
disabled_rules:
  - trailing_whitespace
  - line_length

opt_in_rules:
  - empty_count
  - closure_end_indentation
  - closure_spacing
  - collection_alignment
  - contains_over_filter_count
  - contains_over_filter_is_empty
  - empty_string
  - first_where
  - force_unwrapping
  - implicitly_unwrapped_optional
  - last_where
  - modifier_order
  - overridden_super_call
  - pattern_matching_keywords
  - private_action
  - private_outlet
  - prohibited_super_call
  - redundant_nil_coalescing
  - single_test_class
  - sorted_first_last
  - toggle_bool
  - unavailable_function
  - unneeded_parentheses_in_closure_argument

excluded:
  - Pods
  - Carthage
  - DerivedData

line_length:
  warning: 120
  error: 200

type_body_length:
  warning: 300
  error: 500

file_length:
  warning: 500
  error: 1000

identifier_name:
  min_length: 2
  max_length: 50
```

### SwiftFormat Configuration
```yaml
# .swiftformat
--indent 4
--indentcase false
--trimwhitespace always
--voidtype void
--self remove
--header strip
--maxwidth 120
--wraparguments before-first
--wrapparameters before-first
--wrapcollections before-first
--closingparen same-line
```

## Essential Files

### App Entry Point
```swift
// [AppName]App.swift
import SwiftUI

@main
struct MyApp: App {
    // App-level services
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
```

### Theme Colors
```swift
// UI/Theme/Colors.swift
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color(.systemBackground)
    let secondaryBackground = Color(.secondarySystemBackground)
    let primaryText = Color(.label)
    let secondaryText = Color(.secondaryLabel)
    
    // Custom colors
    let success = Color("Success")
    let warning = Color("Warning")
    let error = Color("Error")
}
```

### Network Service Template
```swift
// Core/Services/NetworkService.swift
import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let (data, response) = try await session.data(for: endpoint.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        return try decoder.decode(T.self, from: data)
    }
}
```

## Initial Checklist

### Before First Commit
- [ ] Project structure created
- [ ] .gitignore configured
- [ ] SwiftLint installed and configured
- [ ] SwiftFormat configured
- [ ] Initial README.md created
- [ ] License file added
- [ ] Build configurations set up
- [ ] Signing configured (team, bundle ID)
- [ ] App icon placeholder added

### Before Development
- [ ] Git repository initialized
- [ ] CI/CD pipeline configured
- [ ] Essential dependencies added
- [ ] Theme/design system set up
- [ ] Network layer scaffolded
- [ ] Error handling approach defined
- [ ] Logging system in place

## Resources

See [assets/xcode-templates/](assets/xcode-templates/) for file templates.
See [references/dependencies-guide.md](references/dependencies-guide.md) for package recommendations.
