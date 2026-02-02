---
name: ios-idea-validation
description: Validate iOS app ideas before development. Use when evaluating a new app concept, conducting market research, identifying target users, analyzing market size (TAM/SAM/SOM), validating problem-solution fit, or deciding whether to proceed with development. First step in the idea-to-App-Store workflow.
---

# iOS Idea Validation

Validate your app idea before investing time and resources in development.

## Validation Framework

```
Idea → Problem Validation → Market Research → User Research → Decision
                ↓                  ↓                ↓
         Is it real?      Is it big enough?   Will they pay?
```

## Step 1: Problem Validation

### Define the Problem
```markdown
## Problem Statement Template

**Who** has this problem?
[Specific user segment]

**What** is the problem?
[Clear, specific description]

**When** does it occur?
[Context and frequency]

**Why** is it painful?
[Consequences of not solving]

**Current solutions?**
[How do they cope now]
```

### Problem Validation Checklist
- [ ] Can you describe the problem in one sentence?
- [ ] Have you experienced this problem yourself?
- [ ] Can you find 10+ people with this problem online?
- [ ] Are people actively seeking solutions?
- [ ] Is the problem frequent or severe enough to pay for?

## Step 2: Market Research

### Market Size (TAM/SAM/SOM)

```
TAM (Total Addressable Market)
└── Everyone who could possibly use the product
    Example: All smartphone users globally = 6.8B

SAM (Serviceable Addressable Market)  
└── Segment you can reach with your business model
    Example: iOS users in English-speaking countries = 500M

SOM (Serviceable Obtainable Market)
└── Realistic share you can capture in 1-3 years
    Example: 0.1% of SAM = 500K users
```

### Market Research Sources

| Source | Use For | URL |
|--------|---------|-----|
| App Annie / data.ai | App market data | data.ai |
| Sensor Tower | App store intelligence | sensortower.com |
| Statista | Market statistics | statista.com |
| Google Trends | Search interest | trends.google.com |
| Reddit/Twitter | User sentiment | - |
| App Store | Category rankings | apps.apple.com |

### Category Analysis
```markdown
## App Store Category Analysis

**Primary Category:** [e.g., Productivity]
**Secondary Category:** [e.g., Business]

**Top 10 Apps in Category:**
1. [App Name] - [Downloads] - [Rating]
2. ...

**Category Trends:**
- Growing/Stable/Declining
- Key features users expect
- Pricing patterns
```

## Step 3: User Research

### Target User Persona
```markdown
## User Persona: [Name]

**Demographics:**
- Age: 
- Occupation:
- Location:
- Income level:

**Psychographics:**
- Goals:
- Frustrations:
- Values:
- Tech savviness:

**Behavior:**
- Apps they use daily:
- Time spent on phone:
- Willingness to pay for apps:

**Quote:**
"[A statement that captures their mindset]"
```

### User Research Methods

| Method | Effort | Insight Depth | Best For |
|--------|--------|---------------|----------|
| App Store Reviews | Low | Medium | Pain points |
| Reddit/Forums | Low | Medium | Real discussions |
| Surveys | Medium | Medium | Quantitative data |
| Interviews | High | High | Deep understanding |
| Landing Page Test | Medium | High | Purchase intent |

### Landing Page Validation
```markdown
## MVP Landing Page Elements

1. **Headline**: Clear value proposition
2. **Problem**: What pain you solve
3. **Solution**: How your app helps
4. **Features**: 3-5 key capabilities
5. **Social Proof**: Testimonials/numbers
6. **CTA**: "Join waitlist" / "Get notified"

**Metrics to Track:**
- Visitor to signup conversion rate
- Email open rates
- Survey responses
```

## Step 4: Go/No-Go Decision

### Scoring Matrix

| Criterion | Weight | Score (1-5) | Weighted |
|-----------|--------|-------------|----------|
| Problem severity | 25% | | |
| Market size | 20% | | |
| Competition level | 15% | | |
| Technical feasibility | 15% | | |
| Monetization potential | 15% | | |
| Personal interest/expertise | 10% | | |
| **Total** | 100% | | /5.0 |

**Decision Thresholds:**
- 4.0+: Strong GO - Proceed with development
- 3.0-3.9: Conditional GO - Address weak areas first
- 2.0-2.9: PIVOT - Refine the concept
- <2.0: NO GO - Find a different idea

### Red Flags 🚩
- Market too small (<100K potential users)
- Dominated by free apps with network effects
- Requires significant behavior change
- High regulatory/legal barriers
- No clear monetization path

### Green Flags ✅
- Active communities seeking solutions
- Competitors with bad reviews (opportunity)
- Clear willingness to pay
- Leverages your unique skills
- Recurring use case

## Output: Validation Report

```markdown
# App Idea Validation Report

## Executive Summary
[2-3 sentences on go/no-go recommendation]

## The Idea
[One paragraph description]

## Problem Validation
- Problem statement:
- Evidence of problem:
- Current alternatives:

## Market Analysis
- TAM/SAM/SOM:
- Growth trends:
- Key competitors:

## User Research
- Target persona:
- Key insights:
- Willingness to pay:

## Technical Feasibility
- Core technologies needed:
- Estimated complexity:
- MVP timeline:

## Recommendation
[ ] GO - Proceed to competitor analysis
[ ] PIVOT - Adjust concept based on [findings]
[ ] NO GO - Reason: [explanation]

## Next Steps
1. [Action item]
2. [Action item]
3. [Action item]
```

## Resources

See [references/market-research-tools.md](references/market-research-tools.md) for detailed tool guides.
