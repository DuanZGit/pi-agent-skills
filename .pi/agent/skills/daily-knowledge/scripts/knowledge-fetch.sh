#!/bin/bash
# 日常知识查询工具 — 按优先级依次查询
# 优先级: 本地已有资料 → 权威信息源 → 已固化的权威源 → wikiHow → 其他
# 用法:
#   ./knowledge-fetch.sh <关键词>              # 按优先级自动查
#   ./knowledge-fetch.sh <关键词> <来源名>     # 只查指定来源

KEYWORD=${1:-"冰箱清洁"}
SOURCE=${2:-"auto"}
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RAW_DIR="$SKILL_DIR/raw"
CONFIG_DIR="$SKILL_DIR/config"

mkdir -p "$CONFIG_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  日常知识查询: ${KEYWORD}${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# ---------- 获取已固化的信息源配置 ----------
# 每个已成功的源在 config/success/ 下有配置文件
# 文件命名: <源名>.sh，内容: URL模板 + 提取规则
init_success_sources() {
  mkdir -p "$CONFIG_DIR/success"
  # 如果 config/success/ 里没有对应配置文件，先创建模板
  if [ ! -f "$CONFIG_DIR/success/wikihow.sh" ]; then
    cat > "$CONFIG_DIR/success/wikihow.sh" << 'TEMPLATE'
#!/bin/bash
# wikiHow 生活指南
# 状态: ✅ 可用
# 提取规则: curl + 解析 h1/li 标签
# 适用: 生活技巧、清洁指南、使用方法

SLUG=$(echo "$1" | sed 's/ /-/g')
URL="https://www.wikihow.com/$SLUG"
curl -sL --connect-timeout 8 -H "User-Agent: Mozilla/5.0" "$URL" 2>/dev/null | \
  sed -n 's/.*<h1[^>]*>\s*\([^<]*\).*/TITLE: \1/p' | head -1
echo "URL: $URL"
TEMPLATE
    chmod +x "$CONFIG_DIR/success/wikihow.sh"
  fi
}
init_success_sources

