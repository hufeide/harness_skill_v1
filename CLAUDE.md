# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## 项目概述

**Claude Project Skill** - Harness engineer 风格的 Claude 自动化技能，提供智能引导系统，带领用户完成整个开发流程。

**特色：**
- 智能引导系统（`guide.sh`）
- 项目初始化脚本（`init_project.sh`）
- 状态追踪（`.guide_state` + `.guide_history`）
- 自动化 Hooks
- 最佳实践集成
- **交互式环境设置引导** - 初始化时逐步引导用户设置必要信息

---

## 目录结构

```
<current-project>/
├── CLAUDE.md              # 本文件（Claude 工作指引）
├── README.md              # 项目说明
├── config/
│   └── env.json           # 环境变量配置
├── docs/
│   ├── GUIDE.md           # 完整开发引导（推荐从这里开始）
│   ├── development_workflow.md  # 工作流程说明
│   └── testing.md         # 测试文档
├── scripts/
│   ├── init_project.sh    # 项目初始化
│   ├── guide.sh           # 智能引导
│   ├── check_setup.sh     # 设置检查
│   ├── setup_hooks.sh     # 配置 Hooks
│   ├── setup_plugins.sh   # 安装插件
│   ├── update_docs.sh     # 更新文档
│   ├── update_state.sh    # 状态追踪
│   └── create_issues.sh   # 创建 issues
├── src/                   # 源代码目录
├── tests/                 # 测试文件目录
├── docs/plans/            # 设计文档
├── docs/decisions/        # 架构决策记录
└── .guide_state           # 项目状态文件
```

**注意**: 所有脚本使用 `$(pwd)` 自动检测当前项目目录，无需硬编码路径。

**状态文件说明**:
- `.guide_state` - 当前项目阶段和最后活动
- `.guide_history` - 所有活动历史记录（时间戳 + 活动描述）

---

## 快速开始

### 1. 项目初始化

```bash
bash scripts/init_project.sh
```

### 2. 查看引导

```bash
bash scripts/guide.sh
```

### 3. 验证配置

```bash
bash scripts/check_setup.sh
```

---

## 核心工作流

```
项目初期 ──→ 项目开始 ──→ 开发中 ──→ 里程碑完成
```

### 阶段 1: 项目初期

```bash
bash scripts/init_project.sh
bash scripts/guide.sh
bash scripts/check_setup.sh
```

### 阶段 2: 项目开始

```
/brainstorming → /writing-plans → /todos create → /using-git-worktrees
```

### 推送到 GitHub

```bash
# 添加远程仓库
git remote add origin https://github.com/USERNAME/REPO.git

# 推送代码
git push -u origin main
```

**注意**: 如果远程仓库已存在且有 README，需要先克隆或强制推送：
```bash
git pull origin main --allow-unrelated-histories
# 或
git push -u origin main --force
```

### 阶段 3: 开发中

```
/brainstorming → /writing-plans → 编码 → /requesting-code-review → /verification-before-completion → /finishing-a-development-branch
```

### 阶段 4: 里程碑完成

- `/compound-engineering:ce:review`
- `npm test`
- `bash scripts/update_docs.sh`
- `/changelog`
- `/finishing-a-development-branch`

---

## 智能引导系统

### 交互式模式

```bash
bash scripts/guide.sh
```

**菜单选项：**
1. 查看下一步建议
2. 查看最佳实践
3. 查看技能速查表
4. 运行完整检查
5. 开始 brainstorming
6. 退出

### 自动模式

```bash
bash scripts/guide.sh auto
```

显示：
- 当前项目状态
- 下一步建议
- 最佳实践
- 技能速查表

### 状态追踪

```bash
# 查看状态
bash scripts/update_state.sh show

# 更新状态
bash scripts/update_state.sh update <stage> <activity>
```

状态保存在 `.guide_state` 文件中。

---

## 核心技能命令

