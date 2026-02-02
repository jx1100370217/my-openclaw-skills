# Apple Human Interface Guidelines Checklist

Use this checklist to ensure your iOS app follows Apple's HIG.

## App Architecture

### Navigation
- [ ] Uses appropriate navigation pattern (Tab Bar, Sidebar, Navigation Stack)
- [ ] Tab bar has 3-5 items maximum
- [ ] Navigation titles are clear and concise
- [ ] Back navigation works consistently
- [ ] Modal presentation used appropriately

### Content Organization
- [ ] Content hierarchy is clear
- [ ] Related items are grouped
- [ ] Progressive disclosure for complex features
- [ ] Search available for large content sets

## Visual Design

### Colors
- [ ] Uses system colors where appropriate
- [ ] Custom colors have semantic meaning
- [ ] Sufficient contrast (4.5:1 for text)
- [ ] Works in both light and dark mode
- [ ] No color-only information

### Typography
- [ ] Uses system fonts (SF Pro) for body text
- [ ] Follows iOS type scale
- [ ] Dynamic Type supported
- [ ] Text is legible at all sizes

### Icons & Images
- [ ] Uses SF Symbols where possible
- [ ] Custom icons match SF Symbols style
- [ ] Images are properly sized (@1x, @2x, @3x)
- [ ] App icon follows guidelines

### Layout
- [ ] Respects Safe Areas
- [ ] Proper margins and padding
- [ ] Consistent spacing throughout
- [ ] Adapts to different screen sizes

## Interaction Design

### Touch
- [ ] Touch targets are 44x44pt minimum
- [ ] Buttons have clear affordances
- [ ] Interactive elements are obvious
- [ ] No dead zones or unresponsive areas

### Gestures
- [ ] Standard gestures work as expected
- [ ] Custom gestures are discoverable
- [ ] Gestures have alternatives (for accessibility)

### Feedback
- [ ] Actions provide immediate feedback
- [ ] Loading states are clear
- [ ] Errors are helpful and actionable
- [ ] Success states are confirmed

### Haptics
- [ ] Haptic feedback for key interactions
- [ ] Appropriate haptic intensity
- [ ] Consistent haptic patterns

## System Integration

### iOS Features
- [ ] Supports dark mode
- [ ] Supports Dynamic Type
- [ ] Integrates with system features appropriately
- [ ] Uses iOS controls where appropriate

### Privacy
- [ ] Requests permissions at appropriate time
- [ ] Explains why permissions are needed
- [ ] Works with reduced permissions
- [ ] Privacy policy accessible

### Notifications
- [ ] Notifications are valuable
- [ ] Notification content is actionable
- [ ] Respects user notification preferences

## Accessibility

### VoiceOver
- [ ] All elements have accessibility labels
- [ ] Logical reading order
- [ ] Actions are accessible
- [ ] Images have alt text

### Visual Accessibility
- [ ] Supports Dynamic Type (all sizes)
- [ ] Supports Bold Text
- [ ] Supports Reduce Motion
- [ ] Supports Increase Contrast
- [ ] Supports Reduce Transparency

### Motor Accessibility
- [ ] Supports full keyboard access
- [ ] Supports Switch Control
- [ ] Large enough touch targets
- [ ] No time-dependent interactions

## Performance

### Launch
- [ ] App launches quickly (<2 seconds)
- [ ] Splash screen matches first screen

### Responsiveness
- [ ] Scrolling is smooth (60fps)
- [ ] Interactions feel instant
- [ ] No jank or stuttering

### Efficiency
- [ ] Battery usage is reasonable
- [ ] Network usage is optimized
- [ ] Memory usage is appropriate

## App Store Readiness

### Content
- [ ] No placeholder content
- [ ] No offensive content
- [ ] All content is appropriate

### Technical
- [ ] No crashes or major bugs
- [ ] Works on all supported devices
- [ ] Works on all supported iOS versions

### Metadata
- [ ] App name is appropriate
- [ ] Screenshots are accurate
- [ ] Description is clear

---

## Quick Checks

Before each release:
1. Test in dark mode
2. Test with largest Dynamic Type
3. Test with VoiceOver
4. Test on oldest supported device
5. Test in airplane mode
6. Review for placeholder content
