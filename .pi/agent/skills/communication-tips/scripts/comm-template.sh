#!/bin/bash
# 话术模板生成脚本
# 用法: ./comm-template.sh <场景> [关系亲疏]

SCENE=${1:-"general"}
RELATION=${2:-"normal"}

echo "========================================="
echo "场景: $SCENE | 关系: $RELATION"
echo "========================================="

case $SCENE in
  "sick"|"生病"|"不舒服")
    echo ""
    echo "【场景】朋友/家人生病"
    echo "【要点】关心 + 具体帮助 + 祝福"
    echo ""
    case $RELATION in
      "close"|"亲密")
        echo "【亲密版】"
        echo "怎么啦？严不严重？要不要我陪你去医院？"
        echo "今天好好休息，有什么需要随时说"
        ;;
      "formal"|"正式")
        echo "【正式版】"
        echo "得知您身体不适，希望早日康复。如有需要，请随时告知"
        ;;
      *)
        echo "【普通版】"
        echo "听说你不太舒服，好好休息"
        echo "有什么需要帮忙的尽管说，祝早日康复"
        ;;
    esac
    echo ""
    echo "【避免】只说'多喝热水'（太敷衍）"
    ;;
    
  "reject"|"拒绝"|"借钱")
    echo ""
    echo "【场景】委婉拒绝"
    echo "【要点】肯定信任 + 说明困难 + 表达歉意"
    echo ""
    case $RELATION in
      "close"|"亲密")
        echo "【亲密版】"
        echo "最近我也手头紧，真不好意思"
        echo "等我缓过来一定帮你想想办法"
        ;;
      "formal"|"正式")
        echo "【正式版】"
        echo "非常感谢您的信任，但目前情况确实不允许，还望理解"
        ;;
      *)
        echo "【普通版】"
        echo "感谢你信任我，但我最近确实有困难"
        echo "帮不上忙，真的很抱歉"
        ;;
    esac
    echo ""
    echo "【避免】编造具体理由（容易穿帮）"
    ;;
    
  "festival"|"节日"|"祝福")
    echo ""
    echo "【场景】节日祝福"
    echo "【要点】简洁 + 正面 + 有温度"
    echo ""
    case $RELATION in
      "close"|"亲密")
        echo "【亲密版】"
        echo "新的一年，希望你身体健康，工作顺利，咱们有空多聚聚！"
        ;;
      "formal"|"正式")
        echo "【正式版】"
        echo "恭祝新春愉快，阖家安康，事业蒸蒸日上！"
        ;;
      *)
        echo "【普通版】"
        echo "值此新春佳节，祝您阖家幸福，万事如意！"
        ;;
    esac
    echo ""
    echo "【避免】群发感，要加入个性化内容"
    ;;
    
  "thank"|"感谢")
    echo ""
    echo "【场景】表达感谢"
    echo "【要点】具体说明感谢什么 + 对你的意义"
    echo ""
    case $RELATION in
      "close"|"亲密")
        echo "【亲密版】"
        echo "太谢谢你了！那天要不是你帮忙，我真不知道怎么办"
        ;;
      "formal"|"正式")
        echo "【正式版】"
        echo "承蒙关照，不胜感激。如有需要，请随时告知"
        ;;
      *)
        echo "【普通版】"
        echo "非常感谢你的帮助，真的帮了我大忙"
        ;;
    esac
    ;;
    
  "sorry"|"道歉"|"迟到")
    echo ""
    echo "【场景】表达歉意"
    echo "【要点】承认问题 + 简要原因 + 改进措施"
    echo ""
    case $RELATION in
      "close"|"亲密")
        echo "【亲密版】"
        echo "不好意思来晚了！路上堵车，下次我提前出门"
        ;;
      "formal"|"正式")
        echo "【正式版】"
        echo "非常抱歉，因XX原因未能准时到达，今后一定避免"
        ;;
      *)
        echo "【普通版】"
        echo "抱歉迟到了，临时有点事耽误了，下次一定注意"
        ;;
    esac
    echo ""
    echo "【避免】找借口、过度道歉"
    ;;
    
  "marriage"|"催婚"|"催生")
    echo ""
    echo "【场景】应对催婚/催生"
    echo "【要点】不正面冲突 + 转移话题"
    echo ""
    echo "【温和版】"
    echo "谢谢关心，我在努力呢，有好消息一定第一时间告诉您"
    echo ""
    echo "【转移版】"
    echo "哈哈，缘分到了自然就有了。对了，您家XX最近怎么样？"
    echo ""
    echo "【幽默版】"
    echo "我也着急呢，您要是有合适的给我介绍介绍呗"
    ;;
    
  *)
    echo ""
    echo "【通用话术原则】"
    echo "1. 得体大方：不卑不亢，有理有据"
    echo "2. 温暖真诚：有温度但不煽情"
    echo "3. 简洁有力：不啰嗦，重点突出"
    echo "4. 分寸恰当：根据关系亲疏调整语气"
    echo ""
    echo "【官媒风格参考】"
    echo "- 值此XX之际，致以XX问候"
    echo "- 承蒙关照，不胜感激"
    echo "- 恭祝XX，阖家XX"
    ;;
esac
