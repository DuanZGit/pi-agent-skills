#!/bin/bash
# 用法: bash scripts/wiki-query.sh query <关键词>
#       bash scripts/wiki-query.sh show <页面名>
#       bash scripts/wiki-query.sh list
#       bash scripts/wiki-query.sh stats

ACTION=$1
KEYWORD=$2

case $ACTION in
  query)
    echo "============================================================"
    echo "【Wiki 查询】"
    echo "============================================================"
    echo ""
    echo "查询: $KEYWORD"
    echo ""
    echo "【匹配的 Wiki 页面】"
    echo "------------------------------------------------------------"
    RESULTS=$(grep -rl "$KEYWORD" wiki/ 2>/dev/null | grep -v "index.md" | grep -v "log.md")
    if [ -z "$RESULTS" ]; then
      echo "未找到匹配的 Wiki 页面"
    else
      echo "$RESULTS"
    fi
    ;;
  show)
    if [ -f "wiki/$KEYWORD.md" ]; then
      cat "wiki/$KEYWORD.md"
    else
      echo "页面不存在: $KEYWORD"
    fi
    ;;
  list)
    echo "============================================================"
    echo "【Wiki 页面列表】"
    echo "============================================================"
    find wiki/ -name "*.md" -not -name "index.md" -not -name "log.md" | sort
    ;;
  stats)
    echo "============================================================"
    echo "【Wiki 统计信息】"
    echo "============================================================"
    echo "Wiki 页面总数: $(find wiki/ -name '*.md' -not -name 'index.md' -not -name 'log.md' 2>/dev/null | wc -l)"
    echo "原始资料数: $(find raw/ -name '*.md' 2>/dev/null | wc -l)"
    echo "媒体文件数: $(find wiki/media/ -type f 2>/dev/null | wc -l)"
    ;;
  *)
    echo "用法: bash scripts/wiki-query.sh <query|show|list|stats> [关键词]"
    ;;
esac
