#!/bin/bash

# 更新项目 README.md
# 用法：./update_readme.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_ROOT="$(pwd)"
CONFIG_FILE="$PROJECT_ROOT/config/project.json"
README_FILE="$PROJECT_ROOT/README.md"
CLAUDE_FILE="$PROJECT_ROOT/CLAUDE.md"
GUIDE_STATE_FILE="$PROJECT_ROOT/.guide_state"

echo ""
echo -e "${CYAN}════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  更新项目概述和运行方法${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════${NC}"
echo ""

# 从配置文件获取项目信息
get_project_config() {
    if [ -f "$CONFIG_FILE" ]; then
        PROJECT_NAME=$(grep '"name"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)
        PROJECT_DESC=$(grep '"description"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)
        GITHUB_USER=$(grep '"user"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)
        GITHUB_REPO=$(grep '"repo"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)
        GITHUB_URL=$(grep '"url"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)

        # 设置默认值
        PROJECT_NAME=${PROJECT_NAME:-"我的项目"}
        PROJECT_DESC=${PROJECT_DESC:-"一个有趣的项目"}
        GITHUB_URL=${GITHUB_URL:-"https://github.com/$GITHUB_USER/$GITHUB_REPO"}

        # 清理 URL，移除 .git 后缀
        GITHUB_URL=$(echo "$GITHUB_URL" | sed 's/\.git$//')

        return 0
    fi
    return 1
}

# 获取项目类型（从 .guide_state 读取）
get_project_type() {
    PROJECT_TYPE=""

    # 从 .guide_state 读取
    if [ -f "$GUIDE_STATE_FILE" ]; then
        PROJECT_TYPE=$(grep "PROJECT_TYPE" "$GUIDE_STATE_FILE" 2>/dev/null | cut -d'=' -f2 | tr -d '"' || echo "")
    fi

    # 默认值
    PROJECT_TYPE=${PROJECT_TYPE:-"unknown"}
}

# 获取运行状态
get_current_stage() {
    CURRENT_STAGE=""

    if [ -f "$GUIDE_STATE_FILE" ]; then
        CURRENT_STAGE=$(grep "CURRENT_STAGE" "$GUIDE_STATE_FILE" 2>/dev/null | cut -d'=' -f2 | tr -d '"' || echo "")
    fi

    CURRENT_STAGE=${CURRENT_STAGE:-"unknown"}
}

# 根据项目类型生成运行方式
get_run_instructions() {
    case "$PROJECT_TYPE" in
        "personal_website"|"website"|"static_site")
            echo "### 运行方式

1. **直接打开**：在浏览器中打开 \`src/index.html\` 文件
2. **使用本地服务器**：
   \`\`\`bash
   # Python
   python -m http.server 8000

   # 或者使用 Node.js
   npx serve
   \`\`\`

3. **访问**：打开浏览器访问 \`http://localhost:8000\`"
            ;;
        "blog")
            echo "### 运行方式

\`\`\`bash
# 安装依赖
npm install

# 开发模式
npm run dev

# 生产构建
npm run build
\`\`\`"
            ;;
        "api"|"backend")
            echo "### 运行方式

\`\`\`bash
# 安装依赖
pip install -r requirements.txt

# 运行服务器
python app.py
\`\`\`"
            ;;
        "rails")
            echo "### 运行方式

\`\`\`bash
# 安装依赖
bundle install

# 数据库迁移
rails db:migrate

# 启动服务器
rails server
\`\`\`"
            ;;
        *)
            echo "### 运行方式

详细运行方法请参考项目文档或 \`CLAUDE.md\`。"
            ;;
    esac
}

# 根据项目类型生成技术栈
get_tech_stack() {
    case "$PROJECT_TYPE" in
        "personal_website"|"website"|"static_site")
            echo "- HTML5
- CSS3
- 响应式设计"
            ;;
        "blog")
            echo "- Node.js
- React/Vue
- Markdown"
            ;;
        "api"|"backend")
            echo "- Python
- Flask/Django
- REST API"
            ;;
        "rails")
            echo "- Ruby on Rails
- PostgreSQL
- Hotwire"
            ;;
        *)
            echo "- 待补充"
            ;;
    esac
}

# 更新 README.md
update_readme() {
    echo -e "${BLUE}更新 README.md...${NC}"

    local run_section=$(get_run_instructions)
    local tech_section=$(get_tech_stack)

    # 写入 README.md
    cat > "$README_FILE" << ENDREADME
# $PROJECT_NAME

$PROJECT_DESC

## 快速开始

$run_section

## 技术栈

$tech_section

## 项目结构

\`\`\`
├── config/          # 项目配置
│   ├── project.json # GitHub 项目信息
│   ├── permissions.json # 权限配置
│   └── env.json     # 环境配置
├── docs/            # 文档
│   ├── plans/       # 计划文档
│   └── decisions/   # 决策记录
├── scripts/         # 工具脚本
├── src/             # 源代码
├── tests/           # 测试文件
\`\`\`

## 开发工作流

1. **需求分析** - 使用 \`/brainstorming\` 探索需求
2. **创建计划** - 使用 \`/writing-plans\` 制定实施方案
3. **分支开发** - 使用 \`/using-git-worktrees\` 创建功能分支
4. **代码实现** - 完成功能开发
5. **验证测试** - 使用 \`/verification-before-completion\` 验证
6. **合并代码** - 使用 \`/finishing-a-development-branch\` 创建 PR

## 常用命令

| 说什么 | 做什么 |
|--------|--------|
| "我迷路了" | 显示完整引导菜单 |
| "下一步做什么" | 显示下一步建议 |
| "查看状态" | 显示项目状态 |
| "检查设置" | 运行设置检查 |

## 链接

- **GitHub 仓库**: [$GITHUB_URL]($GITHUB_URL)
ENDREADME

    echo -e "${GREEN}✓ README.md 已更新${NC}"
    echo ""
}

# 更新 CLAUDE.md
update_claude_md() {
    echo -e "${BLUE}更新 CLAUDE.md...${NC}"

    local run_section=$(get_run_instructions)
    local tech_section=$(get_tech_stack)

    # 写入 CLAUDE.md
    cat > "$CLAUDE_FILE" << ENDCLAUDE
# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## 项目概述

$PROJECT_DESC

## 技术栈

$tech_section

## 运行方式

$run_section

## 项目结构

\`\`\`
├── config/          # 项目配置
├── docs/            # 文档
│   ├── plans/       # 计划文档
│   └── decisions/   # 决策记录
├── scripts/         # 工具脚本
├── src/             # 源代码
├── tests/           # 测试文件
\`\`\`

## 工作流

1. 使用 \`/brainstorming\` 开始需求分析
2. 使用 \`/writing-plans\` 创建实施计划
3. 使用 \`/using-git-worktrees\` 创建功能分支
4. 开发完成后使用 \`/verification-before-completion\` 验证
5. 使用 \`/finishing-a-development-branch\` 创建 PR

## Harness 技能命令

| 命令 | 用途 |
|------|------|
| \`/brainstorming\` | 需求探索 |
| \`/writing-plans\` | 创建计划 |
| \`/test-driven-development\` | TDD 开发 |
| \`/systematic-debugging\` | 调试 |
| \`/using-git-worktrees\` | 分支管理 |
| \`/requesting-code-review\` | 代码审查 |
| \`/verification-before-completion\` | 完成验证 |

## 自然语言触发

- "我迷路了" - 显示完整引导菜单
- "下一步做什么" - 显示下一步建议
- "查看状态" - 显示项目状态
- "检查设置" - 运行设置检查
ENDCLAUDE

    echo -e "${GREEN}✓ CLAUDE.md 已更新${NC}"
    echo ""
}

# 主函数
main() {
    # 获取项目配置
    if ! get_project_config; then
        echo -e "${RED}✗ 无法读取配置文件 $CONFIG_FILE${NC}"
        exit 1
    fi

    # 获取项目类型
    get_project_type
    get_current_stage

    echo -e "${BLUE}项目信息:${NC}"
    echo -e "  名称：${GREEN}$PROJECT_NAME${NC}"
    echo -e "  描述：${GREEN}$PROJECT_DESC${NC}"
    echo -e "  类型：${GREEN}$PROJECT_TYPE${NC}"
    echo -e "  阶段：${GREEN}$CURRENT_STAGE${NC}"
    echo -e "  GitHub: ${GREEN}$GITHUB_URL${NC}"
    echo ""

    # 更新文件
    update_readme
    update_claude_md

    echo -e "${GREEN}✓ 项目概述和运行方法已更新${NC}"
    echo ""
}

# 运行
main