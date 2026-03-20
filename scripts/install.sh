#!/bin/bash
# claude-kb-skill 一键安装脚本
# 用法：
#   # 在你的项目根目录下执行：
#   curl -sSL https://raw.githubusercontent.com/kaen98/claude-kb-skill/main/scripts/install.sh | bash
#
#   # 或克隆后本地执行：
#   bash scripts/install.sh

set -e

REPO_URL="https://raw.githubusercontent.com/kaen98/claude-kb-skill/main"
PROJECT_ROOT=$(pwd)

echo ""
echo "📚 Claude KB Skill 安装程序"
echo "================================"
echo "目标项目：$PROJECT_ROOT"
echo ""

# 检查是否在 git 项目根目录
if [ ! -d ".git" ]; then
  echo "❌ 错误：请在 Git 项目根目录下执行此脚本"
  exit 1
fi

# ── 1. 安装斜杠命令 ──────────────────────────────────────────
echo "📁 安装 Claude Code 斜杠命令..."
mkdir -p .claude/commands

download_or_copy() {
  local filename=$1
  local dest=$2

  # 如果是本地执行（存在 commands/ 目录）
  if [ -f "$(dirname "$0")/../commands/$filename" ]; then
    cp "$(dirname "$0")/../commands/$filename" "$dest"
  else
    # 从 GitHub 下载
    curl -sSL "$REPO_URL/commands/$filename" -o "$dest"
  fi
}

download_or_copy "kb-ask.md"    ".claude/commands/kb-ask.md"
download_or_copy "kb-index.md"  ".claude/commands/kb-index.md"
download_or_copy "kb-update.md" ".claude/commands/kb-update.md"

echo "   ✅ /kb-ask、/kb-index、/kb-update 命令已安装"

# ── 2. 安装手动更新脚本 ──────────────────────────────────────
echo "🛠  安装手动更新脚本..."
mkdir -p scripts

if [ -f "$(dirname "$0")/../scripts/kb-update.sh" ]; then
  cp "$(dirname "$0")/../scripts/kb-update.sh" "scripts/kb-update.sh"
else
  curl -sSL "$REPO_URL/scripts/kb-update.sh" -o "scripts/kb-update.sh"
fi

chmod +x scripts/kb-update.sh
echo "   ✅ scripts/kb-update.sh 已安装"

# ── 3. 创建知识库目录 ────────────────────────────────────────
echo "📂 创建知识库目录..."
mkdir -p .claude/knowledge
if [ ! -f ".claude/knowledge/.gitkeep" ]; then
  touch .claude/knowledge/.gitkeep
fi
echo "   ✅ .claude/knowledge/ 目录已创建"

# ── 4. 提示 .gitignore ───────────────────────────────────────
echo ""
echo "💡 知识库文件建议："
echo "   • 提交到 Git（推荐）：团队共享，新人上手快"
echo "     git add .claude/ && git commit -m 'chore: add claude kb skill'"
echo ""
echo "   • 或加入 .gitignore（本地私有）："
echo "     echo '.claude/knowledge/' >> .gitignore"
echo ""

# ── 完成 ─────────────────────────────────────────────────────
echo "================================"
echo "✅ 安装完成！"
echo ""
echo "🚀 快速开始："
echo "   1. 在 Claude Code 中运行 /kb-index   ← 首次建立知识库"
echo "   2. 代码变更后运行 /kb-update 更新知识库"
echo "   3. 随时用 /kb-ask <你的问题> 查询业务逻辑"
echo ""
