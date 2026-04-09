---
name: repo-to-blog-series
description: Turn an open-source GitHub repo into a multi-article CSDN-style technical blog series with cinematic Gemini covers and ≤200-char abstracts. Use when the user provides a GitHub URL and asks to "analyze this codebase and write N articles in the same format as my existing series", especially when they want to mirror an existing series style (e.g. OpenClaw → MemPalace), parallelize the writing across subagents, generate matching cover images via gemini.google.com, and end with a short abstract per article. Trigger phrases: "基于这个仓库写系列博客", "参考xxx系列写后续几篇", "分析代码库 + 写文章 + 生成封面 + 总结摘要".
---

# Repo → Blog Series Skill

End-to-end workflow that turns one GitHub repo into a deep technical blog series with covers and abstracts. Validated end-to-end on 2026-04-09 (mempalace v3.0.14 → 4 articles + 4 covers + 4 abstracts in ~25 min).

## When to invoke

The user gives you:
- a GitHub repo URL
- "参考某系列的格式，写不少于 N 篇深度文章" (or equivalent)
- optionally: cover image generation, abstract generation, save-to-memory, push-to-github

## Core principles

1. **Parallelize the writing.** N articles = N background `Agent` subagents fired simultaneously. Each one is self-contained — it cannot see the main conversation.
2. **Each subagent gets a non-overlapping file slice** of the repo. Listing what they MUST NOT cover is more important than listing what they should.
3. **Mirror an existing series format** by reading the user's reference articles first (browser → CSDN → extract title/TOC/code-block style/cover image).
4. **Don't dump article bodies back into the main context.** Subagents return only `{path, char_count, one-line summary}`.
5. **Use the user's installed memory system** (MemPalace) to persist learnings between runs.

## Stage 1 — Setup & research

```bash
# Create task list
TaskCreate for: research, N articles, covers, abstracts, (memory save), (github push)

# Browse the reference series the user wants to mirror
mcp__claude-in-chrome__navigate → CSDN article URL
# Extract the cover image style
javascript_tool: get first <article> img src; screenshot it; analyze (dark / glow / 16:9 etc.)

# Clone target repo
cd /tmp && git clone --depth 1 <repo_url> repo_src
cd repo_src/<package_dir>
wc -l *.py | sort -rn   # rank files by size — biggest = deepest module
```

Read README + small entry files (`__init__.py`, `config.py`, `__main__.py`) to build a mental model.

## Stage 2 — Plan article division

Carve N articles by **module semantics**, not line count. Typical patterns:
- Article 1: architecture / philosophy / data model
- Article 2: ingestion / mining / parsing
- Article 3: indexing / retrieval / knowledge representation
- Article 4: serving / CLI / hooks / practical guide (acts as series finale)

Each article ≥ 8000 Chinese characters. List which source files belong to which article — **and which files are off-limits to which agent**.

## Stage 3 — Parallel writing (the critical step)

Fire N `Agent({subagent_type: "general-purpose", run_in_background: true})` calls in parallel. Each prompt MUST contain:

