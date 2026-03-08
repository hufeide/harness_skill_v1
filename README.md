# Claude Project Skill

Harness engineer 风格的 Claude Skill，支持：
- 自动化插件安装（skills + MCP + compound-engineering）
- 多窗口 Claude + Git worktrees
- Hooks：测试 bug 自动修复、文档更新、自动生成 issue
- 文档管理（claude.md + 关键背景文档）
- slash 命令 & commit commands

**特色：** 智能引导系统，带你完成整个开发流程

---

## 快速开始

### 在新项目中初始化

在**你的项目目录**中运行：

```bash
bash scripts/init_project.sh
```

这会在**当前目录**创建以下结构：

```
<当前目录>/
├── config/
│   └── env.json
├── docs/
│   ├── plans/
│   └── decisions/
├── scripts/
├── src/
├── tests/
├── CLAUDE.md
├── README.md
├── .gitignore
└── .guide_state
```

**注意**: 所有脚本使用 `$(pwd)` 自动检测当前项目目录，可以在任何空项目中使用。

### 查看引导

```bash
bash scripts/guide.sh
```

**会显示：**
- 当前项目状态
- 下一步建议
- 最佳实践
- 技能速查表

### 验证配置

```bash
bash scripts/check_setup.sh
```

**预期结果：** 16 项检查全部通过

---

## 完整工作流程

```
项目初期 ──→ 项目开始 ──→ 开发中 ──→ 里程碑完成
   │            │           │           │
   │            │           │           └──→ 回到开发中
   │            │           │
   │            │           └── 循环执行
   │            │
   │            └── 规划完成
   │
   └── 设置完成
```

### 阶段 1: 项目初期

**运行初始化：**
```bash
bash scripts/init_project.sh
```

**查看引导：**
```bash
bash scripts/guide.sh
```

**检查设置：**
```bash
bash scripts/check_setup.sh
```

### 阶段 2: 项目开始

**需求分析：**
```
/brainstorming
```

**创建计划：**
```
/writing-plans
```

**创建任务：**
```bash
/todos create "任务 1"
/todos create "任务 2"
```

**创建分支：**
```
/using-git-worktrees
```

### 阶段 3: 开发中

**开发新功能：**
```
/brainstorming → /writing-plans → 编码 → /requesting-code-review → /verification-before-completion → /finishing-a-development-branch
```

**修复 Bug：**
```
/systematic-debugging → /compound-engineering:workflow:bug-reproduction-validator → 修复 → /verification-before-completion
```

### 阶段 4: 里程碑完成

**完成检查：**
- `/compound-engineering:ce:review` - 代码审查
- `npm test` - 运行测试
- `bash scripts/update_docs.sh` - 更新文档
- `/changelog` - 更新变更日志
- `/finishing-a-development-branch` - 创建 PR

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
| `scripts/create_issues.sh` | 创建 GitHub issues |

---

## 文档

- `docs/GUIDE.md` - **完整开发引导（推荐从这里开始）**
- `docs/development_workflow.md` - 工作流程说明
- `docs/testing.md` - 测试文档

---

## 配置

### 环境变量

编辑 `config/env.json`：

```json
{
  "PROJECT_NAME": "my-project",
  "GITHUB_TOKEN": "ghp_...",
  "DATABASE_URL": "mongodb://localhost:27017/mydb",
  "MODEL": "claude-v1",
  "DEFAULT_BRANCH": "main"
}
```

### Hooks

Hooks 配置在 `~/.claude/hooks/`：

- `pre_commit` - 提交前检查
- `post_commit` - 提交后更新

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

### 插件安装失败

```bash
rm -rf ~/.claude/plugins/cache
bash scripts/setup_plugins.sh
```

### 迷路了？

```bash
bash scripts/guide.sh
```

查看「下一步建议」。

---

## 许可证

MIT