#!/bin/bash
# 需求分析完成后的自动化脚本

set -e

PROJECT_ROOT="$(pwd)"

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     ✅ 需求分析完成！                                  ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# 更新状态
if [ -f "scripts/update_state.sh" ]; then
    bash scripts/update_state.sh update planning "完成需求分析"
else
    echo "⚠️  警告: 找不到 update_state.sh 脚本"
fi

echo ""
echo "════════════════════════════════════════════════════════"
echo "  下一步：创建设计文档"
echo "════════════════════════════════════════════════════════"
echo ""

# 检查 docs/plans 目录
if [ ! -d "docs/plans" ]; then
    echo "📁 创建 docs/plans 目录..."
    mkdir -p docs/plans
fi

# 生成设计文档文件名
DESIGN_FILE="docs/plans/$(date +%Y-%m-%d)-design.md"

echo "请创建设计文档："
echo ""
echo "  文件名: $DESIGN_FILE"
echo ""
echo "  命令: touch $DESIGN_FILE"
echo ""

# 提供设计文档模板
echo "设计文档应包含："
echo ""
echo "  1. 项目概述"
echo "     - 要解决的问题"
echo "     - 目标用户"
echo "     - 成功标准"
echo ""
echo "  2. 技术方案"
echo "     - 技术栈选择"
echo "     - 架构设计"
echo "     - 数据模型"
echo ""
echo "  3. 功能设计"
echo "     - 核心功能列表"
echo "     - API 设计"
echo "     - 用户界面"
echo ""
echo "  4. 实施计划"
echo "     - 开发阶段"
echo "     - 时间估算"
echo "     - 关键文件"
echo ""

# 询问是否创建设计文档
read -p "是否现在创建设计文档？(y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 创建设计文档模板
    cat > "$DESIGN_FILE" << 'EOF'
# 项目设计文档

> 创建日期：$(date +%Y-%m-%d)
> 状态：草稿

## 项目概述

### 要解决的问题


### 目标用户


### 技术约束


### 成功标准


## 技术方案

### 技术栈


### 架构设计


### 数据模型


## 功能设计

### 核心功能


### API 设计


## 实施计划

### 开发阶段


### 时间估算


### 关键文件


---

**设计者**：
**审批者**：
**审批日期**：
EOF
    
    # 替换日期占位符
    sed -i "s/\$(date +%Y-%m-%d)/$(date +%Y-%m-%d)/g" "$DESIGN_FILE" 2>/dev/null || true
    
    echo "✅ 设计文档已创建: $DESIGN_FILE"
    echo ""
    echo "请编辑设计文档，填写详细内容。"
else
    echo "跳过创建设计文档。"
fi

echo ""
echo "════════════════════════════════════════════════════════"
echo "  完成设计文档后的操作"
echo "════════════════════════════════════════════════════════"
echo ""
echo "1. 更新状态："
echo "   bash scripts/update_state.sh update tasks '设计文档完成'"
echo ""
echo "2. 创建详细计划："
echo "   /writing-plans"
echo ""
echo "3. 开始开发："
echo "   - 确保代码放在 src/ 目录"
echo "   - 确保测试放在 tests/ 目录"
echo ""

# 显示当前项目状态
if [ -f ".guide_state" ]; then
    echo "════════════════════════════════════════════════════════"
    echo "  当前项目状态"
    echo "════════════════════════════════════════════════════════"
    echo ""
    cat .guide_state
    echo ""
fi

# 显示最近的历史记录
if [ -f ".guide_history" ]; then
    echo "════════════════════════════════════════════════════════"
    echo "  最近活动"
    echo "════════════════════════════════════════════════════════"
    echo ""
    tail -5 .guide_history
    echo ""
fi
