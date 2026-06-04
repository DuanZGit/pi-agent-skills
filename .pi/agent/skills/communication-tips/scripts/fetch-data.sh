#!/bin/bash
# 权威数据查询脚本
# 用法: ./fetch-data.sh <数据类型> [关键词]

TYPE=${1:-"general"}
KEYWORD=${2:-""}

echo "========================================="
echo "数据类型: $TYPE | 关键词: $KEYWORD"
echo "========================================="

# 统计数据
fetch_stats() {
  echo ""
  echo "【国家统计局】"
  echo "来源: www.stats.gov.cn"
  echo "-----------------------------------"
  echo "官网: https://www.stats.gov.cn"
  echo ""
  echo "常用数据查询:"
  echo "- 人口数据: https://www.stats.gov.cn/sj/ndsj/"
  echo "- 经济数据: https://www.stats.gov.cn/sj/zxfb/"
  echo "- 年度数据: https://www.stats.gov.cn/sj/ndsj/"
  echo ""
  # 获取最新统计公报
  curl -sL --connect-timeout 5 "https://www.stats.gov.cn/" 2>/dev/null | \
    grep -oP '<a[^>]*>[^<]*统计[^<]*</a>' | \
    head -3 | \
    sed 's/<[^>]*>//g' || echo "（获取失败，请访问网站查询）"
}

# 卫生健康数据
fetch_health_data() {
  echo ""
  echo "【国家卫健委统计数据】"
  echo "来源: www.nhc.gov.cn"
  echo "-----------------------------------"
  echo "官网: http://www.nhc.gov.cn"
  echo ""
  echo "常用数据:"
  echo "- 医疗机构: http://www.nhc.gov.cn/mohwsbwstjxxzx/s7967/"
  echo "- 卫生统计: http://www.nhc.gov.cn/mohwsbwstjxxzx/s8349/"
  echo ""
  # 获取最新卫生统计
  curl -sL --connect-timeout 5 "http://www.nhc.gov.cn/" 2>/dev/null | \
    grep -oP '<a[^>]*>[^<]*统计[^<]*</a>' | \
    head -3 | \
    sed 's/<[^>]*>//g' || echo "（获取失败，请访问网站查询）"
}

# 营养数据
fetch_nutrition_data() {
  echo ""
  echo "【中国营养学会数据】"
  echo "来源: www.cnsoc.org"
  echo "-----------------------------------"
  echo "官网: https://www.cnsoc.org"
  echo ""
  echo "权威数据:"
  echo "- 中国居民膳食指南(2022)"
  echo "- 每日推荐摄入量(RNI)"
  echo "- 膳食营养素参考摄入量(DRIs)"
  echo ""
  echo "常用营养数据:"
  echo "| 营养素 | 推荐量 |"
  echo "|--------|--------|"
  echo "| 蛋白质 | 65g/天 |"
  echo "| 膳食纤维 | 25-30g/天 |"
  echo "| 钙 | 800-1000mg/天 |"
  echo "| 铁 | 12-20mg/天 |"
  echo "| 维生素C | 100mg/天 |"
}

# 气象数据
fetch_weather_data() {
  echo ""
  echo "【中国气象局】"
  echo "来源: www.cma.gov.cn"
  echo "-----------------------------------"
  echo "官网: http://www.cma.gov.cn"
  echo ""
  # 获取最新天气资讯
  curl -sL --connect-timeout 5 "http://www.cma.gov.cn/" 2>/dev/null | \
    grep -oP '<a[^>]*>[^<]*天气[^<]*</a>' | \
    head -3 | \
    sed 's/<[^>]*>//g' || echo "（获取失败，请访问网站查询）"
}

# 环境数据
fetch_env_data() {
  echo ""
  echo "【生态环境部】"
  echo "来源: www.mee.gov.cn"
  echo "-----------------------------------"
  echo "官网: https://www.mee.gov.cn"
  echo ""
  echo "常用数据:"
  echo "- 空气质量: https://www.mee.gov.cn/"
  echo "- 水质数据: https://www.mee.gov.cn/"
  echo "- 环境统计: https://www.mee.gov.cn/"
  echo ""
  # 获取最新环境资讯
  curl -sL --connect-timeout 5 "https://www.mee.gov.cn/" 2>/dev/null | \
    grep -oP '<a[^>]*>[^<]*环境[^<]*</a>' | \
    head -3 | \
    sed 's/<[^>]*>//g' || echo "（获取失败，请访问网站查询）"
}

# 经济数据
fetch_econ_data() {
  echo ""
  echo "【中国人民银行】"
  echo "来源: www.pbc.gov.cn"
  echo "-----------------------------------"
  echo "官网: http://www.pbc.gov.cn"
  echo ""
  echo "常用数据:"
  echo "- 货币政策: http://www.pbc.gov.cn/zhengcehuobisi/"
  echo "- 金融统计: http://www.pbc.gov.cn/diaochatongjisi/"
  echo "- 利率数据: http://www.pbc.gov.cn/zhengcehuobisi/"
  echo ""
  # 获取最新金融数据
  curl -sL --connect-timeout 5 "http://www.pbc.gov.cn/" 2>/dev/null | \
    grep -oP '<a[^>]*>[^<]*统计[^<]*</a>' | \
    head -3 | \
    sed 's/<[^>]*>//g' || echo "（获取失败，请访问网站查询）"
}

# 根据参数选择数据类型
case $TYPE in
  "stats"|"统计")
    fetch_stats
    ;;
  "health"|"卫生")
    fetch_health_data
    ;;
  "nutrition"|"营养")
    fetch_nutrition_data
    ;;
  "weather"|"气象")
    fetch_weather_data
    ;;
  "env"|"环境")
    fetch_env_data
    ;;
  "econ"|"经济")
    fetch_econ_data
    ;;
  *)
    echo ""
    echo "【获取所有权威数据源】"
    fetch_stats
    fetch_health_data
    fetch_nutrition_data
    fetch_weather_data
    fetch_env_data
    fetch_econ_data
    ;;
esac

echo ""
echo "========================================="
echo "【使用提示】"
echo "1. 以上为权威数据源的查询链接"
echo "2. 建议直接访问网站获取最新数据"
echo "3. 引用数据时请注明来源和时间"
echo "========================================="
