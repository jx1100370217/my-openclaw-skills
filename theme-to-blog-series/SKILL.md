---
name: theme-to-blog-series
description: Turn a technical theme/topic into a multi-article CSDN-style technical blog series with cinematic Gemini covers and ≤200-char abstracts. Use when the user gives you a *topic* (not a repo) — like "harness engineering", "context engineering", "MoE", "RAG" — and asks to "search the web for authoritative materials and write N deep articles with covers". Sister skill of repo-to-blog-series; same downstream pipeline (parallel subagents → Gemini covers → abstracts), but the upstream is *web research* instead of *code reading*. Trigger phrases: "检索全网关于X的资料整理成系列博客", "围绕主题X写N篇深度博客", "把这个技术写成系列文章 + 封面 + 摘要".
---

# Theme → Blog Series Skill

End-to-end workflow that turns one technical theme into a deep web-researched blog series with covers and abstracts. Sibling of `repo-to-blog-series`: same parallel-writing + Gemini-cover + abstract pipeline, but the upstream input is *the open web* instead of *one git repo*.

## When to invoke

The user gives you:
- a **theme / topic / technology name** (no GitHub URL)
- "检索全网关于X的资料整理成系列博客 ≥ N 篇" (or equivalent)
- optionally: a reference series style to mirror, cover image generation, abstract generation, save-to-memory

## Core principles (inherited from repo-to-blog-series)

1. **Parallelize the writing.** N articles = N background `Agent` subagents fired simultaneously. Each one is self-contained — it cannot see the main conversation.
2. **Each subagent gets a non-overlapping conceptual slice** of the theme. Listing what they MUST NOT cover is more important than listing what they should.
3. **Mirror an existing series format** if the user names one (browser → CSDN → extract title/TOC/code-block style/cover image). If not named, default to the in-house template (see Stage 2).
4. **Don't dump article bodies back into the main context.** Subagents return only `{path, char_count, one-line summary}`.
5. **Use the user's installed memory system** (MemPalace) to persist learnings between runs.

## Differences vs repo-to-blog-series

| Aspect | repo-to-blog-series | **theme-to-blog-series** |
|---|---|---|
| Input | GitHub URL | Topic / theme keyword |
| Research substrate | git clone + `wc -l *.py` | `WebSearch` + `WebFetch` over papers / blogs / official docs |
| Authority signals | source code itself | **author** (Anthropic, Karpathy, OpenAI…), **venue** (arXiv, official engineering blog, Martin Fowler), citation density |
| Article division | by module (ingestion / indexing / serving) | by **conceptual layer** (definition → mechanism → application → reflection) |
| Risk to manage | redundant file coverage | **redundant claim coverage** + factual hallucination |
| Citation rule | inline file refs `loader.py:123` | inline links to **primary sources** at end of each article |
| Everything else | ↓ same ↓ | ↓ same ↓ |

## Stage 1 — Setup & web research

```bash
# Create task list
TaskCreate for: research, planning, N articles, covers, abstracts, (memory save), index README
mkdir -p <output-dir>/covers
```

**Research breadth target**: 12–20 high-quality sources before drafting begins.

```text
# WebSearch the theme with at least 4 angles in parallel:
1. "<theme>" + foundational paper / origin
2. "<theme>" + Anthropic | OpenAI | Google official engineering blog
3. "<theme>" + arXiv | preprint | survey
4. "<theme>" + practitioner essays (Karpathy / Fowler / Raschka / Osmani / LangChain / HumanLayer)
```

For each promising hit, `WebFetch` with a focused prompt extracting **definitions, principles, diagrams (described in text), code/pseudocode, examples, tradeoffs**. Keep prompts narrow — a wide prompt returns shallow content.

**Authority hierarchy** (cite top of stack first):
1. Primary research papers (arXiv, ICLR, NeurIPS)
2. Official engineering blogs of frontier labs (Anthropic, OpenAI, DeepMind)
3. Curated essays from named senior engineers (Karpathy, Fowler, Raschka, Osmani)
4. Vendor docs (Claude SDK, OpenAI Agents SDK, LangChain)
5. Reputable practitioner blogs / Medium long-form
6. Aggregator summaries (only if 1–4 unavailable)

## Stage 2 — Plan article division

Carve N articles by **conceptual layer**, not by source. Default 6–8 article skeleton for a technical theme:

