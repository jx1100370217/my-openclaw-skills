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

Generation is automated; **download is manual** — see "user-gesture trust" note below. Plan: read reference style, fire all N prompts in one batch, watch the download folder, ask the user to click the N download buttons in conversation order.

### Step 4.0 — Read the reference cover style (when mirroring an existing series)

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
DEST=/home/jianxiong/<output-dir>/covers     # or wherever the series lives
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
      target="$DEST/<series>-cover-$idx.png"      # match this series' file-naming convention
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

For repo-based series, anchor each cover on **2–3 concrete visual elements that map to that article's module**: ingestion → grain silos / streams; indexing → nested archive shelves; serving → glowing API gateway towers; CLI / hooks → control panels with switches; etc. Stay concrete — abstract nouns yield generic art.

### Step 4.4 — Save the prompts to disk

Always emit `<output-dir>/<series>-cover-prompts.md` next to the articles, recording:
- Exact prompt text used for each cover
- The visual anchors / motifs each one corresponds to
- The reusable "style preamble" + "no-text trailer" so the user can re-roll any cover by hand

Treat this file with the same seriousness as the abstracts file — it is part of the deliverable, not throwaway scaffolding. It lets the user regenerate any cover later without going back to chat history.

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
