---
name: ios-prd-generator
description: Generate comprehensive Product Requirements Documents (PRD) for iOS apps. Use when defining app requirements, writing user stories, specifying features, documenting acceptance criteria, or creating technical specifications. Third step in the idea-to-App-Store workflow after competitor analysis.
---

# iOS PRD Generator

Generate professional Product Requirements Documents for iOS app development.

## PRD Structure

```
Vision → User Personas → User Stories → Features → 
Technical Requirements → Success Metrics → Timeline
```

## PRD Template

### 1. Product Overview

```markdown
# [App Name] - Product Requirements Document

**Version:** 1.0
**Last Updated:** [Date]
**Author:** [Name]
**Status:** Draft | Review | Approved

---

## 1. Product Vision

### 1.1 Executive Summary
[2-3 sentence description of the app and its purpose]

### 1.2 Problem Statement
**The problem of** [describe the problem]
**affects** [target users]
**the impact of which is** [consequences]
**A successful solution would** [key benefits]

### 1.3 Product Vision Statement
**For** [target customer]
**Who** [statement of need]
**The** [product name] is a [product category]
**That** [key benefit, reason to buy]
**Unlike** [primary competitive alternative]
**Our product** [primary differentiation]

### 1.4 Goals & Success Metrics

| Goal | Metric | Target |
|------|--------|--------|
| User Acquisition | DAU/MAU | X users in 6 months |
| Engagement | Session duration | X minutes avg |
| Retention | D7 retention | X% |
| Revenue | MRR | $X in 12 months |
```

### 2. User Personas

```markdown
## 2. Target Users

### 2.1 Primary Persona: [Name]

**Demographics:**
- Age: X-X years old
- Occupation: [Job title/field]
- Tech proficiency: Low | Medium | High

**Goals:**
- [Primary goal]
- [Secondary goal]

**Pain Points:**
- [Frustration 1]
- [Frustration 2]

**Behavior:**
- Uses apps for [purpose]
- Willing to pay for [value]

**Quote:** "[A statement capturing their mindset]"

### 2.2 Secondary Persona: [Name]
[Same structure as above]
```

### 3. User Stories & Requirements

```markdown
## 3. Features & User Stories

### 3.1 Epic: [Epic Name]

#### User Story 3.1.1
**As a** [user type]
**I want** [action/feature]
**So that** [benefit/value]

**Acceptance Criteria:**
- [ ] Given [context], when [action], then [result]
- [ ] Given [context], when [action], then [result]
- [ ] Error state: [description]

**Priority:** P0 (Must have) | P1 (Should have) | P2 (Nice to have)
**Effort:** S | M | L | XL
**Dependencies:** [List any dependencies]

---

#### User Story 3.1.2
[Same structure]
```

### 4. Feature Specifications

```markdown
## 4. Detailed Feature Specifications

### 4.1 [Feature Name]

**Description:**
[Detailed description of the feature]

**User Flow:**
1. User opens app
2. User taps [button]
3. System displays [screen]
4. User enters [data]
5. System [action]
6. User sees [result]

**UI Requirements:**
- Screen: [Name]
- Components: [List of UI elements]
- Interactions: [Gestures, animations]

**Data Requirements:**
- Input: [Data fields]
- Output: [Expected results]
- Storage: Local | Cloud | Both

**Edge Cases:**
- Empty state: [Description]
- Error state: [Description]
- Offline: [Behavior]

**Mockup Reference:** [Link or file name]
```

### 5. Technical Requirements

