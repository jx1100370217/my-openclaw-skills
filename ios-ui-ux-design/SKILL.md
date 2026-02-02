---
name: ios-ui-ux-design
description: Design iOS app interfaces following Apple Human Interface Guidelines (HIG). Use when creating UI designs, defining design systems, planning user flows, selecting colors/typography, designing for accessibility, or ensuring iOS platform consistency. Fourth step in the idea-to-App-Store workflow.
---

# iOS UI/UX Design

Design beautiful, intuitive iOS apps following Apple's Human Interface Guidelines.

## Design Principles

### Apple's Core Principles
1. **Aesthetic Integrity** - Appearance matches function
2. **Consistency** - Familiar patterns and behaviors
3. **Direct Manipulation** - Engage with content, not controls
4. **Feedback** - Acknowledge every action
5. **Metaphors** - Build on familiar experiences
6. **User Control** - Users initiate and control actions

## Design System

### Color Palette

```swift
// System Colors (adapt to light/dark mode)
Color.primary      // Label text
Color.secondary    // Secondary text
Color.accentColor  // Tint, buttons
Color(.systemBackground)
Color(.secondarySystemBackground)
Color(.tertiarySystemBackground)

// Semantic Colors
Color.red          // Destructive actions
Color.green        // Success, positive
Color.blue         // Links, primary actions
Color.orange       // Warnings
Color.yellow       // Highlights
```

### Typography Scale

| Style | Size | Weight | Use Case |
|-------|------|--------|----------|
| Large Title | 34pt | Bold | Screen titles |
| Title 1 | 28pt | Bold | Section headers |
| Title 2 | 22pt | Bold | Subsections |
| Title 3 | 20pt | Semibold | Card titles |
| Headline | 17pt | Semibold | List headers |
| Body | 17pt | Regular | Main content |
| Callout | 16pt | Regular | Secondary content |
| Subheadline | 15pt | Regular | Supporting text |
| Footnote | 13pt | Regular | Captions |
| Caption 1 | 12pt | Regular | Labels |
| Caption 2 | 11pt | Regular | Timestamps |

```swift
// SwiftUI Usage
Text("Title").font(.largeTitle)
Text("Body").font(.body)
Text("Caption").font(.caption)
```

### Spacing System

```
4pt  - Minimal spacing
8pt  - Tight spacing (related elements)
12pt - Default compact
16pt - Standard spacing
20pt - Comfortable spacing  
24pt - Section spacing
32pt - Large gaps
```

### Corner Radius

| Element | Radius |
|---------|--------|
| Small buttons | 8pt |
| Cards | 12pt |
| Modals | 16pt |
| Large cards | 20pt |
| Continuous (iOS) | Use `.continuous` |

## Screen Patterns

### Navigation Patterns

```
Tab Bar (3-5 items)
├── Best for: Primary destinations
├── Always visible at bottom
└── Icons + Labels recommended

Navigation Stack
├── Best for: Hierarchical content
├── Back button auto-added
└── Large titles collapse on scroll

Sidebar (iPad)
├── Best for: Document apps
├── Collapsible on compact width
└── Primary/Detail split view
```

### Common Screens

#### Onboarding
```
Page 1: Value proposition (benefit-focused)
Page 2: Key feature highlight
Page 3: Key feature highlight  
Page 4: Permissions/Sign up CTA

Design Tips:
- 3-5 pages maximum
- Skip button visible
- Progress indicator
- Illustrations > screenshots
```

#### Lists
```swift
// Standard List Row
HStack {
    Image(systemName: "icon")
        .frame(width: 30)
    VStack(alignment: .leading) {
        Text("Title").font(.body)
        Text("Subtitle").font(.caption).foregroundColor(.secondary)
    }
    Spacer()
    Image(systemName: "chevron.right")
        .foregroundColor(.secondary)
}
.padding(.vertical, 8)
```

#### Forms
```
- Group related fields
- Use Section headers
- Show validation inline
- Keyboard type per field
- Next/Done toolbar buttons
```