# ---------- 4. wikiHow (步骤参考) ----------
fetch_wikihow() {
  echo -e "${BOLD}[4/优先级] wikiHow 生活指南${NC}"
  echo "---"
  
  local slug=$(echo "$KEYWORD" | sed 's/ /-/g')
  local url="https://www.wikihow.com/$slug"
  
  local html=$(curl -sL --connect-timeout 8 \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" "$url" 2>/dev/null)
  
  if [ -z "$html" ] || [ ${#html} -lt 100 ]; then
    echo -e "  ${YELLOW}· 访问超时或失败${NC}"
    echo -e "  链接: $url"
    echo ""
    return
  fi
  
  local title=$(echo "$html" | grep -oP '<h1[^>]*>\s*\K[^<]+' | head -1 | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
  
  if [ -z "$title" ]; then
    echo -e "  ${YELLOW}· 页面可能不存在${NC}"
    echo -e "  链接: $url"
    echo ""
    return
  fi
  
  echo -e "  ${GREEN}✓${NC} $title"
  echo -e "  链接: $url"
  
  # 提取前3个步骤（li标签）
  local steps=$(echo "$html" | grep -oP '<li[^>]*>\s*\K[^<]' | head -3 | sed 's/^[[:space:]]*//')
  if [ -n "$steps" ]; then
    echo -e "  ${CYAN}步骤摘要:${NC}"
    echo "$steps" | while read -r line; do
      [ -n "$line" ] && echo -e "    - $line"
    done
  fi
  echo ""
}

# ---------- 2. 查本地已有资料 ----------
fetch_local() {
  echo -e "${BOLD}[2/优先级] 本地已有资料${NC}"
  echo "---"
  
  local found=0
  for f in $(find "$RAW_DIR" -name "*.md" -type f 2>/dev/null); do
    if grep -q "$KEYWORD" "$f" 2>/dev/null || echo "$f" | grep -qi "$(echo $KEYWORD | head -c 2)"; then
      local title=$(head -1 "$f" | sed 's/^# *//')
      local relpath=$(echo $f | sed "s|$SKILL_DIR/||")
      local size=$(wc -c < "$f" 2>/dev/null || echo "?")
      local lines=$(wc -l < "$f" 2>/dev/null || echo "?")
      echo -e "  ${GREEN}✓${NC} $title"
      echo -e "    路径: $relpath"
      echo -e "    大小: ${size}B, ${lines}行"
      # 显示匹配片段
      local match=$(grep -m2 "$KEYWORD" "$f" 2>/dev/null | head -2 | sed 's/^/    /')
      [ -n "$match" ] && echo -e "$match"
      echo ""
      found=1
    fi
  done
  
  if [ $found -eq 0 ]; then
    echo -e "  ${YELLOW}· 本地未找到相关内容${NC}"
    echo ""
  fi
}

# ---------- 3. 查已固化的权威源 ----------
fetch_fixed_sources() {
  echo -e "${BOLD}[3/优先级] 已固化的权威源${NC}"
  echo "---"
  
  local found_any=0
  
  if [ -d "$CONFIG_DIR/success" ]; then
    for script in "$CONFIG_DIR/success/"*.sh; do
      [ -f "$script" ] || continue
      local name=$(basename "$script" .sh)
      
      local status=$(grep "^# 状态:" "$script" 2>/dev/null | head -1 | sed 's/# 状态: *//')
      echo -e "  ${GREEN}✓${NC} $name: ${status:-可用}"
      echo -e "    方法: $(grep "^# 方法:" "$script" 2>/dev/null | head -1 | sed 's/# 方法: *//')"
      echo -e "    URL: $(grep "^# URL:" "$script" 2>/dev/null | head -1 | sed 's/# URL: *//')"
      echo -e "    用法: bash $CONFIG_DIR/success/$name.sh \"关键词\""
      echo ""
      found_any=1
    done
  fi
  
  if [ $found_any -eq 0 ]; then
    echo -e "  ${YELLOW}· 暂无已固化的权威源${NC}"
    echo -e "    提示: 爬取成功后会自动固化方法"
    echo ""
  fi
}

# ---------- 4. 通用网页查询 ----------
fetch_general() {
  echo -e "${BOLD}[4/优先级] 通用网页查询${NC}"
  echo "---"
  
  echo -e "  ${CYAN}维基百科API:${NC} https://zh.wikipedia.org/api/rest_v1/page/html/$KEYWORD"
  local wiki=$(curl -sL --connect-timeout 8 \
    "https://zh.wikipedia.org/api/rest_v1/page/html/$KEYWORD" 2>/dev/null)
  
  if [ -n "$wiki" ] && [ ${#wiki} -gt 50 ]; then
    local text=$(echo "$wiki" | sed 's/<[^>]*>//g' | sed 's/^[[:space:]]*//' | head -c 200)
    echo -e "  ${GREEN}✓${NC} $text..."
  else
    echo -e "  ${YELLOW}· 维基百科无此页面${NC}"
  fi
  echo ""
  
  echo -e "  ${CYAN}百度百科:${NC} https://baike.baidu.com/item/$KEYWORD"
  echo -e "  ${YELLOW}· 百度百科需要JS渲染，curl无法获取${NC}"
  echo ""
}

# ---------- 执行查询 ----------
case $SOURCE in
  "auto")
    fetch_wikihow
    fetch_local
    fetch_fixed_sources
    fetch_general
    ;;
  "wikihow")
    fetch_wikihow
    ;;
  "local")
    fetch_local
    ;;
  "fixed")
    fetch_fixed_sources
    ;;
  "general")
    fetch_general
    ;;
  *)
    echo "用法: $0 <关键词> [auto|wikihow|local|fixed|general]"
    ;;
esac

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  查询完成${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
echo "💡 使用提示:"
echo "  全部查询: $0 <关键词>"
echo "  只查 wikiHow: $0 <关键词> wikihow"
echo "  只查本地: $0 <关键词> local"
echo "  固化成功源: 爬取成功后运行 $0 <关键词> --save <源名>"
