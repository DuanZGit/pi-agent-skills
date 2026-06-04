#!/bin/bash
# 菜品制作引擎 v2 - 详细食谱、多种做法、精确用量
# 用法: ./dish-engine-v2.sh <菜名> [版本]

DB_DISHES="$(dirname "$0")/../db/dishes-v2.db"
DISH=${1:-"help"}
VERSION=${2:-""}

# 初始化数据库
init_db() {
  if [ ! -f "$DB_DISHES" ]; then
    echo "初始化菜品数据库..."
    sqlite3 "$DB_DISHES" < "$(dirname "$0")/../db/dishes-v2-schema.sql"
    sqlite3 "$DB_DISHES" < "$(dirname "$0")/../db/dishes-v2-data.sql"
    echo "初始化完成！"
  fi
}

# 查询菜品完整食谱
query_dish() {
  local dish_id=$(sqlite3 "$DB_DISHES" "SELECT id FROM dishes WHERE name LIKE '%$DISH%' LIMIT 1;")
  
  if [ -z "$dish_id" ]; then
    echo "未找到菜品: $DISH"
    echo ""
    echo "可用菜品："
    list_dishes
    return
  fi
  
  echo "============================================================"
  echo "【$DISH - 完整食谱】"
  echo "============================================================"
  
  # 如果指定了版本
  if [ -n "$VERSION" ]; then
    local version_id=$(sqlite3 "$DB_DISHES" "SELECT id FROM dish_versions WHERE dish_id=$dish_id AND version_name LIKE '%$VERSION%' LIMIT 1;")
    if [ -n "$version_id" ]; then
      show_version $version_id
    else
      echo "未找到版本: $VERSION"
      echo ""
      list_versions $dish_id
    fi
  else
    # 显示所有版本
    local versions=$(sqlite3 "$DB_DISHES" "SELECT id, version_name, style, difficulty, time_minutes, servings FROM dish_versions WHERE dish_id=$dish_id;")
    
    local count=$(echo "$versions" | wc -l)
    
    if [ "$count" -eq 1 ]; then
      # 只有一个版本，直接显示
      local vid=$(echo "$versions" | cut -d'|' -f1)
      show_version $vid
    else
      # 多个版本，列出让用户选择
      echo "本菜有 $count 种做法："
      echo ""
      sqlite3 -header -column "$DB_DISHES" "
        SELECT version_name as 做法, style as 口味, difficulty as 难度, 
               time_minutes || '分钟' as 时间, servings || '人份' as 份量
        FROM dish_versions WHERE dish_id=$dish_id;
      "
      echo ""
      echo "请输入版本名称查看详细食谱，如："
      echo "  ./dish-engine-v2.sh $DISH 家常版"
      echo "  ./dish-engine-v2.sh $DISH 餐厅版"
    fi
  fi
}

