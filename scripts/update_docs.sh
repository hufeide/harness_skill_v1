#!/bin/bash
echo "[INFO] Updating documentation..."

# 获取当前分支和最近 commit
BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
LAST_COMMIT=$(git log -1 --oneline 2>/dev/null || echo "no commits")

# 更新 CLAUDE.md 的时间戳
if [ -f "CLAUDE.md" ]; then
  echo "  - CLAUDE.md 存在"
  # 可以在这里添加自动更新逻辑
fi

# 更新 CHANGELOG.md
if [ -f "CHANGELOG.md" ]; then
  echo "  - CHANGELOG.md 存在"
else
  echo "  - 创建 CHANGELOG.md"
  cat > CHANGELOG.md << EOF
# Changelog

## 未发布

### 已更改
- 初始版本
EOF
fi

# 更新项目状态
if [ -d "docs/plans" ]; then
  echo "  - docs/plans 目录存在"
else
  mkdir -p docs/plans
  echo "  - 创建 docs/plans 目录"
fi

echo ""
echo "[INFO] 当前分支：$BRANCH"
echo "[INFO] 最近提交：$LAST_COMMIT"
echo ""
echo "[INFO] 文档更新完成。"