---
name: ios-competitor-analysis
description: Analyze iOS app competitors comprehensively. Use when researching competing apps, understanding market positioning, identifying feature gaps, analyzing pricing strategies, or finding differentiation opportunities. Second step in the idea-to-App-Store workflow after idea validation.
---

# iOS Competitor Analysis

Comprehensive framework for analyzing competing iOS apps and finding your competitive advantage.

## Analysis Framework

```
Identify Competitors → Feature Analysis → UX/UI Review → 
Business Model → Reviews Mining → SWOT → Differentiation Strategy
```

## Step 1: Identify Competitors

### Competitor Categories

| Type | Description | Priority |
|------|-------------|----------|
| **Direct** | Same problem, same solution | High |
| **Indirect** | Same problem, different solution | Medium |
| **Potential** | Could enter your market | Low |

### Discovery Methods

```bash
# App Store Search
- Search primary keywords
- Browse category rankings (Top Free, Top Paid, Top Grossing)
- Check "You Might Also Like" sections

# External Research
- Product Hunt (producthunt.com)
- AlternativeTo (alternativeto.net)
- G2/Capterra for B2B apps
- Reddit discussions
- Google "[problem] app iOS"
```

### Competitor Shortlist Template
```markdown
## Competitor Shortlist

### Direct Competitors
| App | Downloads | Rating | Price Model |
|-----|-----------|--------|-------------|
| [Name] | [Est.] | [X.X] | [Free/Paid/Sub] |

### Indirect Competitors
| App | How They Solve It | Overlap |
|-----|-------------------|---------|
| [Name] | [Approach] | [%] |
```

## Step 2: Feature Analysis

### Feature Matrix
```markdown
## Feature Comparison Matrix

| Feature | Our App | Comp A | Comp B | Comp C |
|---------|---------|--------|--------|--------|
| Core Feature 1 | ✅ | ✅ | ✅ | ❌ |
| Core Feature 2 | ✅ | ✅ | ❌ | ✅ |
| Core Feature 3 | ✅ | ❌ | ✅ | ✅ |
| Unique Feature | ✅ | ❌ | ❌ | ❌ |
| Offline Mode | ✅ | ❌ | ✅ | ❌ |
| Cloud Sync | ✅ | ✅ | ✅ | ❌ |
| Widget Support | ✅ | ❌ | ❌ | ❌ |
| Apple Watch | ❌ | ✅ | ❌ | ❌ |

**Legend:** ✅ Has | ❌ Missing | 🔄 Partial
```

### Feature Gap Analysis
```markdown
## Feature Gaps & Opportunities

### Over-served (Everyone has it)
- [Feature] - Table stakes, must have

### Under-served (Gap in market)
- [Feature] - Only 1/5 competitors have this
- [Feature] - Commonly requested in reviews

### Un-served (No one has it)
- [Feature] - Novel opportunity
```

## Step 3: UX/UI Review

### Evaluation Criteria

| Aspect | Score 1-5 | Notes |
|--------|-----------|-------|
| **Onboarding** | | First-time user experience |
| **Navigation** | | Ease of finding features |
| **Visual Design** | | Modern, polished UI |
| **Performance** | | Speed, responsiveness |
| **Accessibility** | | VoiceOver, Dynamic Type |
| **Delight** | | Animations, micro-interactions |

### Screenshot Comparison
```
Collect screenshots for each competitor:
- Onboarding flow (3-5 screens)
- Main screen / Dashboard
- Core feature screens
- Settings / Profile
- Paywall / Upgrade screen
```

### UX Patterns to Note
- Navigation style (Tab bar, Sidebar, etc.)
- Color scheme and typography
- Icon style (SF Symbols, custom)
- Empty states
- Error handling
- Loading states

## Step 4: Business Model Analysis

