#!/bin/bash

# Claude Project Hooks Setup Script
# 自动配置 Claude hooks

set -e

HOOKS_DIR="$HOME/.claude/hooks"

echo "[INFO] Setting up Claude hooks..."

# 创建 hooks 目录
mkdir -p "$HOOKS_DIR"

# 创建 pre_commit hook
cat > "$HOOKS_DIR/pre_commit" << 'EOF'
#!/bin/bash

# Claude Project Pre-commit Hook
# 在提交前自动运行代码质量检查

# 代码质量检查
if [ -f "package.json" ]; then
  echo "Running npm lint..."
  npm run lint 2>/dev/null || true
fi

if [ -f "Gemfile" ]; then
  echo "Running RuboCop..."
  bundle exec rubocop 2>/dev/null || true
fi

if [ -f "pyproject.toml" ]; then
  echo "Running Black check..."
  black --check 2>/dev/null || true
fi

# 运行相关测试
if [ -f "package.json" ]; then
  echo "Running tests..."
  npm test 2>/dev/null || true
fi

if [ -f "Gemfile" ]; then
  echo "Running RSpec..."
  bundle exec rspec 2>/dev/null || true
fi

if [ -f "pyproject.toml" ]; then
  echo "Running pytest..."
  pytest 2>/dev/null || true
fi

echo "[HOOK] Pre-commit checks completed"
EOF

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 创建 post_commit hook
cat > "$HOOKS_DIR/post_commit" << EOF
#!/bin/bash

# Claude Project Post-commit Hook
# 在提交后自动更新文档

# 更新文档
if [ -f "$SCRIPT_DIR/update_docs.sh" ]; then
  echo "Updating documentation..."
  bash "$SCRIPT_DIR/update_docs.sh" 2>/dev/null || true
fi

echo "[HOOK] Post-commit hooks completed"
EOF

# 设置执行权限
chmod +x "$HOOKS_DIR/pre_commit"
chmod +x "$HOOKS_DIR/post_commit"

echo "[INFO] Hooks setup complete!"
echo "Created:"
echo "  - $HOOKS_DIR/pre_commit"
echo "  - $HOOKS_DIR/post_commit"