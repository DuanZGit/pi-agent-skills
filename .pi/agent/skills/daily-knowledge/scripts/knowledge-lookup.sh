#!/bin/bash
# 知识查询辅助脚本
# 用法: ./knowledge-lookup.sh <问题类型> [关键词]

TYPE=${1:-"general"}
KEYWORD=${2:-""}

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
  "health"|"健康")
    echo "【健康知识回答模板】"
    echo ""
    echo "【一句话结论】"
    echo "[直接回答，不废话]"
    echo ""
    echo "【通俗解释】"
    echo "[用比喻说明，就像......]"
    echo ""
    echo "【实用建议】"
    echo "1. [可执行的具体做法]"
    echo "2. [可执行的具体做法]"
    echo ""
    echo "【权威来源】"
    echo "信息来源：国家卫健委/中国营养学会（年份）"
    echo ""
    echo "【温馨提示】"
    echo "以上为一般性知识，如有身体不适请及时就医"
    ;;
    
  "life"|"生活")
    echo "【生活技巧回答模板】"
    echo ""
    echo "【结论】"
    echo "[最有效的方法是......]"
    echo ""
    echo "【原理解释】"
    echo "[为什么这样做有效，用比喻]"
    echo ""
    echo "【具体步骤】"
    echo "1. [第一步]"
    echo "2. [第二步]"
    echo "3. [第三步]"
    echo ""
    echo "【替代方案】"
    echo "[如果没有XX材料，还可以......]"
    ;;
    
  "science"|"科学")
    echo "【科学原理回答模板】"
    echo ""
    echo "【一句话解释】"
    echo "[直接说明原理]"
    echo ""
    echo "【通俗比喻】"
    echo "[用生活中的例子类比]"
    echo ""
    echo "【延伸知识】"
    echo "[相关的有趣事实]"
    ;;
    
  *)
    echo "【通用回答模板】"
    echo ""
    echo "【结论】"
    echo "[直接回答问题]"
    echo ""
    echo "【解释】"
    echo "[为什么是这样]"
    echo ""
    echo "【建议】"
    echo "[具体该怎么做]"
    ;;
esac

echo ""
echo "-----------------------------------"
echo "$SOURCES"

if [ -n "$KEYWORD" ]; then
  echo ""
  echo "【关键词】$KEYWORD"
  echo "建议优先搜索：科普中国、人民日报健康版"
fi
