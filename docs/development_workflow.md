# 项目开发工作流程

本文档详细说明在 Claude Code 项目中进行开发时，各个阶段需要执行的任务和步骤。

---

## 快速开始

### 运行设置检查

```bash
bash scripts/check_setup.sh
```

这个脚本会检查：
- Claude Code CLI 是否安装
- 必要插件是否可用
- 关键技能是否已安装
- Hooks 是否配置
- 环境变量是否设置
- Git 仓库是否初始化

---

## 项目阶段总览

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

---

## 阶段一：项目初期 (Project Initiation)

### 目标

完成环境设置，确保所有工具可用。

### 检查清单

运行设置检查脚本：
```bash
bash scripts/check_setup.sh
```

#### 1. 插件安装

检查：
```bash
cat ~/.claude/plugins/installed_plugins.json
```

必须包含：
- `feature-dev@claude-plugins-official`
- `compound-engineering@compound-engineering-plugin`

修复：
```bash
bash scripts/setup_plugins.sh
```

#### 2. 技能安装

检查：
```bash
ls ~/.agents/skills/
```

必须包含以下技能：
| 技能 | 用途 |
|------|------|
| `brainstorming` | 需求探索 |
| `writing-plans` | 计划创建 |
| `test-driven-development` | TDD 开发 |
| `systematic-debugging` | 调试 |
| `using-git-worktrees` | Git 工作树 |
| `requesting-code-review` | 代码审查 |
| `verification-before-completion` | 完成验证 |

修复：
```bash
npx skills add brainstorming writing-plans test-driven-development systematic-debugging using-git-worktrees requesting-code-review verification-before-completion
```

#### 3. Hooks 配置

检查：
```bash
ls -la ~/.claude/hooks/
```

必须包含：
- `pre_commit` - 提交前检查
- `post_commit` - 提交后更新

创建 pre_commit hook：
```bash
cat > ~/.claude/hooks/pre_commit << 'EOF'
#!/bin/bash
# 代码质量检查
npm run lint 2>/dev/null || true
npm test 2>/dev/null || true
echo "[HOOK] Pre-commit checks completed"
EOF
chmod +x ~/.claude/hooks/pre_commit
```

创建 post_commit hook：
```bash
cat > ~/.claude/hooks/post_commit << 'EOF'
#!/bin/bash
# 更新文档
bash scripts/update_docs.sh 2>/dev/null || true
echo "[HOOK] Post-commit hooks completed"
EOF
chmod +x ~/.claude/hooks/post_commit
```

#### 4. 环境变量

检查：
```bash
cat config/env.json
```

必须设置：
- `GITHUB_TOKEN`
- `DATABASE_URL`
- 其他必要的 API 密钥

#### 5. Git 仓库

检查：
```bash
git status
```

如果没有初始化：
```bash
git init
git branch -M main
```

### 项目初期完成标志

- [ ] 所有插件已安装
- [ ] 所有关键技能已安装
- [ ] Hooks 已配置
- [ ] 环境变量已设置
- [ ] Git 仓库已初始化

**完成后，进入「项目开始」阶段。**

---

## 阶段二：项目开始 (Project Kickoff)

### 目标

明确需求，制定计划，建立开发流程。

### 步骤 1：需求分析

运行：
```
/brainstorming
```

**流程：**

1. **探索项目上下文**
   - 检查现有文件
   - 查看 README 和文档
   - 了解项目目标

2. **回答澄清问题**（一次一个）
   - 项目要解决什么问题？
   - 目标用户是谁？
   - 技术约束是什么？
   - 成功标准是什么？

3. **提出 2-3 种方法**
   - 每种方法的优缺点
   - 推荐方案及理由

4. **呈现设计方案**
   - 架构设计
   - 数据流
   - 关键组件
   - 等待用户确认

5. **创建设计文档**
   ```
   docs/plans/YYYY-MM-DD-<topic>-design.md
   ```

6. **创建实施计划**
   ```
   /writing-plans
   ```

### 步骤 2：创建任务列表

```bash
/todos create "环境设置"
/todos create "核心功能开发"
/todos create "测试编写"
/todos create "文档完善"
```

### 步骤 3：设置开发环境

#### 创建 Git Worktree

```
/using-git-worktrees
```

#### 配置测试框架

**JavaScript/TypeScript:**
```bash
npm install -D jest @testing-library/react playwright
```

**Ruby:**
```bash
bundle add rspec
```

**Python:**
```bash
pip install pytest pytest-cov
```

### 项目开始完成标志

- [ ] 需求已明确
- [ ] 设计文档已创建
- [ ] 实施计划已生成
- [ ] 任务列表已建立
- [ ] Git 分支已设置
- [ ] 测试框架已配置

**完成后，进入「开发中」阶段。**

---

## 阶段三：开发中 (During Development)

### 目标

高效开发功能，保持代码质量，及时更新文档。

### 工作流 A：开发新功能

**完整流程：**

```
/brainstorming → /writing-plans → /subagent-driven-development → /verification-before-completion → /finishing-a-development-branch
```

**详细步骤：**

1. **需求探索**
   ```
   /brainstorming
   ```

2. **创建计划**
   ```
   /writing-plans
   ```

3. **并行开发**
   ```
   /subagent-driven-development
   ```

4. **完成前验证**
   ```
   /verification-before-completion
   ```

5. **提交代码**
   ```
   /finishing-a-development-branch
   ```

### 工作流 B：Bug 修复

**完整流程：**