```markdown
## 5. Technical Requirements

### 5.1 Platform Requirements
- iOS Version: iOS [X]+ 
- Devices: iPhone / iPad / Universal
- Orientations: Portrait / Landscape / Both

### 5.2 Architecture
- Pattern: MVVM / TCA / Clean Architecture
- UI Framework: SwiftUI / UIKit / Hybrid
- State Management: [Approach]

### 5.3 Dependencies
| Library | Purpose | Version |
|---------|---------|---------|
| [Name] | [Use case] | [Version] |

### 5.4 Backend Requirements
- [ ] User authentication
- [ ] Cloud sync
- [ ] Push notifications
- [ ] Analytics
- [ ] Crash reporting

**API Endpoints (if applicable):**
| Endpoint | Method | Purpose |
|----------|--------|---------|
| /api/v1/users | GET | Fetch user data |

### 5.5 Data Model
```swift
struct User {
    let id: UUID
    var name: String
    var email: String
    var createdAt: Date
}

struct [ModelName] {
    // Properties
}
```

### 5.6 Security Requirements
- [ ] Keychain for sensitive data
- [ ] Certificate pinning (if applicable)
- [ ] App Transport Security compliance
- [ ] Privacy manifest required entries
```

### 6. Design Requirements

```markdown
## 6. Design Requirements

### 6.1 Design System
- Colors: [Primary, Secondary, Accent]
- Typography: SF Pro / Custom
- Icons: SF Symbols / Custom
- Spacing: [System]

### 6.2 Accessibility
- [ ] VoiceOver support
- [ ] Dynamic Type support
- [ ] Color contrast compliance
- [ ] Reduce Motion support

### 6.3 Localization
- Languages: [List]
- RTL support: Yes / No

### 6.4 Screen List
| Screen | Description | Priority |
|--------|-------------|----------|
| Onboarding | First-time user flow | P0 |
| Home | Main dashboard | P0 |
| [Screen] | [Description] | [Priority] |
```

### 7. Release Plan

```markdown
## 7. Release Plan

### 7.1 MVP Scope (v1.0)
**Target Date:** [Date]

**Included Features:**
- [Feature 1] - P0
- [Feature 2] - P0
- [Feature 3] - P0

**Excluded from MVP:**
- [Feature] - Reason: [Why deferred]

### 7.2 Future Releases

**v1.1 - [Theme]**
- [Feature]
- [Feature]

**v2.0 - [Theme]**
- [Feature]
- [Feature]

### 7.3 Timeline
| Phase | Duration | Deliverable |
|-------|----------|-------------|
| Design | 2 weeks | Figma mockups |
| Development | 6 weeks | Working app |
| Testing | 2 weeks | Bug-free build |
| App Review | 1 week | Approved app |
| **Total** | 11 weeks | App Store launch |
```

### 8. Appendix

```markdown
## 8. Appendix

### 8.1 Glossary
| Term | Definition |
|------|------------|
| [Term] | [Definition] |

### 8.2 References
- Competitor Analysis: [Link]
- Market Research: [Link]
- Design Files: [Link]

### 8.3 Open Questions
- [ ] [Question that needs resolution]
- [ ] [Question that needs resolution]

### 8.4 Change Log
| Date | Version | Author | Changes |
|------|---------|--------|---------|
| [Date] | 1.0 | [Name] | Initial draft |
```

## User Story Templates

### Authentication
```markdown
**As a** new user
**I want** to create an account
**So that** I can save my data and access it across devices

**Acceptance Criteria:**
- [ ] User can sign up with email/password
- [ ] User can sign up with Apple ID
- [ ] Password must be 8+ characters
- [ ] Email verification required
- [ ] Error shown for existing email
```

### Core Feature
```markdown
**As a** [user type]
**I want** to [action]
**So that** [benefit]

**Acceptance Criteria:**
- [ ] [Specific testable criterion]
- [ ] [Specific testable criterion]
- [ ] [Edge case handling]
```

## Output Files

When generating PRD, create:
1. `docs/PRD.md` - Main PRD document
2. `docs/user-stories.md` - Detailed user stories
3. `docs/data-model.md` - Data structures
4. `docs/api-spec.md` - API specifications (if applicable)

## Resources

See [assets/prd-template.md](assets/prd-template.md) for full template.
See [references/user-story-examples.md](references/user-story-examples.md) for more examples.
