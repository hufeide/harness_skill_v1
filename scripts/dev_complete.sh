#!/bin/bash
# 开发完成提醒脚本

set -e

PROJECT_ROOT="$(pwd)"

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     🎉 功能开发完成！                                  ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# 更新状态
if [ -f "scripts/update_state.sh" ]; then
    bash scripts/update_state.sh update testing "等待测试验证"
else
    echo "⚠️  警告: 找不到 update_state.sh 脚本"
fi

echo ""
echo "════════════════════════════════════════════════════════"
echo "  下一步：测试验证"
echo "════════════════════════════════════════════════════════"
echo ""

# 检测项目类型并给出相应的测试命令
if [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
    echo "📦 Python 项目 - 运行测试："
    echo ""
    echo "  # 运行所有测试"
    echo "  pytest tests/ -v"
    echo ""
    echo "  # 带覆盖率报告"
    echo "  pytest tests/ --cov=src --cov-report=html"
    echo ""
    echo "  # 查看覆盖率报告"
    echo "  open htmlcov/index.html  # macOS"
    echo "  xdg-open htmlcov/index.html  # Linux"
    echo ""
elif [ -f "package.json" ]; then
    echo "📦 Node.js 项目 - 运行测试："
    echo ""
    echo "  # 运行所有测试"
    echo "  npm test"
    echo ""
    echo "  # 带覆盖率报告"
    echo "  npm test -- --coverage"
    echo ""
elif [ -f "Gemfile" ]; then
    echo "📦 Ruby 项目 - 运行测试："
    echo ""
    echo "  # 运行所有测试"
    echo "  bundle exec rspec"
    echo ""
    echo "  # 详细输出"
    echo "  bundle exec rspec --format documentation"
    echo ""
else
    echo "⚠️  未检测到项目类型，请手动运行测试"
    echo ""
fi

echo "════════════════════════════════════════════════════════"
echo "  测试覆盖率目标"
echo "════════════════════════════════════════════════════════"
echo ""
echo "  ✓ 总体覆盖率：> 80%"
echo "  ✓ 核心功能：  > 90%"
echo "  ✓ 关键路径：  100%"
echo ""

echo "════════════════════════════════════════════════════════"
echo "  测试通过后的操作"
echo "════════════════════════════════════════════════════════"
echo ""
echo "1. 更新状态："
echo "   bash scripts/update_state.sh update verify '测试通过'"
echo ""
echo "2. 代码审查："
echo "   /requesting-code-review"
echo ""
echo "3. 完成验证："
echo "   /verification-before-completion"
echo ""
echo "4. 提交代码："
echo "   git add ."
echo "   git commit -m 'feat: <功能描述>'"
echo ""

# 检查是否有未提交的更改
if git status --porcelain 2>/dev/null | grep -q '^'; then
    echo "════════════════════════════════════════════════════════"
    echo "  ⚠️  检测到未提交的更改"
    echo "════════════════════════════════════════════════════════"
    echo ""
    echo "修改的文件："
    git status --short
    echo ""
fi