```
/systematic-debugging → /compound-engineering:workflow:bug-reproduction-validator → /verification-before-completion
```

**详细步骤：**

1. **理解问题**
   ```
   /systematic-debugging
   ```

2. **复现 Bug**
   ```
   /compound-engineering:workflow:bug-reproduction-validator
   ```

3. **提出修复方案**
   - 至少 2 种方法
   - 评估优缺点

4. **实施修复**
   ```
   /todos create "修复 <bug 描述>"
   ```

5. **验证修复**
   ```
   /verification-before-completion
   ```

### 工作流 C：代码审查

**发送审查：**
```
/requesting-code-review
```

**专业审查（按语言）：**
- `/compound-engineering:review:dhh-rails-reviewer` - Rails (DHH 风格)
- `/compound-engineering:review:kieran-rails-reviewer` - Rails (高质量)
- `/compound-engineering:review:kieran-typescript-reviewer` - TypeScript
- `/compound-engineering:review:kieran-python-reviewer` - Python

**其他审查：**
- `/compound-engineering:review:code-simplicity-reviewer` - 代码简化
- `/compound-engineering:review:security-sentinel` - 安全审计
- `/compound-engineering:review:performance-oracle` - 性能分析

### 任务管理

**查看任务：**
```bash
/todos list
```

**更新任务：**
```bash
/todos update <task-id> --status=in_progress
/todos update <task-id> --status=completed
```

**并行处理任务：**
```
/compound-engineering:resolve_todo_parallel
```

### 文档维护

**更新文档：**
```bash
bash scripts/update_docs.sh
```

**生成变更日志：**
```
/changelog
```

**记录架构决策：**
```
docs/decisions/
├── 001-use-typescript.md
├── 002-use-postgresql.md
└── 003-use-redis-caching.md
```

### 测试运行

**单元测试：**
```bash
npm test
# 或
bundle exec rspec
# 或
pytest
```

**带覆盖率：**
```bash
npm test -- --coverage
```

**E2E 测试：**
```bash
npm run test:e2e
```

**浏览器测试：**
```
/compound-engineering:test-browser
```

---

## 阶段四：里程碑完成 (Milestone Complete)

### 目标

完成功能开发，准备部署，更新文档。

### 完成检查清单

- [ ] **代码审查完成**
  ```
  /compound-engineering:ce:review
  ```

- [ ] **所有测试通过**
  ```bash
  npm test
  npm run test:e2e
  ```

- [ ] **文档已更新**
  ```bash
  bash scripts/update_docs.sh
  ```

- [ ] **变更日志已更新**
  ```
  /changelog
  ```

- [ ] **部署验证**
  ```
  /compound-engineering:review:deployment-verification-agent
  ```

- [ ] **创建 PR**
  ```
  /finishing-a-development-branch
  ```

- [ ] **处理 PR 评论**
  ```
  /compound-engineering:workflow:pr-comment-resolver
  ```

---

## 技能速查表

### 核心技能

| 技能 | 命令 | 使用时机 |
|------|------|---------|
| brainstorming | `/brainstorming` | 开始任何新功能 |
| writing-plans | `/writing-plans` | 需求明确后 |
| subagent-driven-development | `/subagent-driven-development` | 执行复杂计划 |
| test-driven-development | `/test-driven-development` | 编写新功能 |
| systematic-debugging | `/systematic-debugging` | 遇到 bug |
| using-git-worktrees | `/using-git-worktrees` | 开始功能分支 |
| requesting-code-review | `/requesting-code-review` | 完成功能后 |
| verification-before-completion | `/verification-before-completion` | 提交前 |
| finishing-a-development-branch | `/finishing-a-development-branch` | 准备合并 |

### Compound Engineering 技能

| 用途 | 命令 |
|------|------|
| 计划创建 | `/compound-engineering:ce:plan` |
| 代码审查 | `/compound-engineering:ce:review` |
| 工作执行 | `/compound-engineering:ce:work` |
| 计划增强 | `/compound-engineering:deepen-plan` |
| TODO 并行 | `/compound-engineering:resolve_todo_parallel` |
| 浏览器测试 | `/compound-engineering:test-browser` |
| PR 评论处理 | `/compound-engineering:workflow:pr-comment-resolver` |
| Bug 验证 | `/compound-engineering:workflow:bug-reproduction-validator` |
| 部署验证 | `/compound-engineering:review:deployment-verification-agent` |

### 语言特定审查

| 语言 | 命令 |
|------|------|
| Rails (DHH 风格) | `/compound-engineering:review:dhh-rails-reviewer` |
| Rails (高质量) | `/compound-engineering:review:kieran-rails-reviewer` |
| TypeScript | `/compound-engineering:review:kieran-typescript-reviewer` |
| Python | `/compound-engineering:review:kieran-python-reviewer` |

---

## 常见问题

### 技能无法找到

**问题：** `Skill not found: brainstorming`

**解决：**
```bash
/find-skills
```

### 插件安装失败

**问题：** 插件安装超时或失败

**解决：**
```bash
rm -rf ~/.claude/plugins/cache
bash scripts/setup_plugins.sh
```

### Hooks 不执行

**问题：** 提交时 hooks 未触发

**解决：**
```bash
chmod +x ~/.claude/hooks/*
~/.claude/hooks/pre_commit
```

### Git Worktree 冲突

**问题：** worktree 状态不一致

**解决：**
```bash
git worktree list
git worktree prune
/using-git-worktrees
```

---

**文档版本：** 2.0.0
**最后更新：** 2026-03-07