#!/bin/bash
# Karpathy Wiki 查询脚本
# 用法: ./wiki-query.sh <操作> [参数]

WIKI_DIR="$(dirname "$0")/../wiki"
RAW_DIR="$(dirname "$0")/../raw"
OPERATION=${1:-"help"}
QUERY=${2:-""}

# 查询 Wiki
query_wiki() {
  echo "============================================================"
  echo "【Wiki 查询】"
  echo "============================================================"
  echo ""
  echo "查询: $QUERY"
  echo ""
  
  # 搜索 Wiki 页面
  echo "【匹配的 Wiki 页面】"
  echo "------------------------------------------------------------"
  
  local found=0
  
  # 搜索食谱
  for file in "$WIKI_DIR/recipes/"*.md; do
    if [ -f "$file" ]; then
      local name=$(basename "$file" .md)
      if echo "$name" | grep -qi "$QUERY"; then
        echo "📄 食谱: $name"
        echo "   路径: $file"
        # 提取摘要
        head -5 "$file" | grep -v "^#" | grep -v "^$" | head -1
        echo ""
        found=1
      fi
    fi
  done
  
  # 搜索食材
  for file in "$WIKI_DIR/ingredients/"*.md; do
    if [ -f "$file" ]; then
      local name=$(basename "$file" .md)
      if echo "$name" | grep -qi "$QUERY"; then
        echo "🥬 食材: $name"
        echo "   路径: $file"
        head -5 "$file" | grep -v "^#" | grep -v "^$" | head -1
        echo ""
        found=1
      fi
    fi
  done
  
  # 搜索化学反应
  for file in "$WIKI_DIR/chemistry/"*.md; do
    if [ -f "$file" ]; then
      local name=$(basename "$file" .md)
      if echo "$name" | grep -qi "$QUERY"; then
        echo "🧪 化学反应: $name"
        echo "   路径: $file"
        head -5 "$file" | grep -v "^#" | grep -v "^$" | head -1
        echo ""
        found=1
      fi
    fi
  done
  
  # 搜索营养知识
  for file in "$WIKI_DIR/nutrition/"*.md; do
    if [ -f "$file" ]; then
      local name=$(basename "$file" .md)
      if echo "$name" | grep -qi "$QUERY"; then
        echo "💊 营养: $name"
        echo "   路径: $file"
        head -5 "$file" | grep -v "^#" | grep -v "^$" | head -1
        echo ""
        found=1
      fi
    fi
  done
  
  # 搜索技巧
  for file in "$WIKI_DIR/techniques/"*.md; do
    if [ -f "$file" ]; then
      local name=$(basename "$file" .md)
      if echo "$name" | grep -qi "$QUERY"; then
        echo "🔪 技巧: $name"
        echo "   路径: $file"
        head -5 "$file" | grep -v "^#" | grep -v "^$" | head -1
        echo ""
        found=1
      fi
    fi
  done
  
  if [ $found -eq 0 ]; then
    echo "未找到匹配的 Wiki 页面"
  fi
}

# 显示 Wiki 页面内容
show_page() {
  local page_path=""
  
  # 搜索所有目录
  for dir in recipes ingredients chemistry nutrition techniques; do
    for file in "$WIKI_DIR/$dir/"*.md; do
      if [ -f "$file" ]; then
        local name=$(basename "$file" .md)
        if [ "$name" = "$QUERY" ]; then
          page_path="$file"
          break 2
        fi
      fi
    done
  done
  
  if [ -n "$page_path" ]; then
    echo "============================================================"
    echo "【Wiki 页面】"
    echo "============================================================"
    cat "$page_path"
  else
    echo "未找到页面: $QUERY"
  fi
}

# 列出所有 Wiki 页面
list_pages() {
  echo "============================================================"
  echo "【Wiki 页面列表】"
  echo "============================================================"
  echo ""
  
  echo "📄 食谱 (recipes/)"
  echo "------------------------------------------------------------"
  for file in "$WIKI_DIR/recipes/"*.md; do
    if [ -f "$file" ]; then
      local name=$(basename "$file" .md)
      echo "  - $name"
    fi
  done
  
  echo ""
  echo "🥬 食材 (ingredients/)"
  echo "------------------------------------------------------------"
  for file in "$WIKI_DIR/ingredients/"*.md; do
    if [ -f "$file" ]; then
      local name=$(basename "$file" .md)
      echo "  - $name"
    fi
  done
  
  echo ""
  echo "🧪 化学反应 (chemistry/)"
  echo "------------------------------------------------------------"
  for file in "$WIKI_DIR/chemistry/"*.md; do
    if [ -f "$file" ]; then
      local name=$(basename "$file" .md)
      echo "  - $name"
    fi
  done
  
  echo ""
  echo "💊 营养知识 (nutrition/)"
  echo "------------------------------------------------------------"
  for file in "$WIKI_DIR/nutrition/"*.md; do
    if [ -f "$file" ]; then
      local name=$(basename "$file" .md)
      echo "  - $name"
    fi
  done
  
  echo ""
  echo "🔪 技巧 (techniques/)"
  echo "------------------------------------------------------------"
  for file in "$WIKI_DIR/techniques/"*.md; do
    if [ -f "$file" ]; then
      local name=$(basename "$file" .md)
      echo "  - $name"
    fi
  done
}

# 统计 Wiki 信息
show_stats() {
  echo "============================================================"
  echo "【Wiki 统计】"
  echo "============================================================"
  echo ""
  
  local total=0
  
  for dir in recipes ingredients chemistry nutrition techniques; do
    local count=$(find "$WIKI_DIR/$dir" -name "*.md" 2>/dev/null | wc -l)
    echo "  $dir: $count 个页面"
    total=$((total + count))
  done
  
  echo ""
  echo "  总计: $total 个页面"
  
  echo ""
  echo "【原始资料统计】"
  for dir in recipes techniques nutrition chemistry; do
    local count=$(find "$RAW_DIR/$dir" -name "*.md" 2>/dev/null | wc -l)
    echo "  $dir: $count 个文件"
  done
}

# 显示帮助
show_help() {
  echo "============================================================"
  echo "Karpathy Wiki 查询脚本"
  echo "============================================================"
  echo ""
  echo "用法: ./wiki-query.sh <操作> [参数]"
  echo ""
  echo "操作:"
  echo "  query <关键词>   - 搜索 Wiki 页面"
  echo "  show <页面名>    - 显示页面内容"
  echo "  list             - 列出所有页面"
  echo "  stats            - 显示统计信息"
  echo ""
  echo "示例:"
  echo "  ./wiki-query.sh query 番茄"
  echo "  ./wiki-query.sh show 红烧肉"
  echo "  ./wiki-query.sh list"
  echo "  ./wiki-query.sh stats"
  echo ""
  echo "Wiki 结构:"
  echo "  recipes/     - 食谱"
  echo "  ingredients/ - 食材"
  echo "  chemistry/   - 化学反应"
  echo "  nutrition/   - 营养知识"
  echo "  techniques/  - 烹饪技巧"
  echo "============================================================"
}

# 根据参数执行操作
case $OPERATION in
  "query"|"搜索")
    if [ -z "$QUERY" ]; then
      echo "请提供查询关键词"
      exit 1
    fi
    query_wiki
    ;;
  "show"|"显示")
    if [ -z "$QUERY" ]; then
      echo "请提供页面名称"
      exit 1
    fi
    show_page
    ;;
  "list"|"列表")
    list_pages
    ;;
  "stats"|"统计")
    show_stats
    ;;
  *)
    show_help
    ;;
esac