1. **Series context**: name, position, what the previous N-1 articles already covered
2. **Reference style description**: title format, section numbering (一/1.1/1.1.1), emoji headers, ASCII boxed diagrams, real code blocks with language tags + file refs, comparison tables, "Why" rationale paragraphs, "下篇预告" + 参考文献 sections
3. **The exact source files this agent owns** (absolute paths under `/tmp/repo_src/...`)
4. **The ranges this agent MUST NOT touch** (so the 4 agents don't all rewrite the same content)
5. **Output path** (e.g. `/home/jianxiong/doc/<series>-NN-<topic>.md`)
6. **Length floor**: ≥ 8000 zh chars, depth-first
7. **Reporting rule**: "回报路径 + 字数 + 一句话总结，**不要把正文贴回来**" — saves main-thread context

While the agents run (5–10 min), do other work (e.g. cover generation).

## Stage 4 — Cover generation via Gemini browser automation

### Read the reference cover style

```javascript
// On the reference CSDN article page
Array.from(document.querySelectorAll('article img'))
  .filter(i => i.naturalWidth > 400)
  .map(i => ({src: i.src, w: i.naturalWidth, h: i.naturalHeight}))
```
Then `navigate` to the image URL and `screenshot` to see it.

### Generate covers

1. Open `https://gemini.google.com/app`
2. **Click 发起新对话** to avoid being locked into a previous session's style
3. Click the chat textbox, type the prompt, **click the 发送 button** (Enter key sometimes does NOT submit on Gemini — use the button)
4. Wait ~25–30 seconds
5. Click the latest "下载完整尺寸" download button:
   ```javascript
   Array.from(document.querySelectorAll('button'))
     .filter(b => (b.getAttribute('aria-label')||'').includes('下载完整尺寸'))
     .pop().click()
   ```
6. The PNG lands in `~/下载/Gemini_Generated_Image_*.png` at 1376×768

### Cover prompt template (battle-tested)

```
Generate a 16:9 cinematic premium tech-magazine cover. Style reference:
hyper-detailed cyberpunk concept art like a Marvel/Blade Runner movie poster
— deep black background with rich colorful highlights, dramatic god-rays of
light, volumetric fog, depth of field, octane render quality, 8K detail.
Color palette: electric blue and cyan dominant, BUT punctuated with WARM
AMBER/ORANGE embers, hot magenta accents, and golden glints — NOT monochrome.
Subject: "<topic-specific scene with 2–3 concrete visual elements>".
No text, no letters, no logos, no watermark.
Ultra detailed, dark cinematic, depth of field, 16:9 aspect ratio.
```

**Critical**: writing only "blue cyan palette" yields monochrome / dull covers. Always force `NOT monochrome` and explicit warm accent colors.

### Things that DO NOT work (don't waste time on them)

- ❌ `fetch(blob://gemini...)` from JS tool — page-context blob, content-script can't read
- ❌ POST base64 to `http://127.0.0.1:8765` — HTTPS Gemini blocks mixed content
- ❌ `xclip` clipboard transfer — likely not installed and `apt` is often broken
- ❌ JS-triggered `<a download>` — Chrome blocks programmatic data: URL downloads
- ✅ The ONLY reliable path is clicking Gemini's own "下载完整尺寸" button → file lands in `~/下载/`

## Stage 5 — Abstracts (≤ N chars each)

Write one combined `<series>-NN-MM-abstracts.md` with one `## XX · title` block per article. Validate length precisely:

```python
import re
t = open('abstracts.md').read()
parts = re.split(r'^## ', t, flags=re.M)[1:]
for i, p in enumerate(parts):
    body = re.sub(r'\s', '', p.split('\n', 1)[1].strip())
    print(f'{i}: {len(body)}')
```

**Note**: "200 汉字" practically means "200 non-whitespace characters total" including English filenames. Initial drafts almost always overflow — budget 2–3 compression rounds.

## Stage 6 — Persist & sync (optional)

- Save the workflow learnings to MemPalace (`mempalace_add_drawer`) so the next run benefits from the gotchas you discovered
- If the user has a skills repo on GitHub, push `~/.claude/skills/repo-to-blog-series/` there

## File-naming convention

```
/home/jianxiong/doc/
├── <series>-NN-<short-topic>.md
├── <series>-cover-NN.png
└── <series>-NN-MM-abstracts.md
```

## Typical end-to-end time

~25 minutes for 4 articles + 4 covers + 4 abstracts (parallel writers ~10min, serial covers ~10min, abstracts ~5min).

## Series-finale rule

The last article in the series should include:
- A "系列总结" recapping all N articles
- A global comparison table vs the reference series (e.g. MemPalace vs OpenClaw across all 8 dimensions)
- A "未来展望" / roadmap section

## Quality checklist before delivering

- [ ] All N articles ≥ length floor
- [ ] All articles use the same numbering / emoji / structural style
- [ ] No two articles cover the same source file in depth
- [ ] All cover images are 1376×768 (or at least 16:9)
- [ ] All cover images have warm accent colors, not monochrome
- [ ] All abstracts ≤ user's specified char limit (verified with python)
- [ ] Series-finale article has 系列总结 + global comparison + roadmap
