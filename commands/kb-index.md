# 建立项目知识库索引

你的任务是**扫描当前项目，生成结构化知识库文档**，存储到 `.claude/knowledge/` 目录。

## 执行步骤

### Step 1：扫描项目结构
```
find . -type f \( -name "*.java" -o -name "*.kt" -o -name "*.xml" \) \
  ! -path "*/target/*" ! -path "*/.git/*" | sort
```

### Step 2：识别核心模块
重点扫描以下文件，理解业务职责：
- `*Service*.java` — 业务逻辑
- `*Controller*.java` / `*Router*.java` — API 入口
- `*Entity*.java` / `*Model*.java` / `*DTO*.java` — 数据模型
- `*Mapper*.java` / `*Repository*.java` — 数据访问
- `*Config*.java` — 配置和装配

### Step 3：生成知识库文档

创建 `.claude/knowledge/` 目录，生成以下文件：

#### `.claude/knowledge/index.md`
包含：
- 项目概述（1-2句话）
- 模块列表（名称、职责、关键类）
- 技术栈
- 最后更新时间和 git commit hash

#### `.claude/knowledge/business-flows.md`
包含：
- 识别出的主要业务流程（如：下单、支付、退款）
- 每个流程的触发点 → 关键步骤 → 结果
- 涉及的 Service 方法调用链

#### `.claude/knowledge/data-models.md`
包含：
- 核心实体列表
- 每个实体的关键字段和业务含义
- 实体间关系

#### `.claude/knowledge/api-contracts.md`
包含：
- 所有 Controller/Router 暴露的接口
- 每个接口的：路径、方法、入参、出参、业务用途

### Step 4：生成完成后输出摘要

告诉用户：
- 共扫描了多少个文件
- 识别出哪些核心模块
- 生成了哪些知识库文档
- 建议用户检查哪些地方是否需要补充
