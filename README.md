# 📚 claude-kb-skill

让 Claude Code 成为你项目的**业务逻辑顾问**。自动扫描项目代码，建立知识库索引，随时回答业务流程和架构问题，无需编写额外文档。

## ✨ 功能

| 命令 | 作用 |
|------|------|
| `/kb-index` | 首次扫描项目，生成知识库文档 |
| `/kb-update` | 代码变更后，增量更新知识库 |
| `/kb-ask <问题>` | 以业务顾问模式回答问题（不写代码） |

自动触发：每次 `git commit` 后，自动检测变更并提示更新知识库。

---

## 🚀 安装

在你的**项目根目录**下执行：

```bash
curl -sSL https://raw.githubusercontent.com/kaen98/claude-kb-skill/main/scripts/install.sh | bash
```

或者克隆本仓库后本地安装：

```bash
git clone https://github.com/kaen98/claude-kb-skill.git
cd your-project
bash ../claude-kb-skill/scripts/install.sh
```

---

## 📖 使用流程

### 第一次使用

```
# 在 Claude Code 中运行：
/kb-index
```

Claude 会自动扫描项目，在 `.claude/knowledge/` 下生成：

```
.claude/knowledge/
├── index.md           # 模块地图 + 技术栈
├── business-flows.md  # 业务流程（下单、支付、退款...）
├── data-models.md     # 核心数据模型
└── api-contracts.md   # 接口列表
```

### 日常使用

```bash
# 提交代码后，hook 自动提示更新
git commit -m "feat: 新增退款流程"
# → 💡 检测到变更，建议运行 /kb-update

# 或手动更新
/kb-update

# 随时提问
/kb-ask 退款流程涉及哪些服务？状态机是怎样的？
/kb-ask 订单表和支付表的关系是什么？
/kb-ask 为什么要拆分成这两个 Service？
```

### 手动脚本（在终端中使用）

```bash
./scripts/kb-update.sh              # 更新最近一次 commit 的变更
./scripts/kb-update.sh --full       # 全量重建知识库
./scripts/kb-update.sh --since "2024-01-01"  # 更新某日期后的变更
```

---

## 🗂 安装后的项目结构

```
your-project/
├── .claude/
│   ├── commands/
│   │   ├── kb-ask.md       ← /kb-ask 命令
│   │   ├── kb-index.md     ← /kb-index 命令
│   │   └── kb-update.md    ← /kb-update 命令
│   └── knowledge/          ← 自动生成的知识库（建议提交到 git）
│       ├── index.md
│       ├── business-flows.md
│       ├── data-models.md
│       └── api-contracts.md
├── .git/hooks/
│   └── post-commit         ← 自动触发提示
└── scripts/
    └── kb-update.sh        ← 手动更新脚本
```

---

## 💡 建议

**知识库文件要提交到 Git 吗？**

推荐提交，理由：
- 团队成员共享同一份知识库
- 新人 clone 项目后立刻可以提问
- 知识库随代码一起有版本历史

```bash
git add .claude/
git commit -m "chore: add claude kb skill"
```

如果希望本地私有，加入 `.gitignore`：
```
.claude/knowledge/
```

---

## 🔧 自定义

如果你的项目有特殊背景，可以在 `.claude/commands/kb-index.md` 中补充项目专属说明，覆盖默认行为。

---

## 📋 系统要求

- [Claude Code](https://docs.anthropic.com/claude-code) 已安装
- Git 项目
- 支持语言：Java / Kotlin（可自行修改命令中的文件扫描规则适配其他语言）
