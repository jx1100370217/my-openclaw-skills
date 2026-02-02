---
name: ios-app-store-publishing
description: Publish iOS apps to the App Store successfully. Use when preparing app submission, optimizing App Store listing (ASO), handling review guidelines, managing certificates/provisioning, creating screenshots, writing descriptions, or resolving rejection issues. Covers the complete publishing workflow from Xcode to App Store Connect.
---

# iOS App Store Publishing

Complete guide to successfully publish your iOS app to the App Store.

## Pre-Submission Checklist

### App Requirements
- [ ] App icon (1024x1024, no alpha)
- [ ] Launch screen configured
- [ ] All required device sizes supported
- [ ] Privacy policy URL
- [ ] Support URL
- [ ] App category selected

### Technical Requirements
- [ ] No private APIs used
- [ ] No crash on launch
- [ ] No placeholder content
- [ ] Minimum iOS version set
- [ ] Required capabilities declared in Info.plist
- [ ] All entitlements properly configured

### Content Requirements
- [ ] No copyrighted content without permission
- [ ] Age rating completed accurately
- [ ] No misleading app metadata
- [ ] Screenshots reflect actual app

## App Store Connect Setup

### App Information
```
App Name: [Unique, max 30 characters]
Subtitle: [Max 30 characters, keyword-rich]
Bundle ID: com.yourcompany.appname
SKU: [Unique identifier, any format]
Primary Language: [Your main market]
```

### Version Information
```
Version: 1.0.0 (semantic versioning)
Build: Auto-incremented integer
What's New: [Release notes for updates]
```

## App Store Optimization (ASO)

### Title & Subtitle
- Use primary keyword in title
- Subtitle for secondary keywords
- Avoid keyword stuffing

### Keywords Field (100 chars)
```
Format: keyword1,keyword2,keyword3 (no spaces after commas)

Tips:
- Use singular forms (app searches both)
- Avoid duplicating title/subtitle words
- Include common misspellings
- Research competitor keywords
```

### Description
```markdown
First Paragraph (Above the fold):
- Hook with main value proposition
- Include primary keywords naturally

Features Section:
• Feature 1 - Benefit explanation
• Feature 2 - Benefit explanation
• Feature 3 - Benefit explanation

Social Proof:
"Quote from user/press" - Source

Call to Action:
Download now and experience [benefit]!
```

### Screenshots
| Device | Size | Slots |
|--------|------|-------|
| iPhone 6.7" | 1290 x 2796 | Up to 10 |
| iPhone 6.5" | 1284 x 2778 | Up to 10 |
| iPhone 5.5" | 1242 x 2208 | Up to 10 |
| iPad Pro 12.9" | 2048 x 2732 | Up to 10 |

**Best Practices:**
1. First 3 screenshots most important
2. Show key features, not onboarding
3. Add captions/callouts
4. Use device frames (optional)
5. Localize for major markets

### App Preview Videos
- 15-30 seconds optimal
- No hands/devices in frame
- Start with impact moment
- Include captions (often muted)

## Common Rejection Reasons

### Guideline 2.1 - App Completeness
**Issue:** Crashes, placeholder content, incomplete features
**Fix:** Thorough testing, remove "Coming Soon" features

### Guideline 2.3 - Accurate Metadata
**Issue:** Screenshots don't match app, misleading description
**Fix:** Update screenshots, honest descriptions

### Guideline 4.2 - Minimum Functionality
**Issue:** App is too simple, web wrapper, template
**Fix:** Add unique features, native functionality

### Guideline 5.1.1 - Data Collection
**Issue:** Missing privacy disclosures
**Fix:** Complete App Privacy section accurately

### Guideline 3.1.1 - In-App Purchase
**Issue:** Linking to external payment
**Fix:** Use StoreKit for digital goods

## Privacy Requirements

### App Privacy Labels
Must disclose in App Store Connect:
- Data collected (contact, location, etc.)
- How data is used (analytics, advertising, etc.)
- Whether data is linked to user
- Whether data is used for tracking

### Required Privacy Descriptions (Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>Take photos for your profile</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Select photos from your library</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Find nearby locations</string>

<key>NSUserTrackingUsageDescription</key>
<string>To provide personalized ads</string>
```

## Xcode Archive & Upload

### Build Settings
```
PRODUCT_BUNDLE_IDENTIFIER = com.company.app
MARKETING_VERSION = 1.0.0
CURRENT_PROJECT_VERSION = 1
CODE_SIGN_STYLE = Automatic
DEVELOPMENT_TEAM = [Your Team ID]
```

### Archive Process
1. Select "Any iOS Device" as destination
2. Product → Archive
3. Window → Organizer
4. Distribute App → App Store Connect
5. Upload

### Common Upload Errors
| Error | Solution |
|-------|----------|
| Invalid binary | Check architectures, no simulator code |
| Missing icon | Add 1024x1024 icon to asset catalog |
| Invalid provisioning | Regenerate profiles |
| Entitlements mismatch | Match App ID capabilities |

## Review Process

### Timeline
- Standard: 24-48 hours (usually)
- Expedited: Request via Contact Us (emergencies only)

### Responding to Rejections
1. Read rejection message carefully
2. Check specific guideline cited
3. Reply in Resolution Center
4. Be professional, provide context
5. Attach screenshots if helpful

### Appeal Process
1. App Review Board appeal (last resort)
2. Provide detailed justification
3. Include competitor examples if relevant

## Post-Launch

### Monitor
- Crash reports (Xcode Organizer)
- User reviews (respond promptly)
- Ratings trends
- Download metrics

### Iterate
- Regular updates (every 4-6 weeks ideal)
- Respond to feedback
- A/B test screenshots (Search Ads)
- Localize for new markets

## Resources

See [references/review-guidelines.md](references/review-guidelines.md) for complete guidelines.
See [references/aso-checklist.md](references/aso-checklist.md) for optimization checklist.

## External Links

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