# 显示单个版本的详细食谱
show_version() {
  local vid=$1
  
  # 版本信息
  sqlite3 "$DB_DISHES" "
    SELECT d.name || ' - ' || v.version_name || '（' || v.style || '）'
    FROM dishes d JOIN dish_versions v ON d.id=v.dish_id
    WHERE v.id=$vid;
  "
  echo "============================================================"
  
  # 基本信息
  sqlite3 -header -column "$DB_DISHES" "
    SELECT difficulty as 难度, time_minutes || '分钟' as 时间, 
           servings || '人份' as 份量, description as 简介
    FROM dish_versions WHERE id=$vid;
  "
  
  # 食材清单
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "【食材清单】"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  local categories=$(sqlite3 "$DB_DISHES" "SELECT DISTINCT category FROM dish_ingredients WHERE version_id=$vid ORDER BY id;")
  
  for cat in $categories; do
    echo ""
    echo "▶ $cat"
    sqlite3 "$DB_DISHES" "
      SELECT '  ' || name || '：' || amount || unit || 
             CASE WHEN optional=1 THEN '（可选）' ELSE '' END ||
             CASE WHEN substitute IS NOT NULL THEN ' [可替换：' || substitute || ']' ELSE '' END
      FROM dish_ingredients 
      WHERE version_id=$vid AND category='$cat'
      ORDER BY id;
    "
  done
  
  # 食材科学原理
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "【食材科学】"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  sqlite3 "$DB_DISHES" "
    SELECT '【' || name || '】' || science
    FROM dish_ingredients 
    WHERE version_id=$vid AND science IS NOT NULL
    ORDER BY id;
  "
  
  # 制作步骤
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "【制作步骤】"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  local current_phase=""
  sqlite3 "$DB_DISHES" "
    SELECT step_order || '|' || phase || '|' || action || '|' || description || '|' || 
           COALESCE(duration,'-') || '|' || COALESCE(temperature,'-') || '|' || 
           COALESCE(visual,'-') || '|' || COALESCE(science,'-') || '|' || 
           COALESCE(tips,'-') || '|' || COALESCE(common_mistakes,'-')
    FROM dish_steps 
    WHERE version_id=$vid
    ORDER BY step_order;
  " | while IFS='|' read -r order phase action desc duration temp visual science tips mistakes; do
    # 打印阶段标题
    if [ "$phase" != "$current_phase" ]; then
      echo ""
      echo "【$phase】"
      echo "------------------------------------------------------------"
      current_phase=$phase
    fi
    
    echo ""
    echo "步骤$order：$action"
    echo "  操作：$desc"
    
    if [ "$duration" != "-" ]; then
      echo "  时间：$duration"
    fi
    if [ "$temp" != "-" ]; then
      echo "  温度：$temp"
    fi
    if [ "$visual" != "-" ]; then
      echo "  判断：$visual"
    fi
    if [ "$science" != "-" ]; then
      echo "  原理：$science"
    fi
    if [ "$tips" != "-" ]; then
      echo "  技巧：$tips"
    fi
    if [ "$mistakes" != "-" ]; then
      echo "  ⚠️ 避免：$mistakes"
    fi
  done
  
  # 总结
  echo ""
  echo "============================================================"
  echo "【成功关键】"
  echo "============================================================"
  
  # 提取关键技巧
  sqlite3 "$DB_DISHES" "
    SELECT '- ' || tips
    FROM dish_steps 
    WHERE version_id=$vid AND tips IS NOT NULL AND tips != '-'
    LIMIT 5;
  "
  
  echo ""
  echo "============================================================"
  echo "【常见错误】"
  echo "============================================================"
  
  sqlite3 "$DB_DISHES" "
    SELECT '- ' || common_mistakes
    FROM dish_steps 
    WHERE version_id=$vid AND common_mistakes IS NOT NULL AND common_mistakes != '-'
    LIMIT 5;
  "
}

# 列出所有菜品
list_dishes() {
  sqlite3 -header -column "$DB_DISHES" "
    SELECT name as 菜品, description as 简介
    FROM dishes ORDER BY name;
  "
}

# 列出菜品的所有版本
list_versions() {
  local dish_id=$1
  sqlite3 -header -column "$DB_DISHES" "
    SELECT version_name as 做法, style as 口味, difficulty as 难度, 
           time_minutes || '分钟' as 时间, description as 简介
    FROM dish_versions WHERE dish_id=$dish_id;
  "
}

# 显示帮助
show_help() {
  echo "============================================================"
  echo "菜品制作引擎 v2 - 详细食谱、多种做法、精确用量"
  echo "============================================================"
  echo ""
  echo "用法: ./dish-engine-v2.sh <菜名> [版本]"
  echo ""
  echo "查询食谱："
  echo "  ./dish-engine-v2.sh 红烧肉          # 查看所有做法"
  echo "  ./dish-engine-v2.sh 红烧肉 家常版   # 查看家常版详细食谱"
  echo "  ./dish-engine-v2.sh 番茄炒蛋 多汁版"
  echo "  ./dish-engine-v2.sh 清蒸鱼 经典版"
  echo ""
  echo "可用菜品："
  list_dishes
  echo ""
  echo "食谱包含："
  echo "  - 精确用量（克、毫升、茶匙、汤匙）"
  echo "  - 详细步骤（操作、时间、温度、判断标准）"
  echo "  - 科学原理（为什么这样做）"
  echo "  - 实用技巧（怎么做得更好）"
  echo "  - 常见错误（怎么避免失败）"
  echo "============================================================"
}

# 初始化数据库
init_db

# 根据参数执行
case $DISH in
  "help"|"-h"|"--help")
    show_help
    ;;
  *)
    query_dish
    ;;
esac
