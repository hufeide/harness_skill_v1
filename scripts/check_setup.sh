#!/bin/bash

# Claude Project Setup Checker
# 检查项目设置并引导用户完成配置

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  Claude Project Setup Checker${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# 计数器
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

# 检查函数
check() {
    local name=$1
    local command=$2
    local install_cmd=$3

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    echo -e "${YELLOW}[检查 $TOTAL_CHECKS] $name${NC}"

    if eval "$command" > /dev/null 2>&1; then
        echo -e "  ${GREEN}✓ 通过${NC}"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "  ${RED}✗ 未通过${NC}"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        if [ -n "$install_cmd" ]; then
            echo -e "  ${BLUE}→ 运行以下命令修复:${NC}"
            echo -e "    $install_cmd"
        fi
    fi
    echo ""
}

# 1. 检查 Claude Code CLI
check "Claude Code CLI" "which claude" "npm install -g @anthropic-ai/claude-code"

# 2. 检查插件
check "feature-dev 插件" "cat ~/.claude/plugins/installed_plugins.json | grep -q 'feature-dev'" \
      "npx claude-plugins install feature-dev"

check "compound-engineering 插件" "cat ~/.claude/plugins/installed_plugins.json | grep -q 'compound-engineering'" \
      "npx claude-plugins install compound-engineering"

# 3. 检查关键技能
check "brainstorming 技能" "test -d ~/.agents/skills/brainstorming" "npx skills add brainstorming"
check "writing-plans 技能" "test -d ~/.agents/skills/writing-plans" "npx skills add writing-plans"
check "test-driven-development 技能" "test -d ~/.agents/skills/test-driven-development" "npx skills add test-driven-development"
check "systematic-debugging 技能" "test -d ~/.agents/skills/systematic-debugging" "npx skills add systematic-debugging"
check "using-git-worktrees 技能" "test -d ~/.agents/skills/using-git-worktrees" "npx skills add using-git-worktrees"
check "requesting-code-review 技能" "test -d ~/.agents/skills/requesting-code-review" "npx skills add requesting-code-review"
check "verification-before-completion 技能" "test -d ~/.agents/skills/verification-before-completion" "npx skills add verification-before-completion"

# 4. 检查 Hooks
check "Hooks 目录" "test -d ~/.claude/hooks" "mkdir -p ~/.claude/hooks"
check "pre_commit hook" "test -f ~/.claude/hooks/pre_commit" "bash scripts/setup_hooks.sh"
check "post_commit hook" "test -f ~/.claude/hooks/post_commit" "bash scripts/setup_hooks.sh"

# 5. 检查配置文件
check "项目配置文件" "test -f config/env.json" "echo '请创建 config/env.json'"
check "CLAUDE.md" "test -f CLAUDE.md" "echo '请创建 CLAUDE.md'"

# 6. 检查 Git
check "Git 仓库" "git rev-parse --git-dir 2>/dev/null" "git init"

# 统计结果
echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  检查结果摘要${NC}"
echo -e "${BLUE}======================================${NC}"
echo -e "  总检查数：$TOTAL_CHECKS"
echo -e "  ${GREEN}通过：$PASSED_CHECKS${NC}"
echo -e "  ${RED}未通过：$FAILED_CHECKS${NC}"
echo ""

if [ $FAILED_CHECKS -eq 0 ]; then
    echo -e "${GREEN}✓ 所有检查通过！项目已准备就绪。${NC}"
    echo ""
    echo "下一步:"
    echo "  1. 运行 /brainstorming 开始需求分析"
    echo "  2. 运行 /writing-plans 创建实施计划"
    echo "  3. 运行 /using-git-worktrees 创建功能分支"
else
    echo -e "${YELLOW}⚠ 部分检查未通过。请运行上述命令修复。${NC}"
    echo ""
    echo "快速修复所有问题:"
    echo "  bash scripts/setup_plugins.sh"
    echo "  npx skills add brainstorming writing-plans test-driven-development systematic-debugging using-git-worktrees requesting-code-review verification-before-completion"
fi

echo ""