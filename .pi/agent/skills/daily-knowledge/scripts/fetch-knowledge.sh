#!/bin/bash
# 权威信息源查询脚本
# 用法: ./fetch-knowledge.sh <关键词> [来源]

KEYWORD=${1:-"健康"}
SOURCE=${2:-"all"}

echo "========================================="
echo "查询关键词: $KEYWORD"
echo "========================================="

# 科普中国搜索
fetch_kepuzg() {
  echo ""
  echo "【科普中国】"
  echo "来源: www.kepuzhongguo.com"
  echo "-----------------------------------"
  # 科普中国的搜索接口
  url="https://www.kepuzhongguo.com/search?keyword=$KEYWORD"
  echo "搜索链接: $url"
  echo ""
  # 尝试抓取搜索结果摘要
  curl -sL --connect-timeout 5 "$url" 2>/dev/null | \
    grep -oP '<div class="search-item">.*?</div>' | \
    head -3 | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//' | \
    grep -v '^$' || echo "（暂无结果，请直接访问网站查询）"
}

# 人民日报健康频道
fetch_rmrb_health() {
  echo ""
  echo "【人民日报健康客户端】"
  echo "来源: health.people.com.cn"
  echo "-----------------------------------"
  url="http://health.people.com.cn/GB/search.html?keyword=$KEYWORD"
  echo "搜索链接: $url"
  echo ""
  curl -sL --connect-timeout 5 "$url" 2>/dev/null | \
    grep -oP '<a[^>]*>.*?</a>' | \
    grep -i "$KEYWORD" | \
    head -5 | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//' || echo "（暂无结果，请直接访问网站查询）"
}

# 新华网健康频道
fetch_xinhua_health() {
  echo ""
  echo "【新华网健康】"
  echo "来源: www.xinhuanet.com/health"
  echo "-----------------------------------"
  url="http://www.xinhuanet.com/health/"
  echo "健康频道: $url"
  echo ""
  # 抓取最新健康资讯标题
  curl -sL --connect-timeout 5 "$url" 2>/dev/null | \
    grep -oP '<a[^>]*title="[^"]*">[^<]*</a>' | \
    head -5 | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//' || echo "（暂无结果，请直接访问网站查询）"
}

# 丁香医生
fetch_dxy() {
  echo ""
  echo "【丁香医生】"
  echo "来源: www.dxy.com"
  echo "-----------------------------------"
  url="https://www.dxy.com/search?keyword=$KEYWORD"
  echo "搜索链接: $url"
  echo ""
  curl -sL --connect-timeout 5 "$url" 2>/dev/null | \
    grep -oP '<div class="title">.*?</div>' | \
    head -3 | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//' || echo "（暂无结果，请直接访问网站查询）"
}

# 世界卫生组织中文
fetch_who() {
  echo ""
  echo "【世界卫生组织中文】"
  echo "来源: www.who.int/zh"
  echo "-----------------------------------"
  url="https://www.who.int/zh"
  echo "官网: $url"
  echo ""
  echo "WHO 常用健康建议:"
  echo "- 健康饮食：多吃蔬果，减少盐糖摄入"
  echo "- 适量运动：每周至少150分钟中等强度运动"
  echo "- 戒烟限酒：吸烟是可预防的首要死因"
  echo "- 心理健康：保持社交联系，寻求帮助"
}

# 国家卫健委
fetch_nhc() {
  echo ""
  echo "【国家卫生健康委员会】"
  echo "来源: www.nhc.gov.cn"
  echo "-----------------------------------"
  url="http://www.nhc.gov.cn/"
  echo "官网: $url"
  echo ""
  # 抓取最新公告
  curl -sL --connect-timeout 5 "$url" 2>/dev/null | \
    grep -oP '<a[^>]*>[^<]*</a>' | \
    grep -E '健康|卫生|医疗' | \
    head -5 | \
    sed 's/<[^>]*>//g' | \
    sed 's/^[[:space:]]*//' || echo "（暂无结果，请直接访问网站查询）"
}

# 中国营养学会
fetch_cnsoc() {
  echo ""
  echo "【中国营养学会】"
  echo "来源: www.cnsoc.org"
  echo "-----------------------------------"
  url="https://www.cnsoc.org/"
  echo "官网: $url"
  echo ""
  echo "常用营养建议:"
  echo "- 每日饮水：1500-1700毫升"
  echo "- 膳食纤维：25-30克/天"
  echo "- 食盐摄入：不超过5克/天"
  echo "- 食用油：25-30克/天"
}

# 根据参数选择来源
case $SOURCE in
  "kepuzg"|"科普")
    fetch_kepuzg
    ;;
  "rmrb"|"人民日报")
    fetch_rmrb_health
    ;;
  "xinhua"|"新华")
    fetch_xinhua_health
    ;;
  "dxy"|"丁香")
    fetch_dxy
    ;;
  "who"|"世卫")
    fetch_who
    ;;
  "nhc"|"卫健委")
    fetch_nhc
    ;;
  "cnsoc"|"营养")
    fetch_cnsoc
    ;;
  *)
    echo ""
    echo "【查询所有权威来源】"
    fetch_who
    fetch_nhc
    fetch_cnsoc
    fetch_kepuzg
    fetch_dxy
    ;;
esac

echo ""
echo "========================================="
echo "【使用提示】"
echo "1. 以上为权威来源的查询链接和摘要"
echo "2. 建议直接访问网站获取最新、最准确信息"
echo "3. 健康问题请咨询专业医生"
echo "========================================="
