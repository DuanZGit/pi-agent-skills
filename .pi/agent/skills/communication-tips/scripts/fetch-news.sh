#!/bin/bash
# 官方媒体资讯获取脚本
# 用法: ./fetch-news.sh [类型] [数量]

TYPE=${1:-"all"}
COUNT=${2:-5}

echo "========================================="
echo "获取官方媒体资讯"
echo "========================================="

# 人民日报
fetch_people() {
  echo ""
  echo "【人民日报】"
  echo "来源: www.people.com.cn"
  echo "-----------------------------------"
  curl -sL --connect-timeout 5 "http://www.people.com.cn/" 2>/dev/null | \
    grep -oP '<a[^>]*>[^<]{10,}</a>' | \
    head -$COUNT | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//' | \
    grep -v '^$' || echo "（获取失败，请访问 people.com.cn）"
}

# 新华社
fetch_xinhua() {
  echo ""
  echo "【新华社】"
  echo "来源: www.xinhuanet.com"
  echo "-----------------------------------"
  curl -sL --connect-timeout 5 "http://www.xinhuanet.com/" 2>/dev/null | \
    grep -oP '<a[^>]*>[^<]{10,}</a>' | \
    head -$COUNT | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//' | \
    grep -v '^$' || echo "（获取失败，请访问 xinhuanet.com）"
}

# 央视新闻
fetch_cctv() {
  echo ""
  echo "【央视新闻】"
  echo "来源: news.cctv.com"
  echo "-----------------------------------"
  curl -sL --connect-timeout 5 "https://news.cctv.com/" 2>/dev/null | \
    grep -oP '<a[^>]*>[^<]{10,}</a>' | \
    head -$COUNT | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//' | \
    grep -v '^$' || echo "（获取失败，请访问 news.cctv.com）"
}

# 央广网
fetch_cnr() {
  echo ""
  echo "【央广网】"
  echo "来源: www.cnr.cn"
  echo "-----------------------------------"
  curl -sL --connect-timeout 5 "https://www.cnr.cn/" 2>/dev/null | \
    grep -oP '<a[^>]*>[^<]{10,}</a>' | \
    head -$COUNT | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//' | \
    grep -v '^$' || echo "（获取失败，请访问 cnr.cn）"
}

# 求是杂志
fetch_qstheory() {
  echo ""
  echo "【求是网】"
  echo "来源: www.qstheory.cn"
  echo "-----------------------------------"
  curl -sL --connect-timeout 5 "https://www.qstheory.cn/" 2>/dev/null | \
    grep -oP '<a[^>]*>[^<]{10,}</a>' | \
    head -$COUNT | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//' | \
    grep -v '^$' || echo "（获取失败，请访问 qstheory.cn）"
}

# 学习强国
fetch_xuexi() {
  echo ""
  echo "【学习强国】"
  echo "来源: www.xuexi.cn"
  echo "-----------------------------------"
  echo "学习强国需登录访问，请直接访问 xuexi.cn"
}

# 根据参数选择来源
case $TYPE in
  "people"|"人民日报")
    fetch_people
    ;;
  "xinhua"|"新华社")
    fetch_xinhua
    ;;
  "cctv"|"央视")
    fetch_cctv
    ;;
  "cnr"|"央广")
    fetch_cnr
    ;;
  "qstheory"|"求是")
    fetch_qstheory
    ;;
  "xuexi"|"学习强国")
    fetch_xuexi
    ;;
  *)
    echo ""
    echo "【获取所有官方媒体资讯】"
    fetch_people
    fetch_xinhua
    fetch_cctv
    fetch_cnr
    fetch_qstheory
    ;;
esac

echo ""
echo "========================================="
echo "【使用提示】"
echo "1. 以上为官方媒体最新资讯"
echo "2. 建议直接访问网站获取完整内容"
echo "3. 引用时请注明来源"
echo "========================================="
