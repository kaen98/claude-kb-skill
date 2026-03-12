# 增量更新项目知识库

根据最近的代码变更，**只更新受影响的知识库文档**，避免全量重扫。

## 执行步骤

### Step 1：找出变更文件

如果 $ARGUMENTS 为空，则自动检测最近变更：
```bash
# 获取上次知识库更新后变更的文件
git diff --name-only HEAD~1 HEAD
# 或者获取未提交的变更
git diff --name-only
git diff --name-only --cached
```

如果 $ARGUMENTS 不为空，则将其作为变更文件列表处理。

### Step 2：判断影响范围

根据变更文件类型，决定需要更新哪些知识库文档：

| 变更文件类型 | 需要更新的知识库文档 |
|------------|-----------------|
| `*Service*.java` | `business-flows.md` |
| `*Controller*.java` | `api-contracts.md` |
| `*Entity*.java` / `*DTO*.java` | `data-models.md` |
| `*Config*.java` / `pom.xml` | `index.md` |
| 多个模块同时变更 | `index.md` + 对应文档 |

### Step 3：读取并更新对应文档

1. 阅读变更的源文件
2. 阅读对应的知识库文档（`.claude/knowledge/`）
3. **只修改受影响的部分**，保留其他内容不变
4. 更新 `.claude/knowledge/index.md` 底部的更新记录：

```markdown
## 更新记录
- {datetime} | commit: {hash} | 更新了 {模块名} 的 {业务流程/数据模型/接口}
```

### Step 4：输出更新摘要

告诉用户：
- 检测到哪些文件变更
- 更新了哪些知识库文档的哪些部分
- 是否有新增的业务逻辑建议补充说明
