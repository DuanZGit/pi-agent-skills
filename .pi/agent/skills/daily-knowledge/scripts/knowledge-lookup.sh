#!/bin/bash
# 知识查询辅助脚本
# 用法: ./knowledge-lookup.sh <问题类型> [关键词]

TYPE=${1:-"general"}
KEYWORD=${2:-""}

if [ "$TYPE" = "/dk" ]; then
  shift
  TYPE=${1:-"food"}
  KEYWORD=${2:-""}
fi

# 权威信息源
SOURCES='
【权威信息源】
- 世界卫生组织(WHO)
- 国家卫健委
- 中国营养学会
- 中华医学会
- 人民日报
- 新华社
- 科普中国
- 丁香医生
'

# 回答模板
case $TYPE in
  "/dk")
    TYPE=${1:-"food"}
    KEYWORD=${2:-""}
    ;;
  "health"|"健康"|"food"|"食物"|"recipe"|"菜品"|"做法")
    # 食材/菜品问题必须带量化营养、机理和引用源
    echo "已触发daily knowledge技能"
    echo ""
    echo "【正文】"
    echo "[先给直接可执行的结论]"
    echo ""
    echo "【量化营养】"
    echo "- 蛋白质：xxx g/100g"
    echo "- 脂肪：xxx g/100g"
    echo "- 碳水：xxx g/100g"
    echo "- 热量：xxx kcal/100g"
    echo "- 必要时补充：维生素、矿物质、GI"
    echo ""
    echo "【机理】"
    echo "- 美拉德反应 / 焦糖化 / 蛋白质变性 / 淀粉糊化 / 氧化 / 脂溶与水溶迁移"
    echo ""
    echo "【引用源】"
    echo "1. [本地raw或数据库路径]"
    echo "2. [权威网站或文献链接]"
    echo ""
    echo "【不确定项】"
    echo "- 暂无可靠数据的部分要明确标注"
    ;;
    
  "life"|"生活")
    echo "已触发daily knowledge技能"
    echo ""
    echo "【正文】"
    echo "[先给直接可执行的结论]"
    echo ""
    echo "【原理】"
    echo "[为什么这样做有效]"
    echo ""
    echo "【步骤】"
    echo "1. [第一步]"
    echo "2. [第二步]"
    echo "3. [第三步]"
    echo ""
    echo "【引用源】"
    echo "1. [来源]"
    echo "2. [来源]"
    ;;
    
  "science"|"科学")
    echo "已触发daily knowledge技能"
    echo ""
    echo "【正文】"
    echo "[一句话结论]"
    echo ""
    echo "【原理】"
    echo "[底层机制]"
    echo ""
    echo "【引用源】"
    echo "1. [来源]"
    echo "2. [来源]"
    ;;
    
  *)
    echo "已触发daily knowledge技能"
    echo ""
    echo "【正文】"
    echo "[直接回答问题]"
    echo ""
    echo "【引用源】"
    echo "1. [来源]"
    ;;
esac

echo ""
echo "-----------------------------------"
echo "$SOURCES"
echo ""
echo "【来源规则】"
echo "- 优先输出页级原始网页"
echo "- 只能到站点级时，明确标注 site-level"
echo "- 不要把首页/站点级链接冒充成具体条目页"

if [ -n "$KEYWORD" ]; then
  echo ""
  echo "【关键词】$KEYWORD"
  echo "建议优先搜索：科普中国、人民日报健康版"
fi
