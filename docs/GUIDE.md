# Claude Project 引导指南

我是你的开发领路人，会一步步引导你完成整个开发流程。

---

## 快速导航

| 你的情况 | 下一步 |
|---------|--------|
| 刚克隆项目，什么都没做 | → [项目初始化](#项目初始化) |
| 项目已初始化，不知道做什么 | → [需求规划](#需求规划) |
| 有需求，不知道如何开始 | → [任务规划](#任务规划) |
| 准备写代码了 | → [开发功能](#开发功能) |
| 代码写完了 | → [代码审查](#代码审查) |
| 想学习最佳实践 | → [最佳实践](#最佳实践) |

---

## 项目初始化

### 第一步：运行初始化脚本

```bash
bash scripts/init_project.sh
```

这会创建：
- `config/env.json` - 项目配置
- `CLAUDE.md` - 项目指引
- `README.md` - 项目说明
- `.gitignore` - Git 忽略规则
- `scripts/` - 项目脚本

### 第二步：配置环境变量

编辑 `config/env.json`：

```json
{
  "PROJECT_NAME": "你的项目名",
  "GITHUB_TOKEN": "ghp_你的 token",
  "DATABASE_URL": "mongodb://localhost:27017/你的数据库",
  "MODEL": "claude-v1",
  "DEFAULT_BRANCH": "main"
}
```

**需要 GITHUB_TOKEN 吗？**
- 如果需要创建 GitHub issues，去 [GitHub Tokens](https://github.com/settings/tokens) 创建一个
- 如果不需要，留空即可

### 第三步：验证配置

```bash
bash scripts/check_setup.sh
```

**预期结果：** 16 项检查全部通过

---

## 需求规划

### 第一步：运行 brainstorming

```
/brainstorming
```

**我会问你一些问题：**

1. **项目要解决什么问题？**
   - 例如：我想构建一个任务管理应用

2. **目标用户是谁？**
   - 例如：个人用户和小型团队

3. **有什么技术约束？**
   - 例如：使用 React 和 Node.js

4. **成功的标准是什么？**
   - 例如：用户可以创建、分配和跟踪任务

### 第二步：查看方案

我会提出 2-3 种方案：

**方案 A：快速开发**
- 技术栈：MongoDB + Express + React
- 优点：开发快，灵活
- 缺点：数据一致性需要手动处理

**方案 B：结构化开发**
- 技术栈：PostgreSQL + Prisma + React
- 优点：强类型，数据一致性好
- 缺点：需要定义 schema

**我的推荐：方案 B**
- 因为任务管理需要关系型数据

### 第三步：确认方案

告诉我你的选择，我会：
1. 记录设计决策
2. 创建设计文档
3. 准备进入下一步

---

## 任务规划

### 第一步：运行 writing-plans

```
/writing-plans
```

这会生成：

```markdown
# 任务管理器实施计划

## 任务清单
- [ ] 项目初始化
- [ ] 数据库模型设计
- [ ] API 开发
- [ ] 前端组件开发
- [ ] 测试

## 依赖关系
项目初始化 → 数据库模型设计 → API 开发 → 前端开发 → 测试

## 关键文件
- src/models/Task.js
- src/routes/tasks.js
- src/components/TaskList.jsx
```

### 第二步：创建任务

```bash
/todos create "设计数据库模型"
/todos create "实现 API 端点"
/todos create "编写单元测试"
```

### 第三步：查看任务

```bash
/todos list
```

---

## 开发功能

### 第一步：创建功能分支

```
/using-git-worktrees
```

这会创建一个隔离的开发环境。

### 第二步：开始开发

**推荐开发流程：**

```
1. 明确要做什么
2. 编写代码
3. 写测试
4. 运行测试
5. 提交代码
```

### 第三步：TDD（测试驱动开发）

```
/test-driven-development
```

**流程：**
1. 先写一个失败的测试
2. 编写最少的代码让测试通过
3. 重构代码
4. 重复

### 第四步：遇到 Bug？

```
/systematic-debugging
```

**流程：**
1. 理解问题
2. 复现 Bug
3. 定位原因
4. 提出修复方案
5. 实施修复
6. 验证修复

---

## 代码审查

### 第一步：完成功能后

```
/requesting-code-review
```

**审查内容包括：**
- 代码质量
- 可读性
- 性能
- 安全性

### 第二步：专业审查（按语言）

**TypeScript/JavaScript:**
```
/compound-engineering:review:kieran-typescript-reviewer
```

**Rails:**
```
/compound-engineering:review:kieran-rails-reviewer
```

**Python:**
```
/compound-engineering:review:kieran-python-reviewer
```

**安全审计:**
```
/compound-engineering:review:security-sentinel
```

**性能分析:**
```
/compound-engineering:review:performance-oracle
```

### 第三步：完成前验证

```
/verification-before-completion
```

**检查清单：**
- [ ] 所有测试通过
- [ ] 代码审查完成
- [ ] 文档已更新
- [ ] 变更日志已更新

### 第四步：创建 PR

```
/finishing-a-development-branch
```

---

## 最佳实践

### 📌 代码提交

**好的提交：**
```
feat: 添加用户认证功能

- 实现 JWT token 生成
- 添加登录/登出 API
- 添加中间件保护路由
```

**不好的提交：**
```
fix bug
更新代码
```

### 📌 分支管理

```
main          - 主分支，随时可部署
feature/auth  - 功能分支
bugfix/login  - Bug 修复分支
```

### 📌 测试覆盖率

**目标：> 80%**

```bash
npm test -- --coverage
```

**关键路径必须有测试：**
- 用户认证
- 数据 CRUD
- 支付流程
- 权限控制

### 📌 代码规范

**JavaScript/TypeScript:**
```bash
npm run lint
npm run format
```

**Ruby:**
```bash
bundle exec rubocop
```

**Python:**
```bash
black .
flake8 .
```

### 📌 文档维护

**每次里程碑完成后：**

```bash
bash scripts/update_docs.sh
/changelog
```

---

## 交互式引导

运行引导脚本：

```bash
bash scripts/guide.sh
```

**会显示：**
- 当前项目状态
- 下一步建议
- 最佳实践
- 技能速查表

**交互式菜单：**

```
你想做什么？

  1) 查看下一步建议
  2) 查看最佳实践
  3) 查看技能速查表
  4) 运行完整检查
  5) 开始 brainstorming
  6) 退出
```

---

## 常见问题

### Q: 我迷路了，不知道现在该做什么？

```bash
bash scripts/guide.sh
```

查看「下一步建议」。

### Q: 如何检查项目状态？

```bash
bash scripts/check_setup.sh
```

### Q: 忘记了技能命令？

```bash
bash scripts/guide.sh
```

选择「查看技能速查表」。

### Q: 如何恢复之前的进度？

查看 `.guide_state` 文件：

```bash
cat .guide_state
```

### Q: 需要帮助？

查看完整文档：
- `docs/development_workflow.md` - 工作流程
- `docs/testing.md` - 测试文档

---

## 完整流程示例

### 从零开始开发一个 API

```bash
# 1. 初始化
bash scripts/init_project.sh
bash scripts/check_setup.sh

# 2. 需求分析
/brainstorming
# 讨论：要做什么，技术选型

# 3. 创建计划
/writing-plans
# 生成任务列表

# 4. 创建分支
/using-git-worktrees

# 5. 开发功能
# 编写代码

# 6. 测试
npm test

# 7. 审查
/requesting-code-review

# 8. 验证
/verification-before-completion

# 9. 提交
/finishing-a-development-branch

# 10. 更新文档
bash scripts/update_docs.sh
/changelog
```

---

## 技能速查表

| 场景 | 命令 |
|------|------|
| 开始新功能 | `/brainstorming` |
| 创建计划 | `/writing-plans` |
| 创建分支 | `/using-git-worktrees` |
| TDD 开发 | `/test-driven-development` |
| 调试 | `/systematic-debugging` |
| 代码审查 | `/requesting-code-review` |
| 完成验证 | `/verification-before-completion` |
| 创建 PR | `/finishing-a-development-branch` |

---

**祝你开发顺利！🚀**

如有问题，运行 `bash scripts/guide.sh` 获取帮助。