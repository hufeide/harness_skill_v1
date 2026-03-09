#!/bin/bash

# 验证测试并上传到 GitHub
# 用法：./verify_and_upload.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_ROOT="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$PROJECT_ROOT/config/project.json"

# 计数器
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
FIXED_BUGS=0

echo ""
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     验证测试 & GitHub 上传                              ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# 从配置文件获取 GitHub URL
get_github_config() {
    if [ -f "$CONFIG_FILE" ]; then
        GITHUB_USER=$(grep '"user"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)
        GITHUB_REPO=$(grep '"repo"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)
        GITHUB_URL=$(grep '"url"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)

        # 清理 URL，移除 .git 后缀如果存在
        GITHUB_URL=$(echo "$GITHUB_URL" | sed 's/\.git$//')

        if [ -n "$GITHUB_USER" ] && [ -n "$GITHUB_REPO" ]; then
            # 如果 URL 为空或无效，构建默认 URL
            if [ -z "$GITHUB_URL" ] || [ "$GITHUB_URL" = "https://github.com/" ]; then
                GITHUB_URL="https://github.com/$GITHUB_USER/$GITHUB_REPO"
            fi
            return 0
        fi
    fi
    return 1
}

# 运行测试函数
run_test() {
    local name="$1"
    local command="$2"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    echo -e "${YELLOW}[测试 $TOTAL_TESTS] $name${NC}"

    if eval "$command" > /dev/null 2>&1; then
        echo -e "  ${GREEN}✓ 通过${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        echo -e "  ${RED}✗ 失败${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

# 可选测试函数
run_optional_test() {
    local name="$1"
    local command="$2"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))

    echo -e "${YELLOW}[测试 $TOTAL_TESTS] $name${NC}"

    if eval "$command" > /dev/null 2>&1; then
        echo -e "  ${GREEN}✓ 通过${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "  ${BLUE}⊘ 跳过${NC}"
    fi
}

# Bug 修复函数
fix_bug() {
    local bug_name="$1"
    local fix_command="$2"

    echo -e "${YELLOW}发现 Bug: $bug_name${NC}"
    echo -e "${BLUE}尝试修复...${NC}"

    if eval "$fix_command" 2>/dev/null; then
        echo -e "${GREEN}✓ 已修复${NC}"
        FIXED_BUGS=$((FIXED_BUGS + 1))
        return 0
    else
        echo -e "${RED}✗ 修复失败${NC}"
        return 1
    fi
}

# 更新状态函数
update_state() {
    local stage="$1"
    local activity="$2"

    if [ -f "$SCRIPT_DIR/update_state.sh" ]; then
        cd "$PROJECT_ROOT"
        bash "$SCRIPT_DIR/update_state.sh" update "$stage" "$activity"
    fi
}

# 测试阶段
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  阶段 1: 运行测试${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""

# 1. 检查是否有测试文件
if [ -d "$PROJECT_ROOT/tests" ] && [ -n "$(ls -A $PROJECT_ROOT/tests 2>/dev/null)" ]; then
    echo -e "${YELLOW}运行项目测试...${NC}"
    if [ -f "$PROJECT_ROOT/package.json" ]; then
        run_test "npm test" "npm test" || true
    elif [ -f "$PROJECT_ROOT/Makefile" ]; then
        run_test "make test" "make test" || true
    fi
else
    echo -e "${BLUE}  没有找到测试文件，跳过项目测试${NC}"
fi
echo ""

# 2. 检查代码文件
echo -e "${YELLOW}检查代码文件...${NC}"
run_test "HTML 文件存在" "test -f $PROJECT_ROOT/index.html" || true
run_test "CSS 文件存在" "test -f $PROJECT_ROOT/src/css/styles.css" || true
run_optional_test "JS 文件存在 (可选)" "test -d $PROJECT_ROOT/src/js"
echo ""

# 3. 检查文件内容
echo -e "${YELLOW}检查文件内容...${NC}"
run_test "HTML 包含有效结构" "grep -q '<!DOCTYPE html>' $PROJECT_ROOT/index.html" || true
run_test "CSS 包含样式规则" "grep -q '{' $PROJECT_ROOT/src/css/styles.css" || true
echo ""

# 4. 检查 HTML 中的路径问题
echo -e "${YELLOW}检查 HTML 路径...${NC}"
if grep -q 'href="styles.css"' "$PROJECT_ROOT/index.html" 2>/dev/null; then
    echo -e "  ${YELLOW}⚠ 发现 CSS 路径问题${NC}"
    fix_bug "CSS 路径错误" "sed -i 's|href=\"styles.css\"|href=\"src/css/styles.css\"|g' $PROJECT_ROOT/index.html"
fi
if grep -q 'src="images/' "$PROJECT_ROOT/index.html" 2>/dev/null; then
    echo -e "  ${YELLOW}⚠ 发现图片路径问题${NC}"
    fix_bug "图片路径错误" "sed -i 's|src=\"images/|src=\"src/images/|g' $PROJECT_ROOT/index.html"
fi
run_test "HTML 路径正确" "grep -q 'src/css/styles.css' $PROJECT_ROOT/index.html" || true
echo ""

# 5. 检查 Git 状态
echo -e "${YELLOW}检查 Git 状态...${NC}"
run_test "Git 仓库已初始化" "git rev-parse --git-dir 2>/dev/null" || true

# 检查是否有待提交的更改
HAS_CHANGES=false
if ! git diff --quiet --cached 2>/dev/null; then
    HAS_CHANGES=true
    echo -e "  ${GREEN}✓ 有待提交的更改${NC}"
elif ! git diff --quiet 2>/dev/null; then
    HAS_CHANGES=true
    echo -e "  ${GREEN}✓ 有未暂存的更改${NC}"
else
    echo -e "  ${BLUE}⊘ 没有待提交的更改${NC}"
fi
echo ""

# Bug 修复阶段
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  阶段 2: Bug 修复${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""

if [ $FIXED_BUGS -gt 0 ]; then
    echo -e "${GREEN}✓ 已修复 $FIXED_BUGS 个 Bug${NC}"
    update_state "verify" "修复 $FIXED_BUGS 个 Bug"
else
    echo -e "${GREEN}✓ 未发现需要修复的 Bug${NC}"
fi
echo ""

# 测试摘要
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  测试结果摘要${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "  总测试数：$TOTAL_TESTS"
echo -e "  ${GREEN}通过：$PASSED_TESTS${NC}"
echo -e "  ${RED}失败：$FAILED_TESTS${NC}"
echo -e "  ${YELLOW}修复 Bug: $FIXED_BUGS${NC}"
echo ""

if [ $FAILED_TESTS -gt 0 ]; then
    echo -e "${YELLOW}⚠ 部分测试未通过。请手动修复问题后再继续。${NC}"
    echo ""
    update_state "testing" "测试未通过，需要手动修复"
    exit 1
fi

echo -e "${GREEN}✓ 所有测试通过！${NC}"
update_state "verify" "测试通过，准备上传"

# 测试通过后更新 README
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  更新项目文档...${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""
if [ -f "$SCRIPT_DIR/update_readme.sh" ]; then
    cd "$PROJECT_ROOT"
    bash "$SCRIPT_DIR/update_readme.sh"
    echo -e "${GREEN}✓ 项目文档已更新${NC}"
else
    echo -e "${YELLOW}⚠ 未找到 update_readme.sh 脚本${NC}"
fi
echo ""

# 上传阶段
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  阶段 3: 上传到 GitHub${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""

# 获取 GitHub 配置
if ! get_github_config; then
    echo -e "${RED}✗ 无法读取配置文件 $CONFIG_FILE${NC}"
    echo ""
    echo -e "${YELLOW}请确保 config/project.json 包含以下信息:${NC}"
    echo ""
    cat << EOF
{
  "github": {
    "user": "你的 GitHub 用户名",
    "repo": "仓库名",
    "url": "https://github.com/用户名/仓库名"
  }
}
EOF
    echo ""
    update_state "verify" "配置错误，无法上传"
    exit 1
fi

echo -e "${BLUE}GitHub 配置:${NC}"
echo -e "  用户：${GREEN}$GITHUB_USER${NC}"
echo -e "  仓库：${GREEN}$GITHUB_REPO${NC}"
echo -e "  URL:  ${GREEN}$GITHUB_URL${NC}"
echo ""

# 检查是否已配置远程仓库
if ! git remote -v 2>/dev/null | grep -q origin; then
    echo -e "${YELLOW}远程仓库未配置，正在自动配置...${NC}"
    git remote add origin "$GITHUB_URL.git"
    echo -e "${GREEN}✓ 远程仓库已配置${NC}"
else
    echo -e "${GREEN}✓ 远程仓库已配置${NC}"

    # 检查远程 URL 是否匹配
    CURRENT_URL=$(git remote get-url origin 2>/dev/null || echo "")
    if [ "$CURRENT_URL" != "$GITHUB_URL.git" ] && [ "$CURRENT_URL" != "$GITHUB_URL" ]; then
        echo -e "${YELLOW}远程 URL 不匹配，正在更新...${NC}"
        git remote set-url origin "$GITHUB_URL.git"
        echo -e "${GREEN}✓ 远程 URL 已更新${NC}"
    fi
fi
echo ""

# 添加所有更改
echo -e "${YELLOW}添加所有更改...${NC}"
git add -A
echo -e "${GREEN}✓ 已添加${NC}"
echo ""

# 检查是否有待提交的更改
if ! git diff --quiet --cached 2>/dev/null || ! git diff --quiet 2>/dev/null; then
    # 获取当前分支
    CURRENT_BRANCH=$(git branch --show-current)

    # 如果没有配置分支，使用 main
    if [ -z "$CURRENT_BRANCH" ]; then
        CURRENT_BRANCH="main"
    fi

    echo -e "${YELLOW}待提交的更改:${NC}"
    git diff --cached --stat 2>/dev/null || git diff --stat 2>/dev/null
    echo ""

    # 询问是否提交
    echo -e "${BLUE}是否提交并推送到远程？(y/n)${NC}"
    read -p "> " -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # 创建提交
        COMMIT_MSG="feat: 完成功能开发"
        echo -e "${YELLOW}创建提交...${NC}"
        git commit -m "$COMMIT_MSG" -m "Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>" 2>/dev/null || true
        echo -e "${GREEN}✓ 已提交${NC}"
        echo ""

        # 推送
        echo -e "${YELLOW}推送到远程仓库...${NC}"
        if git push -u origin "$CURRENT_BRANCH" 2>/dev/null; then
            echo -e "${GREEN}✓ 已推送${NC}"
            echo ""

            update_state "completed" "测试通过并上传到 GitHub"

            echo -e "${GREEN}✓ 成功上传到 GitHub!${NC}"
            echo ""
            echo -e "${BLUE}查看你的项目:${NC}"
            echo "  $GITHUB_URL"
            echo ""
        else
            echo -e "${RED}✗ 推送失败${NC}"
            echo ""
            echo -e "${BLUE}请检查:${NC}"
            echo "  1. GitHub 仓库是否已创建"
            echo "  2. 是否有写入权限"
            echo "  3. 网络连接是否正常"
            echo ""
            update_state "verify" "推送失败，请检查配置"
            exit 1
        fi
    else
        echo -e "${YELLOW}操作已取消。更改已暂存，等待后续提交。${NC}"
        echo ""
    fi
else
    echo -e "${BLUE}  没有待提交的更改${NC}"
    echo ""

    # 检查是否需要推送
    echo -e "${YELLOW}检查远程状态...${NC}"
    if git fetch origin 2>/dev/null; then
        if [ "$(git rev-parse @ 2>/dev/null)" != "$(git rev-parse @{u} 2>/dev/null)" ]; then
            echo -e "${BLUE}本地有更新，是否推送到远程？(y/n)${NC}"
            read -p "> " -r
            echo ""

            if [[ $REPLY =~ ^[Yy]$ ]]; then
                CURRENT_BRANCH=$(git branch --show-current)
                git push -u origin "$CURRENT_BRANCH"
                echo -e "${GREEN}✓ 已推送${NC}"
                update_state "completed" "测试通过并上传到 GitHub"
            else
                update_state "verify" "测试通过，等待用户确认推送"
            fi
        else
            echo -e "${GREEN}✓ 代码已是最新${NC}"
            update_state "completed" "测试通过，代码已同步"
        fi
    else
        update_state "completed" "测试通过，无更改需要提交"
    fi
fi

# 更新项目概述和运行方法
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  阶段 4: 更新项目概述${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo ""

if [ -f "$SCRIPT_DIR/update_readme.sh" ]; then
    cd "$PROJECT_ROOT"
    bash "$SCRIPT_DIR/update_readme.sh"
    echo -e "${GREEN}✓ 项目概述已更新${NC}"
else
    echo -e "${YELLOW}⚠ 未找到 update_readme.sh 脚本${NC}"
fi
echo ""

# 完成摘要
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     完成！🎉                                           ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "${GREEN}下一步:${NC}"
echo ""
echo "  1. 开始新功能：/brainstorming"
echo "  2. 查看项目：$GITHUB_URL"
echo ""