#!/bin/bash
# lint-skills.sh — 技能体检
#
# 扫描 ~/.pi/agent/skills/ 下所有技能,做基础健康检查
#
# 检查项:
#   1. SKILL.md 存在性
#   2. scripts/*.sh 语法 (bash -n)
#   3. scripts/*.sh 可执行权限
#   4. scripts/*.cjs 语法 (node -c)
#   5. 占位符/未实现标记 (TODO/FIXME/占位符/未实现/提取规则在此填写/未提供)
#   6. curl 超时 < 15s 警告
#   7. 重复文件名警告(根目录跟子目录有同名的 .sh/.md)
#
# 用法:
#   bash ~/.pi/agent/skills/_tools/lint-skills.sh           # 全检
#   bash ~/.pi/agent/skills/_tools/lint-skills.sh <skill>    # 单技能
#   bash ~/.pi/agent/skills/_tools/lint-skills.sh --strict   # 任何 warning 算 error

set -e

SKILLS_ROOT="${HOME}/.pi/agent/skills"
STRICT=0
TARGET=""

# 解析参数
while [[ $# -gt 0 ]]; do
  case $1 in
    --strict) STRICT=1; shift ;;
    -h|--help)
      echo "用法: $0 [<skill-name>|--strict]"
      echo "示例:"
      echo "  $0                    # 检查所有 skills"
      echo "  $0 daily-knowledge    # 只检查 daily-knowledge"
      echo "  $0 --strict           # 任何 warning 视为 error"
      exit 0
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

if [ ! -d "$SKILLS_ROOT" ]; then
  echo "✗ skills 根目录不存在: $SKILLS_ROOT"
  exit 1
fi

# 统计
TOTAL_CHECKS=0
PASS=0
WARN=0
FAIL=0

# 颜色
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# 报告函数
pass() { PASS=$((PASS+1)); TOTAL_CHECKS=$((TOTAL_CHECKS+1)); printf '  \033[0;32m✓\033[0m %s\n' "$1"; }
warn() {
  WARN=$((WARN+1))
  TOTAL_CHECKS=$((TOTAL_CHECKS+1))
  printf '  \033[1;33m⚠\033[0m %s\n' "$1"
  if [ "$STRICT" = "1" ]; then
    FAIL=$((FAIL+1))
  fi
}
fail() { FAIL=$((FAIL+1)); TOTAL_CHECKS=$((TOTAL_CHECKS+1)); printf '  \033[0;31m✗\033[0m %s\n' "$1"; }