#### Empty States
```
Components:
- Illustration (SF Symbol or custom)
- Title (what's missing)
- Description (how to fix)
- Action button (primary CTA)

Tone: Helpful, not critical
```

## iOS-Specific Patterns

### Safe Areas
```swift
// Respect safe areas for:
- Top (notch, Dynamic Island)
- Bottom (home indicator)
- Keyboard avoiding

// Extend to edges for:
- Full-screen images
- Tab bar backgrounds
- Navigation bar backgrounds
```

### Touch Targets
```
Minimum: 44x44 points
Recommended: 48x48 points
Spacing between: 8pt minimum
```

### Gestures
| Gesture | Common Use |
|---------|------------|
| Tap | Primary action |
| Long press | Context menu |
| Swipe | Delete, actions |
| Pull down | Refresh |
| Pinch | Zoom |
| Edge swipe | Back navigation |

### Haptics
```swift
// Use sparingly for:
- Button taps
- Toggle changes
- Success/error feedback
- Picker selection

// Types:
UIImpactFeedbackGenerator(.light)    // Subtle
UIImpactFeedbackGenerator(.medium)   // Standard  
UIImpactFeedbackGenerator(.heavy)    // Emphasized
UINotificationFeedbackGenerator()    // Success/warning/error
UISelectionFeedbackGenerator()       // Selection changes
```

## Accessibility

### Requirements Checklist
- [ ] VoiceOver labels for all interactive elements
- [ ] Dynamic Type support (all text scales)
- [ ] Sufficient color contrast (4.5:1 for text)
- [ ] No color-only information
- [ ] Reduce Motion alternative animations
- [ ] Bold Text support
- [ ] Button Shapes support

### Accessibility Implementation
```swift
// VoiceOver
Text("Send")
    .accessibilityLabel("Send message")
    .accessibilityHint("Double tap to send your message")

// Dynamic Type
Text("Scales")
    .font(.body)  // Automatically scales

// Fixed size (use sparingly)
Text("Fixed")
    .dynamicTypeSize(.large)
```

## Dark Mode

### Design Considerations
```
Light Mode          Dark Mode
-----------         ----------
White bg     →      System black
Black text   →      White text
Gray 100     →      Gray 900
Vibrant colors →    Desaturated colors
Drop shadows →      Inner shadows/borders
```

### Testing Checklist
- [ ] All text readable in both modes
- [ ] Images work in both modes (use template images)
- [ ] No pure white on dark mode (use system colors)
- [ ] Sufficient contrast maintained
- [ ] Custom colors adapt properly

## Design Handoff

### Asset Export

| Asset Type | Formats | Sizes |
|------------|---------|-------|
| App Icon | PNG | 1024x1024 (App Store) |
| SF Symbols | N/A | Use system |
| Custom Icons | PDF (vector) | @1x, @2x, @3x |
| Images | PNG/JPEG | @1x, @2x, @3x |

### Figma/Sketch Handoff
```
Include:
- Component specifications
- Spacing annotations  
- Color tokens
- Typography specs
- Interaction notes
- Asset exports
```

## Design Review Checklist

### Before Development
- [ ] All screens designed for light + dark mode
- [ ] iPhone + iPad layouts (if Universal)
- [ ] Empty states designed
- [ ] Error states designed
- [ ] Loading states designed
- [ ] Accessibility reviewed
- [ ] Haptic feedback specified
- [ ] Transitions/animations documented

### Platform Consistency
- [ ] Uses SF Symbols where possible
- [ ] Follows iOS navigation patterns
- [ ] Respects safe areas
- [ ] 44pt minimum touch targets
- [ ] System fonts for body text
- [ ] Native controls where appropriate

## Resources

- [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [Apple Design Resources](https://developer.apple.com/design/resources/)

See [references/hig-checklist.md](references/hig-checklist.md) for detailed HIG compliance checklist.
