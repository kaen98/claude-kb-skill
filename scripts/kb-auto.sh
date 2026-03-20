#!/bin/bash
# scripts/kb-auto.sh
# 管理知识库自动更新模式（post-commit hook 的开关）
#
# 用法：
#   ./scripts/kb-auto.sh status   # 查看当前状态
#   ./scripts/kb-auto.sh enable   # 启用自动模式（安装 post-commit hook）
#   ./scripts/kb-auto.sh disable  # 关闭自动模式（移除 post-commit hook）

set -e

HOOK_FILE=".git/hooks/post-commit"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOK_SOURCE="$SCRIPT_DIR/../hooks/post-commit"
REPO_URL="https://raw.githubusercontent.com/kaen98/claude-kb-skill/main"

# 检查是否在 git 项目根目录
if [ ! -d ".git" ]; then
  echo "❌ 错误：请在 Git 项目根目录下执行此脚本"
  exit 1
fi

# 判断当前 hook 是否是 kb-skill 安装的
is_kb_hook() {
  [ -f "$HOOK_FILE" ] && grep -q "\[KB\]" "$HOOK_FILE" 2>/dev/null
}

show_status() {
  if is_kb_hook; then
    echo "📚 自动模式：已启用"
    echo "   每次 git commit 后会自动检测变更并提示更新知识库"
  else
    echo "📚 自动模式：未启用"
    echo "   请手动运行 /kb-update 更新知识库"
  fi
}

do_enable() {
  if is_kb_hook; then
    echo "📚 自动模式已经是启用状态，无需重复操作"
    return
  fi

  # 如果已存在其他 hook，备份
  if [ -f "$HOOK_FILE" ]; then
    echo "⚠️  已存在 post-commit hook，备份为 post-commit.bak"
    cp "$HOOK_FILE" "${HOOK_FILE}.bak"
  fi

  # 安装 hook
  if [ -f "$HOOK_SOURCE" ]; then
    cp "$HOOK_SOURCE" "$HOOK_FILE"
  else
    curl -sSL "$REPO_URL/hooks/post-commit" -o "$HOOK_FILE"
  fi

  chmod +x "$HOOK_FILE"
  echo "✅ 自动模式已启用"
  echo "   每次 git commit 后会自动检测变更并提示更新知识库"
  echo "   关闭：./scripts/kb-auto.sh disable"
}

do_disable() {
  if ! is_kb_hook; then
    echo "📚 自动模式当前未启用，无需关闭"
    return
  fi

  rm "$HOOK_FILE"

  # 如果有备份，恢复
  if [ -f "${HOOK_FILE}.bak" ]; then
    mv "${HOOK_FILE}.bak" "$HOOK_FILE"
    echo "✅ 自动模式已关闭（已恢复之前的 post-commit hook）"
  else
    echo "✅ 自动模式已关闭"
  fi

  echo "   更新知识库请手动运行 /kb-update"
}

case "${1:-status}" in
  status)
    show_status
    ;;
  enable|on)
    do_enable
    ;;
  disable|off)
    do_disable
    ;;
  *)
    echo "用法：$0 {enable|disable|status}"
    echo ""
    echo "  status   查看当前状态（默认）"
    echo "  enable   启用自动模式（安装 post-commit hook）"
    echo "  disable  关闭自动模式（移除 post-commit hook）"
    exit 1
    ;;
esac