| # | Default role | Typical content |
|---|---|---|
| 1 | **概念与起源** | definition, equation/identity, taxonomy, origin timeline, why-now |
| 2 | **核心机制** | the central loop / data structure / algorithm |
| 3 | **关键子系统 A** | usually the hardest / most differentiating layer |
| 4 | **关键子系统 B** | the second most load-bearing layer |
| 5 | **应用 / 长任务 / 多代理** | how it scales beyond one call |
| 6 | **工程实战 N 条经验** | failure modes, ratchet rules, case studies |
| 7 | **未来 / 开放问题** *(optional)* | research frontier, HaaS, self-improving variants |

Adjust the slot names to the theme. Each article ≥ 4000 Chinese characters (default; user can override). List which **claims / sources / sub-topics** belong to which article — and which are off-limits to which agent.

## Stage 3 — Parallel writing (the critical step)

Fire N `Agent({subagent_type: "general-purpose", run_in_background: true})` calls in parallel. Each prompt MUST contain:

1. **Series context**: name, position, what the previous N-1 articles already covered (one line each)
2. **Reference style description**: title format, section numbering (一/1.1/1.1.1), emoji headers (sparingly), ASCII boxed diagrams, real code blocks with language tags, comparison tables, "Why" rationale paragraphs, "下篇预告" + 参考资料 sections
3. **The exact source-list this agent owns**: 5–8 URLs that are *primary* for this article + 5–10 secondary URLs
4. **The claims this agent MUST NOT touch** (so the N agents don't all rephrase the same definition)
5. **Output path** (e.g. `<output-dir>/NN-<short-topic>.md`)
6. **Length floor**: ≥ 4000 zh chars (or user override), depth-first, citations inline at end
7. **Reporting rule**: "回报路径 + 字数 + 一句话总结，**不要把正文贴回来**" — saves main-thread context

While the agents run (5–10 min), do other work (e.g. cover generation, abstract drafting).

## Stage 4 — Cover generation via Gemini browser automation

Generation is automated; **download is manual** — see "user-gesture trust" note below. Plan: fire all N prompts in one batch, watch the download folder, ask the user to click the N download buttons in conversation order.

### If the user named a reference series — mirror its cover style

```javascript
// On the reference CSDN article page
Array.from(document.querySelectorAll('article img'))
  .filter(i => i.naturalWidth > 400)
  .map(i => ({src: i.src, w: i.naturalWidth, h: i.naturalHeight}))
```
Then `navigate` to the image URL and `screenshot` to see it.

### Step 4.1 — Fire all N prompts in one chat

1. `navigate` to `https://gemini.google.com/app` (fresh load — the 发起新对话 button often does not actually swap chat URL on this build, so a hard navigate is more reliable)
2. For each of the N prompts, run a JS block that:
   - finds the editor (`.ql-editor[contenteditable="true"]`)
   - clears it (use DOM `removeChild` loop — `innerHTML = ''` fails with TrustedHTML CSP)
   - appends a `<p>` with the prompt text
   - dispatches `input` event so Gemini's submit button becomes enabled
   - on a 600ms timeout, finds the button with `aria-label` containing 发送 and `.click()`s it
3. Between prompts, **`Bash run_in_background sleep 35`**. Do not `await sleep` inline (the runtime blocks long sleeps in foreground); a background sleep gives you a clean completion notification.
4. After all N sends, run a JS check that there are now N `img` elements with `naturalWidth > 400` and N `button[data-test-id="download-generated-image-button"]`. If the count is short, re-send only the missing prompts.

Why one chat: it is enough — each prompt is explicit and overrides chat-context bias. Trying to start a new chat per cover wastes turns and the new-chat button is unreliable.

### Step 4.2 — Why downloads must be manual

**The first programmatic download click DOES work; subsequent ones DO NOT.**

After the first successful download in a tab, Chromium revokes its "user gesture" trust for subsequent same-tab downloads triggered by `element.click()`, `dispatchEvent`, or even `mcp__claude-in-chrome__computer left_click` at the button's coordinates. None of these registers as a fresh user-initiated download. There is no JS workaround we have found that survives this restriction (see "DO NOT work" list below).

So: **do not try to programmatically click N download buttons**. Instead:

1. Set up the watcher (Step 4.3) **before** asking the user.
2. Ask the user, in plain language, to scroll the Gemini conversation from top to bottom and click each image's "**下载完整尺寸的图片**" hover button in order.
3. The watcher renames files by arrival order — so as long as the user clicks them top-to-bottom, the filenames line up with article numbers.

This is a deliberate tradeoff documented after a multi-attempt verification on 2026-04-29: faster, more reliable, less brittle than fighting Chromium's download trust.

### Step 4.3 — Watcher script (renames files by arrival order)

Write this script to disk and start it via the `Monitor` tool **before** asking the user to click. It pre-records files already in `~/下载/` so it only acts on new ones.

```bash
#!/bin/bash
# /tmp/cover_watcher.sh
DEST=/home/jianxiong/<output-dir>/covers
SRC=/home/jianxiong/下载
declare -A SEEN
i=0
for f in $SRC/Gemini_Generated_Image_*.png; do [ -f "$f" ] && SEEN["$f"]=1; done
echo "watching $SRC for new Gemini files..."
while [ $i -lt N_COVERS ]; do
  for f in "$SRC"/Gemini_Generated_Image_*.png; do
    [ -f "$f" ] || continue
    if [ -z "${SEEN[$f]:-}" ]; then
      i=$((i+1))
      idx=$(printf "%02d" $i)
      target="$DEST/$idx-cover.png"
      mv "$f" "$target"
      echo "[$i/N] $f -> $target"
      SEEN["$f"]=1
    fi
  done
  sleep 1
done
echo "all N covers received"
```

Start with `Monitor({command: "/tmp/cover_watcher.sh", persistent: false, timeout_ms: 600000})`. Each rename emits one stdout line → one Claude-side notification. You'll know exactly when each cover lands.

### Cover prompt template (battle-tested)

```
Generate a 16:9 cinematic premium tech-magazine cover. Style: hyper-detailed
cyberpunk concept art like a Marvel/Blade Runner movie poster — deep black
background, dramatic god-rays of light, volumetric fog, depth of field,
octane render quality, 8K detail.
Color palette: electric blue and cyan dominant, BUT punctuated with WARM
AMBER/ORANGE embers, hot magenta accents, and golden glints — NOT monochrome.
Subject: "<topic-specific scene with 2–3 concrete visual elements>".
No text, no letters, no logos, no watermark.
Ultra detailed, dark cinematic, depth of field, 16:9 aspect ratio.
```

**Critical**: writing only "blue cyan palette" yields monochrome / dull covers. Always force `NOT monochrome` and explicit warm accent colors.

### Subject-line tips for theme-based articles

For abstract themes, anchor each cover on **2–3 concrete visual elements** that map to that article's specific layer. **Lean on the literal meaning of the theme** when it has one — e.g. "harness" literally means a horse harness; the first cover in that series should picture an actual horse + harness, not just "scaffolding around a core". Concrete > abstract.

| Article slot | Good visual anchors |
|---|---|
| 概念 / 起源（or theme namesake） | the literal object the theme is named after, glowing/translucent, plus a CPU/crystal "soul" inside |
| 核心循环 / 机制 | an infinite loop of light orbiting a black monolith, particles streaming in and out |
| 上下文 / 内存 | translucent layered glass shelves holding glowing tokens, some compressed, some discarded |
| 工具 / 权限 | a lattice of interlocking gates, some open green, some sealed crimson, all ringed in cyan |
| 长任务 / 多代理 | three figures of light in formation, each in its own cone of color, sharing a central artifact |
| 实战 / 工程经验 | a cracked arena floor with hot embers, a perfect runway of light cutting through |
| 未来 / 开放问题 | a horizon dissolving into a starfield, a half-built bridge of light extending forward |

### Step 4.4 — Save the prompts to disk

Always emit `<output-dir>/cover-prompts.md` next to the articles, recording:
- Exact prompt text used for each cover
- The visual anchors / motifs each one corresponds to
- The reusable "style preamble" + "no-text trailer" so the user can re-roll any cover by hand

Treat this file with the same seriousness as `abstracts.md` — it is part of the deliverable, not throwaway scaffolding. It lets the user regenerate any cover later without going back to chat history.

### Things that DO NOT work (don't waste time on them)

- ❌ `fetch(blob://gemini...)` from JS tool — content-script context, can't read page-context blobs
- ❌ POST base64 to `http://127.0.0.1:8765` — HTTPS Gemini blocks mixed content
- ❌ `xclip` clipboard transfer — likely not installed and `apt` is often broken
- ❌ JS-triggered `<a download>` from a canvas blob — Chrome blocks programmatic downloads after the first user-gesture
- ❌ Synthetic `MouseEvent`/`PointerEvent` dispatch on the download button — same trust issue
- ❌ `mcp__claude-in-chrome__computer left_click` at the button's coords — also fails on the 2nd+ download in the same tab
- ✅ **The reliable path is the user clicking the in-page "下载完整尺寸" button by hand**, with a watcher script renaming files by arrival order

### Step 4.5 — High-resolution screenshot fallback (if user can't click)

If the user is unavailable to click downloads, you can still capture each image at 1024×572 by:

1. Cloning the target `<img>` to a fresh fixed-position element at left:0,top:0 with `width/height` set to its `naturalWidth/naturalHeight`
2. Adding a black overlay underneath (`position: fixed; z-index: 99998`) to hide other UI
3. `mcp__claude-in-chrome__computer zoom` with region `[0,0,naturalWidth,naturalHeight]` and `save_to_disk: true`
4. The saved PNG is exactly 1024×572 — the actual Gemini output, just routed through the screenshot tool

Quality is identical to the in-page download. Use this when the human-in-the-loop is not possible.

### Local PIL fallback (last resort)

If `mcp__claude-in-chrome__*` is entirely unavailable, generate covers locally with PIL using a coherent design system (gradient background + bold CJK title + small subtitle + abstract motif). The result is 1600×900 PNG but visibly more "diagrammatic" than Gemini's photoreal output. Document this as a degradation in the README. Always prefer Gemini path if any browser tooling works.

## Stage 5 — Abstracts (≤ N chars each)

Write one combined `<output-dir>/abstracts.md` with one `## XX · title` block per article. Validate length precisely:

```python
import re
t = open('abstracts.md').read()
parts = re.split(r'^## ', t, flags=re.M)[1:]
for i, p in enumerate(parts):
    body = re.sub(r'\s', '', p.split('\n', 1)[1].strip())
    print(f'{i}: {len(body)}')
```

**Note**: "200 汉字" practically means "200 non-whitespace characters total" including English filenames. Initial drafts almost always overflow — budget 2–3 compression rounds.

## Stage 6 — Index README + persist (optional)

Always emit a top-level README that lists all articles with:
- Title + 1-line hook
- Cover thumbnail
- Estimated reading time
- Citations count

Optionally save the workflow learnings to MemPalace (`mempalace_add_drawer`).

## File-naming convention

```
<output-dir>/
├── README.md
├── 01-<topic>.md
├── 02-<topic>.md
├── ...
├── abstracts.md
└── covers/
    ├── 01-cover.png
    ├── 02-cover.png
    └── ...
```

## Typical end-to-end time

~30–40 minutes for 6–7 articles + covers + abstracts (web research ~5min, parallel writers ~10–15min, serial covers ~10min, abstracts ~5min).

## Series-finale rule

The last article should include:
- A "系列总结" recapping all N articles in one paragraph each
- A global comparison table or roadmap matrix
- A "未来展望" section pointing to open research questions

## Quality checklist before delivering

- [ ] All N articles ≥ length floor
- [ ] All articles use the same numbering / emoji / structural style
- [ ] No two articles redefine the same primary concept
- [ ] Each article cites ≥ 5 primary sources at end
- [ ] All cover images are 1376×768 (Gemini) or 1600×900 (PIL fallback)
- [ ] All cover images have warm accent colors, not monochrome
- [ ] All abstracts ≤ user's specified char limit (verified with python)
- [ ] Series-finale article has 系列总结 + global table + roadmap
- [ ] README.md indexes everything with covers and reading times

## Anti-patterns specific to theme-based series

1. **Don't write a "definition" section in every article.** Only article 1 owns the definition. Other articles should *reference* it ("see article 1 §2"), not redefine.
2. **Don't write 6 articles on the same source.** If 4 articles all cite the same Anthropic blog post as their primary source, you've split the theme too thinly.
3. **Don't conflate "summary of source X" with "article on theme topic Y".** An article should *synthesize* across 5+ sources, not paraphrase one.
4. **Beware fabricated citations.** Every URL in 参考资料 must come from your actual `WebSearch` / `WebFetch` results — never invent.
5. **Beware date drift.** When citing 2025/2026 work, sanity-check that the date is plausible for the claim. Don't backdate or postdate to fit the narrative.
