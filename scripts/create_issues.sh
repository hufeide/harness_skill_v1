#!/bin/bash
echo "[INFO] Creating GitHub issues based on project plan..."

# 检查是否有 GitHub token
if [ -z "$GITHUB_TOKEN" ]; then
  echo "[WARN] GITHUB_TOKEN not set. Skipping issue creation."
  echo "设置：export GITHUB_TOKEN='ghp_...'"
  exit 0
fi

# 使用 gh CLI 创建 issues
if ! command -v gh &> /dev/null; then
  echo "[WARN] gh CLI not installed. Please install first:"
  echo "  - macOS: brew install gh"
  echo "  - Linux: curl -fsSL https://cli.github.com/packages/install.sh | sudo bash -s"
  exit 1
fi

# 检查是否在 git 仓库中
if ! git rev-parse --git-dir &> /dev/null; then
  echo "[ERROR] Not a git repository. Please run in a git repo first."
  exit 1
fi

# 从项目计划读取 issue 内容
PLAN_FILE="docs/plans/latest-plan.md"
if [ ! -f "$PLAN_FILE" ]; then
  echo "[WARN] No plan file found at $PLAN_FILE"
  echo "请先在 docs/plans/ 创建计划文档"
  exit 0
fi

# 创建 issue
if gh issue create --title "待办任务" --body "$(cat "$PLAN_FILE")" &> /dev/null; then
  echo "[INFO] Issue created successfully."
else
  echo "[ERROR] Failed to create issue. Check your GitHub permissions."
  exit 1
fi