### Monetization Comparison
```markdown
## Monetization Matrix

| App | Model | Price Point | Free Tier |
|-----|-------|-------------|-----------|
| Comp A | Subscription | $4.99/mo | Limited |
| Comp B | One-time | $9.99 | None |
| Comp C | Freemium | $2.99/mo | Generous |
| Comp D | Ads | Free + IAP | Full w/ads |
```

### Pricing Analysis
```markdown
## Pricing Insights

**Market Price Range:**
- Low: $X.XX/mo
- Mid: $X.XX/mo  
- High: $X.XX/mo

**Common Pricing Tiers:**
- Free: [Features included]
- Pro: [Price] - [Features]
- Business: [Price] - [Features]

**Trial Periods:**
- Most common: 7-day free trial
- Comp A: 14-day trial
- Comp B: No trial (freemium)
```

## Step 5: Review Mining

### Sentiment Analysis
```markdown
## App Store Review Analysis - [Competitor Name]

**Overall Rating:** X.X (XX,XXX reviews)

### Positive Themes (5-star reviews)
1. [Theme] - mentioned X times
2. [Theme] - mentioned X times
3. [Theme] - mentioned X times

### Negative Themes (1-2 star reviews)
1. [Theme] - mentioned X times
   - "Quote from review"
2. [Theme] - mentioned X times
   - "Quote from review"

### Feature Requests
1. [Feature] - requested X times
2. [Feature] - requested X times
```

### Review Mining Script Locations
```
Sources to analyze:
- App Store reviews (use AppFollow, AppBot, or manual)
- Reddit mentions
- Twitter/X mentions
- Product Hunt comments
- G2/Capterra reviews (for B2B)
```

## Step 6: SWOT Analysis

```markdown
## SWOT Analysis - [Competitor Name]

### Strengths 💪
- [What they do well]
- [Market advantages]
- [Strong features]

### Weaknesses 🎯
- [Poor reviews about]
- [Missing features]
- [Bad UX patterns]

### Opportunities 🚀
- [Market gaps]
- [Emerging trends]
- [Unmet needs]

### Threats ⚠️
- [New entrants]
- [Platform changes]
- [User behavior shifts]
```

## Step 7: Differentiation Strategy

### Positioning Matrix
```
                    HIGH PRICE
                        │
            Premium     │     Luxury
           (Quality)    │    (Status)
                        │
LOW ────────────────────┼──────────────── HIGH
FEATURES                │               FEATURES
                        │
            Budget      │    Value
          (Minimal)     │   (Best deal)
                        │
                    LOW PRICE
```

### Differentiation Options

| Strategy | Description | Example |
|----------|-------------|---------|
| **Feature** | Best-in-class capability | "Only app with X" |
| **UX** | Superior experience | "Simplest way to X" |
| **Price** | Better value | "Pro features, free" |
| **Niche** | Specific audience | "Built for designers" |
| **Integration** | Ecosystem play | "Works with Y" |
| **Privacy** | Trust factor | "Your data stays yours" |

### Your Unique Value Proposition
```markdown
## Value Proposition Canvas

**For** [target user]
**Who** [has this problem]
**Our app** [product name]
**Is a** [category]
**That** [key benefit]
**Unlike** [competitors]
**We** [key differentiator]
```

## Output: Competitor Analysis Report

```markdown
# Competitor Analysis Report

## Executive Summary
[Key findings and strategic recommendations]

## Market Landscape
[Overview of competitive environment]

## Competitor Profiles
### [Competitor 1]
- Overview:
- Strengths:
- Weaknesses:
- Key takeaways:

### [Competitor 2]
...

## Feature Analysis
[Matrix and gap analysis]

## Pricing Analysis
[Market pricing insights]

## User Sentiment
[Review mining insights]

## Strategic Recommendations
1. **Differentiation Strategy:** [Approach]
2. **Features to Prioritize:** [List]
3. **Features to Skip:** [List]
4. **Pricing Recommendation:** [Strategy]
5. **Positioning Statement:** [One sentence]

## Next Steps
→ Proceed to PRD generation with these insights
```