| 命令 | 用途 | 使用时机 |
|------|------|---------|
| `/brainstorming` | 需求探索 | 开始任何新功能前 |
| `/writing-plans` | 创建计划 | 需求明确后 |
| `/test-driven-development` | TDD 开发 | 编写新功能 |
| `/systematic-debugging` | 调试 | 遇到 bug |
| `/using-git-worktrees` | 分支管理 | 开始新功能 |
| `/requesting-code-review` | 代码审查 | 完成功能后 |
| `/verification-before-completion` | 完成验证 | 提交前 |

---

## 脚本说明

| 脚本 | 用途 |
|------|------|
| `scripts/init_project.sh` | 项目初始化 |
| `scripts/guide.sh` | **智能引导（推荐）** |
| `scripts/check_setup.sh` | 检查项目设置 |
| `scripts/setup_hooks.sh` | 配置 Hooks |
| `scripts/update_docs.sh` | 更新文档 |
| `scripts/update_state.sh` | 状态追踪 |

---

## 最佳实践

### 代码提交
- 提交信息要清晰，说明做了什么和为什么
- 一个小功能一个提交
- 不要提交敏感信息

### 分支管理
- 使用 feature 分支开发新功能
- 定期从主分支合并更新
- 功能完成后及时删除分支

### 测试
- 新功能一定要写测试
- 保持测试覆盖率 > 80%
- 修复 bug 时先写一个复现测试

### 代码审查
- 提交 PR 前先自我审查
- 小 PR 更容易审查
- 认真对待审查意见

### 文档
- 及时更新 README
- 记录架构决策（ADRs）
- 更新变更日志

---

## 故障排除

### 技能找不到
```bash
/find-skills
```

### Hooks 未执行
```bash
chmod +x ~/.claude/hooks/*
```

### 迷路了？
```bash
bash scripts/guide.sh
```

---

## 已安装的技能

**核心技能：**
- brainstorming
- writing-plans
- test-driven-development
- systematic-debugging
- using-git-worktrees
- requesting-code-review
- verification-before-completion
- subagent-driven-development
- finishing-a-development-branch

**插件：**
- feature-dev@claude-plugins-official
- compound-engineering@compound-engineering-plugin

---

## 自然语言触发规则（完全不用记命令！）

### 核心引导技能

当用户表达以下意图时，**自动触发引导功能**：

| 用户自然语言 | Claude 自动响应 |
|-------------|----------------|
| "我迷路了" | 显示完整引导菜单 |
| "不知道做什么" | 显示下一步建议 |
| "查看引导" | 显示完整引导菜单 |
| "有什么建议" | 显示下一步建议 |
| "下一步做什么" | 显示下一步建议 |
| "查看状态" / "当前进度" | 显示项目状态 |
| "查看最佳实践" | 显示最佳实践 |
| "技能列表" / "有什么技能" | 显示技能速查表 |
| "检查设置" / "检查配置" | 运行设置检查 |
| "初始化项目" | 运行项目初始化 |

### 使用示例

**示例 1: 用户迷路了**
```
用户：我迷路了，不知道现在该做什么

Claude: （自动运行 guide.sh）
        👋 欢迎使用 Claude Project Guide
        当前阶段：development
        下一步建议：创建功能分支...
```

**示例 2: 用户问下一步**
```
用户：下一步做什么？

Claude: （自动运行 guide.sh recommendation）
        💻 阶段：开发中
        推荐操作：
          1. 创建功能分支：/using-git-worktrees
          2. 开始开发功能
```

**示例 3: 用户查看状态**
```
用户：查看当前状态

Claude: （自动运行 guide.sh status）
        当前阶段：development
        最后活动：任务规划完成
        待办任务：3 个
```

### 核心原则

1. **完全不用记命令** - 只需用自然语言描述需求
2. **智能意图识别** - 自动匹配最合适的引导模式
3. **渐进式引导** - 从简单到详细，按需显示
4. **上下文感知** - 根据项目阶段给出针对性建议

---

**最后更新：** 2026-03-07