#!/bin/bash
# scripts/kb-update.sh
# 手动触发知识库更新
# 用法：
#   ./scripts/kb-update.sh          # 更新最近一次 commit 的变更
#   ./scripts/kb-update.sh --full   # 全量重建（等同于 /kb-index）
#   ./scripts/kb-update.sh --since "2024-01-01"  # 更新某日期之后的变更

set -e

MODE="incremental"
SINCE=""

# 解析参数
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --full) MODE="full" ;;
    --since) SINCE="$2"; shift ;;
  esac
  shift
done

echo "📚 知识库更新工具"
echo "================================"

if [ "$MODE" = "full" ]; then
  echo "模式：全量重建"
  echo "正在启动 Claude Code 执行 /kb-index ..."
  claude --print "/kb-index"

elif [ -n "$SINCE" ]; then
  echo "模式：从 $SINCE 至今的增量更新"
  CHANGED=$(git log --since="$SINCE" --name-only --pretty=format: | \
    grep -E "\.(java|kt|xml)$" | grep -v "target/" | sort -u | tr '\n' ' ')
  echo "变更文件：$CHANGED"
  claude --print "/kb-update $CHANGED"

else
  echo "模式：最近一次 commit 的增量更新"
  CHANGED=$(git diff --name-only HEAD~1 HEAD | \
    grep -E "\.(java|kt|xml)$" | grep -v "target/" | tr '\n' ' ')
  echo "变更文件：$CHANGED"
  claude --print "/kb-update $CHANGED"
fi

echo ""
echo "✅ 知识库更新完成"
echo "   查看：cat .claude/knowledge/index.md"
