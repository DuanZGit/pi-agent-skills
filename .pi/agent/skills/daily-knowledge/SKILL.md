---
name: daily-knowledge
description: "日常知识问答：科学常识、生活技巧、健康知识、烹饪食谱、营养分析。基于 Karpathy LLM Wiki 模式，自动构建结构化知识库。"
---

# 日常知识问答

## 基于 Karpathy LLM Wiki 模式

### 核心理念
- **原始资料** 存入 `raw/` 目录
- **LLM 自动编译** 成结构化 Wiki 页面
- **查询时直接从 Wiki 获取**，不用每次重新搜索
- **知识会随时间积累和改进**

### 目录结构
```
daily-knowledge/
├── raw/                    ← 原始资料（不可变）
│   ├── recipes/            ← 食谱
│   ├── techniques/         ← 烹饪技巧
│   ├── nutrition/          ← 营养知识
│   └── chemistry/          ← 食品化学
│
├── wiki/                   ← 编译后的知识页面
│   ├── recipes/            ← 食谱 Wiki
│   ├── ingredients/        ← 食材 Wiki
│   ├── techniques/         ← 技巧 Wiki
│   ├── chemistry/          ← 化学反应 Wiki
│   ├── nutrition/          ← 营养 Wiki
│   ├── index.md            ← 全局目录
│   └── log.md              ← 操作日志
│
└── db/                     ← SQLite 数据库（保留）
    ├── cooking-knowledge.db
    ├── dishes-v2.db
    └── nutrition-v2.db
```

## 用户只需说
- "番茄怎么做好吃？"
- "美拉德反应是什么？"
- "红烧肉的做法"
- "蒸和煮哪个更健康？"

## Agent 处理流程

### 1. 查询 Wiki
```bash
# 搜索 Wiki 页面
bash scripts/wiki-query.sh query <关键词>

# 显示页面内容
bash scripts/wiki-query.sh show <页面名>

# 列出所有页面
bash scripts/wiki-query.sh list

# 显示统计信息
bash scripts/wiki-query.sh stats
```

### 2. 查询数据库（补充）
```bash
# 查询烹饪原理
bash scripts/query-cooking-db.sh <类型> [关键词]

# 查询菜品食谱
bash scripts/dish-engine-v2.sh <菜名> [版本]

# 查询营养信息
bash scripts/nutrition-query.sh <类型> [关键词]
```

### 3. 查询权威信息源
```bash
# 查询权威信息
bash scripts/fetch-knowledge.sh <关键词> [来源]
```

## Wiki 页面格式

每个 Wiki 页面包含：
1. **快速信息** - 分类、难度、时间等
2. **核心原理** - 科学原理、化学反应
3. **关键食材** - 食材特性、营养成分
4. **制作步骤** - 详细步骤、科学原理
5. **营养信息** - 营养成分、健康建议
6. **常见问题** - Q&A
7. **相关概念** - 交叉引用 [[概念名]]
8. **相关食谱** - 关联食谱
9. **标签** - 分类标签

## 交叉引用

Wiki 页面使用 `[[概念名]]` 建立交叉引用：
- 食谱 → 食材、化学反应、营养
- 食材 → 营养、食谱、搭配
- 化学反应 → 食谱、食材、健康影响
- 营养 → 食材、化学反应、健康建议

## 数据来源

### 权威机构
- 中国食物成分表
- USDA食品数据库
- 中国营养学会
- 世界卫生组织(WHO)
- 国家卫健委

### 专业知识
- 食品化学教材
- 营养学研究文献
- 中国烹饪协会

## 知识库内容

### Wiki 页面
- 食谱：红烧肉、番茄炒蛋、清蒸鱼等
- 食材：番茄、鸡蛋、猪肉等
- 化学反应：美拉德反应、焦糖化反应等
- 营养：维生素C、铁、番茄红素等
- 技巧：炒、蒸、煮、炖等

### SQLite 数据库
- 烹饪原理库：80KB（7个表，83条）
- 示例菜品库：64KB（4个表，200+条）
- 营养化学库：92KB（6个表，70条）

## 使用示例

### 示例1：查询番茄
```
用户：番茄怎么做好吃？

Agent：
1. 查询 Wiki：找到 [[番茄]] 页面
2. 查询相关食谱：[[番茄炒蛋]]、[[番茄蛋汤]]
3. 查询搭配建议：番茄+橄榄油、番茄+鸡蛋
4. 返回完整回答
```

### 示例2：查询美拉德反应
```
用户：美拉德反应是什么？

Agent：
1. 查询 Wiki：找到 [[美拉德反应]] 页面
2. 返回反应机理、温度条件、生成物
3. 关联食谱：红烧肉、煎牛排、烤面包
```

### 示例3：查询红烧肉
```
用户：红烧肉怎么做？

Agent：
1. 查询 Wiki：找到 [[红烧肉]] 页面
2. 返回核心原理、关键食材、制作步骤
3. 关联概念：焦糖化反应、美拉德反应、胶原蛋白水解
```

## 扩展知识库

### 添加新食谱
1. 创建原始资料：`raw/recipes/日期-菜名.md`
2. 编译成 Wiki 页面：`wiki/recipes/菜名.md`
3. 更新索引：`wiki/index.md`
4. 记录日志：`wiki/log.md`

### 添加新食材
1. 创建原始资料：`raw/nutrition/日期-食材名.md`
2. 编译成 Wiki 页面：`wiki/ingredients/食材名.md`
3. 更新索引和日志

### 添加新概念
1. 创建原始资料：`raw/chemistry/日期-概念名.md`
2. 编译成 Wiki 页面：`wiki/chemistry/概念名.md`
3. 更新索引和日志
