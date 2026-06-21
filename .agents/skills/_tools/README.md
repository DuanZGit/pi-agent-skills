# 技能工具 (_tools/)

> Pi 内部维护性脚本,不直接给用户使用

## 内容

| 工具 | 用途 |
|------|------|
| [lint-skills.sh](./lint-skills.sh) | 技能体检:语法/权限/占位符/curl 超时 7 项检查 |

## 用法

```bash
# 全检所有技能
bash ~/.pi/agent/skills/_tools/lint-skills.sh

# 单技能检查
bash ~/.pi/agent/skills/_tools/lint-skills.sh daily-knowledge

# 严格模式(任何 warning 算 error)
bash ~/.pi/agent/skills/_tools/lint-skills.sh --strict
```

## 退出码

- `0` — 全部通过
- `1` — 有失败(必须修)
- `2` — 有警告(不阻塞,但建议修)

## 设计原则

- **轻量**: 纯 bash,无外部依赖
- **幂等**: 多次跑结果一致
- **可扩展**: 后续添加新检查项,只需在 `lint_skill()` 里加段

## 不在 _tools/ 里的

- 各技能专属脚本 → 在 `<skill>/scripts/` 下
- 技能数据(raw/wiki/db) → 在 `<skill>/` 对应子目录
- 技能索引(SKILL.md) → 在 `<skill>/SKILL.md`
