# Pi 技能索引

> 本目录是 Pi Coding Agent 的所有技能根。Pi 启动时扫描每个子目录的 `SKILL.md` 决定是否加载。

## 当前技能清单(8 个)

| 技能 | 大小 | 用途 | 触发示例 |
|------|------|------|----------|
| [communication-tips](./communication-tips/) | 72 行 SKILL.md | 话术/提示词/官方媒体参考 | "帮我写祝福语" |
| [config-all](./config-all/) | 841 行 SKILL.md | 统一配置管理(OpenClaw/系统/应用/容器/云) | "配置 Nginx" |
| [daily-knowledge](./daily-knowledge/) | 350 行 SKILL.md | 日常知识问答(科学性支撑) | "番茄怎么做" |
| [deepwiki](./deepwiki/) | 105 行 SKILL.md | GitHub 仓库文档查询(DeepWiki MCP) | "这个项目怎么用" |
| [evomap](./evomap/) | 793 行 SKILL.md | EvoMap evolver VM 接入(SSH/协议/Hub API) | "evomap worker" |
| [ima-skill](./ima-skill/) | 285 行 SKILL.md | 腾讯 IMA 笔记/知识库 API | "添加网页到知识库" |
| [skill-cleaner](./skill-cleaner/) | 56 行 SKILL.md | 审计 skill 预算/使用/重复 | "审计 skills" |

## 工具目录

- [_tools/](./_tools/) — 维护工具(lint-skills.sh)

## 备份目录

- `.bak-20260615-rootscripts-merge/` — 2026-06-15 清理前的根副本(可删除)

## 体检

```bash
bash ~/.pi/agent/skills/_tools/lint-skills.sh
```

## 同步到 VM

本目录通过 `tar | ssh` 整体同步到 VM 的 `~/.openclaw/skills/`。

## 技能添加/删除流程

1. **新增**：创建 `<skill-name>/SKILL.md` + `scripts/` + `raw/`（如需要）
2. **删除**：`rm -rf <skill-name>/`（Pi 下次启动自动不加载）
3. **修改**：直接编辑，`SKILL.md` 改完 Pi 下次启动会重读
