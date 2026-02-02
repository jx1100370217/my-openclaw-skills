---
name: csdn-blog-publisher
description: Write and publish technical blog posts to CSDN (China's largest developer community). Use when user asks to write a blog, publish an article to CSDN, create technical content for CSDN, or needs help with CSDN blog publishing workflow. Supports research, writing, formatting, cover image selection, and browser-based publishing.
---

# CSDN Blog Publisher

Automate the complete workflow of researching, writing, and publishing technical blogs to CSDN.

## Workflow

```
1. Research → 2. Write Draft → 3. Format → 4. Find Cover → 5. Publish via Browser
```

## Step 1: Research Content

Gather authoritative sources using `web_fetch` (not web_search):

```python
# Recommended sources by topic
SOURCES = {
    "ai_agent": [
        "https://github.com/WooooDyy/LLM-Agent-Paper-List",
        "https://arxiv.org/abs/2309.07864",  # Agent Survey
        "https://github.com/langchain-ai/langchain",
    ],
    "llm": [
        "https://github.com/Hannibal046/Awesome-LLM",
        "https://arxiv.org/list/cs.CL/recent",
    ],
    "general": [
        "https://github.com/trending",
        "https://news.ycombinator.com",
    ]
}
```

Fetch and extract key information:
```
web_fetch(url, extractMode="markdown", maxChars=50000)
```

## Step 2: Write Blog Draft

Save draft to workspace as `{topic}_Blog.md`. Follow format in [references/blog-format.md](references/blog-format.md).

**Essential elements:**
- 📑 Table of contents with emoji section headers
- 💡 "思考" (Thought) questions for reader engagement
- 📊 Comparison tables
- 💻 Code examples with syntax highlighting
- 📚 Numbered references [1], [2], [3]...

**Target:** 10,000-20,000 Chinese characters for comprehensive posts.

## Step 3: Open CSDN Editor

```python
# Navigate to CSDN Markdown editor
browser(action="open", profile="openclaw", targetUrl="https://editor.csdn.net/md?not_checkout=1")

# Wait for editor to load, then import content
browser(action="act", request={"kind": "click", "ref": "<import-button-ref>"})
```

**Key editor elements:**
- Import button: "导入"
- Publish button: "发布文章"
- Title input: "请输入文章标题"

## Step 4: Find Cover Image

Use free image sources (avoid paid services):

```python
# Pixabay (recommended - no login required)
browser(action="navigate", targetUrl="https://pixabay.com/images/search/{keyword}/")

# Download image to workspace
exec(command="curl -o cover.jpg '{image_url}'")
```

**Avoid:**
- Unsplash+ (paid images)
- Pexels (Cloudflare blocks)
- Getty/Shutterstock (paid)

## Step 5: Publish Article

### 5.1 Click Publish Button
```python
browser(action="snapshot", interactive=True)
# Find "发布文章" button and click
browser(action="act", request={"kind": "click", "ref": "<publish-btn-ref>"})
```

### 5.2 Configure Publish Settings

| Setting | Action |
|---------|--------|
| **添加封面** | Click "从本地上传", use browser upload action |
| **文章标签** | Add relevant tags (e.g., "人工智能") |
| **文章摘要** | Click "AI提取摘要" or write manually (256 chars max) |
| **文章类型** | Select "原创" for original content |
| **可见范围** | Select "全部可见" |

### 5.3 Upload Cover Image

```python
# Upload cover via file input
browser(action="upload", ref="<upload-btn-ref>", paths=["cover.jpg"])

# Confirm upload in crop dialog (uses Vue image cropper)
browser(action="act", request={
    "kind": "evaluate",
    "fn": "(function(){ var el = document.querySelector('.vicp-operate-btn'); if(el) { el.click(); return 'clicked'; } return 'not found'; })()"
})
```

### 5.4 Final Publish

```python
# Click final publish button in dialog
browser(action="act", request={"kind": "click", "ref": "<final-publish-btn-ref>"})
```

**Success indicators:**
- Green checkmark (✓) appears
- URL changes to article page
- "审核中" or "已发布" status

## Common Issues

| Issue | Solution |
|-------|----------|
| Brave API not configured | Use `web_fetch` instead of `web_search` |
| Image upload dialog stuck | Use JavaScript to click `.vicp-operate-btn` |
| Editor not loading | Check browser profile, try refresh |
| Tags not adding | Click tag input first, then type |

## Output Checklist

- [ ] Blog draft saved to workspace (`*_Blog.md`)
- [ ] Article published to CSDN
- [ ] Cover image uploaded
- [ ] Tags configured
- [ ] Article URL obtained
- [ ] Memory file updated with results

## Resources

- [references/blog-format.md](references/blog-format.md) - Blog structure and formatting guide
- [assets/blog-template.md](assets/blog-template.md) - Starter template for new blogs
