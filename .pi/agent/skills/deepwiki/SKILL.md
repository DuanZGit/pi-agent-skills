---
name: deepwiki
description: "通过 DeepWiki MCP 查询 GitHub 仓库的文档、结构和使用方法。触发词：deepwiki、如何使用、怎么用、项目文档、仓库文档、README、使用说明、项目介绍。当用户询问某个开源项目/库/框架怎么用时自动触发。"
---

# DeepWiki — GitHub 仓库文档查询

通过 DeepWiki MCP 服务查询任意 GitHub 仓库的文档和使用方法。

## 前置条件

确保 MCP 服务器 `deepwiki` 已连接。如未连接，先执行：
```
mcp({ connect: "deepwiki" })
```

## 可用工具

### 1. `deepwiki_read_wiki_structure` — 查看文档目录

获取仓库的文档主题列表（目录结构）。

```
mcp({
  tool: "deepwiki_read_wiki_structure",
  args: '{"repoName": "owner/repo"}'
})
```

**适用场景：**
- 初次了解一个项目，想知道有哪些文档
- 快速浏览项目的功能模块划分

### 2. `deepwiki_read_wiki_contents` — 读取完整文档

获取仓库的完整文档内容。

```
mcp({
  tool: "deepwiki_read_wiki_contents",
  args: '{"repoName": "owner/repo"}'
})
```

**适用场景：**
- 需要深入了解项目的架构和设计
- 阅读详细的使用说明和 API 文档

### 3. `deepwiki_ask_question` — 针对性提问

针对仓库提出具体问题，获取 AI 生成的回答。

```
mcp({
  tool: "deepwiki_ask_question",
  args: '{"repoName": "owner/repo", "question": "你的问题"}'
})
```

**适用场景：**
- 用户问"xxx 怎么配置？"
- 用户问"xxx 的 xxx 功能怎么用？"
- 用户问"xxx 和 yyy 有什么区别？"

**支持多仓库对比（最多 10 个）：**
```
mcp({
  tool: "deepwiki_ask_question",
  args: '{"repoName": ["owner/repo1", "owner/repo2"], "question": "对比这两个项目的区别"}'
})
```

## 工作流程

### 典型场景：用户问"xxx 项目怎么用"

**步骤 1：识别仓库**
- 如果用户已给出仓库名（如 `facebook/react`），直接使用
- 如果用户只说了项目名（如 "React"），先推断仓库地址（通常是 `owner/repo` 格式）
- 不确定时，先用 `deepwiki_ask_question` 搜索确认

**步骤 2：查询文档**
- 简单问题 → 直接用 `deepwiki_ask_question`
- 需要全面了解 → 先用 `deepwiki_read_wiki_structure` 查看目录，再用 `deepwiki_read_wiki_contents` 读取详细内容

**步骤 3：整理回答**
- 将查询结果整理成清晰的中文回答
- 保留关键代码示例和配置片段
- 标注信息来源（DeepWiki）

## 常见查询示例

| 用户问题 | 推荐工具 | 示例 args |
|---------|---------|----------|
| "React 怎么用？" | `deepwiki_ask_question` | `{"repoName":"facebook/react","question":"How to use React? Getting started guide."}` |
| "Vue 3 有哪些新特性？" | `deepwiki_ask_question` | `{"repoName":"vuejs/core","question":"What are the new features in Vue 3?"}` |
| "看看 Next.js 的文档目录" | `deepwiki_read_wiki_structure` | `{"repoName":"vercel/next.js"}` |
| "TailwindCSS 的配置方法" | `deepwiki_ask_question` | `{"repoName":"tailwindlabs/tailwindcss","question":"How to configure TailwindCSS?"}` |
| "对比 Vite 和 Webpack" | `deepwiki_ask_question` | `{"repoName":["vitejs/vite","webpack/webpack"],"question":"Compare Vite and Webpack, what are the key differences?"}` |

## 注意事项

- 仓库名必须是 `owner/repo` 格式（如 `facebook/react`）
- 多仓库对比最多支持 10 个仓库
- 查询结果基于 DeepWiki 的文档索引，可能不包含最新的 commit
- 如果查不到信息，建议用户直接查看 GitHub 仓库的 README