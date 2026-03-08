#!/bin/bash
echo "[INFO] Checking skills and plugins..."

# 核心开发技能
CORE_SKILLS=(
  "brainstorming"
  "writing-plans"
  "test-driven-development"
  "systematic-debugging"
  "using-git-worktrees"
  "requesting-code-review"
  "verification-before-completion"
  "subagent-driven-development"
  "finishing-a-development-branch"
)

# 额外技能
EXTRA_SKILLS=(
  "andrew-kane-gem-writer"
  "create-agent-skills"
  "frontend-design"
  "git-worktree"
  "skill-creator"
)

ALL_SKILLS=("${CORE_SKILLS[@]}" "${EXTRA_SKILLS[@]}")

# 检查已安装的技能
echo ""
echo "=== 已安装的技能 ==="
INSTALLED=0
MISSING=0
for skill in "${ALL_SKILLS[@]}"; do
  # 检查是否在 .agents/skills 或通过软链接在 .claude/skills
  if [ -d "$HOME/.agents/skills/$skill" ]; then
    echo "  ✓ $skill"
    INSTALLED=$((INSTALLED + 1))
  elif [ -L "$HOME/.claude/skills/$skill" ] && [ -e "$HOME/.claude/skills/$skill" ]; then
    echo "  ✓ $skill"
    INSTALLED=$((INSTALLED + 1))
  else
    echo "  ✗ $skill (未安装)"
    MISSING=$((MISSING + 1))
  fi
done
echo ""
echo "核心技能：$INSTALLED 已安装，$MISSING 缺失"

# 检查插件
echo ""
echo "=== 已安装的插件 ==="
if [ -f "$HOME/.claude/plugins/installed_plugins.json" ]; then
  if grep -q "feature-dev" "$HOME/.claude/plugins/installed_plugins.json" 2>/dev/null; then
    echo "  ✓ feature-dev"
  else
    echo "  ✗ feature-dev (未安装)"
  fi

  if grep -q "compound-engineering" "$HOME/.claude/plugins/installed_plugins.json" 2>/dev/null; then
    echo "  ✓ compound-engineering"
  else
    echo "  ✗ compound-engineering (未安装)"
  fi
else
  echo "  ✗ 插件配置文件不存在"
fi

echo ""
echo "[INFO] 检查完成。使用 'bash scripts/check_setup.sh' 进行完整检查。"