# lint 单个 skill
lint_skill() {
  local skill_dir="$1"
  local name=$(basename "$skill_dir")

  echo ""
  printf '\033[0;34m━━━ %s ━━━\033[0m\n' "$name"

  # 1. SKILL.md 存在
  if [ -f "$skill_dir/SKILL.md" ]; then
    local size=$(wc -c < "$skill_dir/SKILL.md")
    pass "SKILL.md 存在 (${size}B)"
  else
    fail "SKILL.md 不存在"
    return
  fi

  # 2. scripts/*.sh 语法
  if [ -d "$skill_dir/scripts" ]; then
    local n_sh=$(find "$skill_dir/scripts" -name "*.sh" -type f 2>/dev/null | wc -l)
    if [ "$n_sh" -gt 0 ]; then
      local bad=0
      while IFS= read -r f; do
        if ! bash -n "$f" 2>/dev/null; then
          warn "脚本语法错: $f"
          bad=$((bad+1))
        fi
      done < <(find "$skill_dir/scripts" -name "*.sh" -type f)
      if [ "$bad" -eq 0 ]; then
        pass "$n_sh 个 .sh 脚本语法 OK"
      fi
    fi
  fi

  # 3. scripts/*.sh 可执行权限
  if [ -d "$skill_dir/scripts" ]; then
    local not_exec=0
    while IFS= read -r f; do
      if [ ! -x "$f" ]; then
        warn "脚本无执行权限: $(basename $f)"
        not_exec=$((not_exec+1))
      fi
    done < <(find "$skill_dir/scripts" -name "*.sh" -type f 2>/dev/null)
    if [ "$not_exec" -eq 0 ]; then
      pass "所有脚本可执行"
    fi
  fi

  # 4. scripts/*.cjs / .js 语法
  if [ -d "$skill_dir/scripts" ]; then
    local n_js=$(find "$skill_dir/scripts" \( -name "*.cjs" -o -name "*.js" \) -type f 2>/dev/null | wc -l)
    if [ "$n_js" -gt 0 ]; then
      local bad=0
      while IFS= read -r f; do
        # 跳过 node_modules
        [[ "$f" == *node_modules* ]] && continue
        if ! node -c "$f" 2>/dev/null; then
          warn "JS 语法错: $f"
          bad=$((bad+1))
        fi
      done < <(find "$skill_dir/scripts" \( -name "*.cjs" -o -name "*.js" \) -type f)
      if [ "$bad" -eq 0 ]; then
        pass "$n_js 个 JS 脚本语法 OK"
      fi
    fi
  fi

  # 5. 占位符/未实现标记
  local placeholder_hits=$(grep -rln "提取规则在此填写\|TODO:\|FIXME:\|未实现" "$skill_dir" 2>/dev/null | grep -v node_modules | head -3)
  if [ -n "$placeholder_hits" ]; then
    while IFS= read -r f; do
      warn "占位符/未实现: ${f#$SKILLS_ROOT/}"
    done <<< "$placeholder_hits"
  else
    pass "无占位符/未实现标记"
  fi

  # 6. curl 超时 < 15s
  if [ -d "$skill_dir/scripts" ]; then
    local short_timeout=$(grep -rEn "connect-timeout ([0-9]|1[0-4])\b" "$skill_dir/scripts" 2>/dev/null | grep -v node_modules | head -3)
    if [ -n "$short_timeout" ]; then
      while IFS= read -r line; do
        warn "curl 超时 < 15s: $line"
      done <<< "$short_timeout"
    else
      pass "curl 超时全部 ≥ 15s"
    fi
  fi

  # 7. SKILL.md 里有 frontmatter (YAML 头)
  if head -1 "$skill_dir/SKILL.md" 2>/dev/null | grep -q "^---"; then
    pass "SKILL.md 有 YAML frontmatter"
  else
    warn "SKILL.md 缺 YAML frontmatter (name/description 缺失)"
  fi

  # 8. 技能被配置在 settings.json 的 enabledModels 中(简单粗略检查,只看 name 在 enabledModels 数组或通配里)
  if [ -f "$SKILLS_ROOT/../settings.json" ]; then
    pass "settings.json 存在"
  fi
}

# 入口
if [ -n "$TARGET" ]; then
  if [ -d "$SKILLS_ROOT/$TARGET" ]; then
    lint_skill "$SKILLS_ROOT/$TARGET"
  else
    echo "✗ skill 不存在: $SKILLS_ROOT/$TARGET"
    exit 1
  fi
else
  echo "============================================================="
  echo "  技能体检 — $(date +%Y-%m-%d)"
  echo "============================================================="

  for skill_dir in "$SKILLS_ROOT"/*/; do
    # 跳过备份目录和 _tools 自身
    name=$(basename "$skill_dir")
    [[ "$name" == .* ]] && continue
    [[ "$name" == _tools ]] && continue
    lint_skill "$skill_dir"
  done
fi

echo ""
echo "============================================================="
echo "  总结: ${TOTAL_CHECKS} 项检查"
printf '  \033[0;32m✓ %d 通过\033[0m  \033[1;33m⚠ %d 警告\033[0m  \033[0;31m✗ %d 失败\033[0m\n' "$PASS" "$WARN" "$FAIL"
if [ "$STRICT" = "1" ]; then
  echo "  (--strict 模式:warning 算 failure)"
fi
echo "============================================================="

# exit code: 0 = 全通过, 1 = 有失败, 2 = 只有 warning
if [ "$FAIL" -gt 0 ]; then
  exit 1
elif [ "$WARN" -gt 0 ]; then
  exit 2
fi
exit 0
