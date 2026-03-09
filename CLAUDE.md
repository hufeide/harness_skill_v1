# CLAUDE.md

> Claude AI 工作指引

## 项目概述

**Claude 技能库** - 智能开发引导系统，提供自动化工作流和最佳实践。

### 核心功能

- 🤖 智能引导系统
- 🔄 自动化工作流
- 📚 文档管理
- 🛠️ 工具集成

---

## ⚠️ 重要提醒

### 完成每个阶段后必须更新状态

为了正确追踪项目进度，**每完成一个阶段都要立即更新状态**：

| 阶段 | 完成后立即运行 |
|------|---------------|
| 需求分析 | `bash scripts/brainstorm_complete.sh` |
| 任务规划 | `bash scripts/update_state.sh update tasks "任务规划完成"` |
| 功能开发 | `bash scripts/update_state.sh update development "完成 <功能名>"` |
| 开发完成 | `bash scripts/dev_complete.sh` |
| 测试通过 | `bash scripts/update_state.sh update verify "测试通过"` |

**为什么重要？**
- ✅ 保持 `.guide_history` 记录完整
- ✅ 准确追踪项目进度
- ✅ 自动显示下一步操作
- ✅ 便于回顾开发过程

---

## 文件组织规范

### 代码文件位置

- **源代码**: `src/`
  - Python: `src/*.py`
  - JavaScript/TypeScript: `src/*.js`, `src/*.ts`
  - Ruby: `src/*.rb`

- **测试文件**: `tests/`
  - Python: `tests/test_*.py`
  - JavaScript: `tests/*.test.js`
  - Ruby: `tests/*_spec.rb`

- **配置文件**: 项目根目录
  - `requirements.txt`, `package.json`, `Gemfile`

- **文档**: `docs/`
  - 设计文档: `docs/plans/`
  - 决策记录: `docs/decisions/`

### 创建文件时的注意事项

使用 `fsWrite` 创建文件时，请确保：
1. 源代码文件放在 `src/` 目录
2. 测试文件放在 `tests/` 目录
3. 使用相对于项目根目录的路径

示例：
```
✅ 正确: src/app.py
❌ 错误: app.py

✅ 正确: tests/test_app.py
❌ 错误: test_app.py
```

---

## 开发工作流程

### 1. 需求分析 (/brainstorming)

完成 `/brainstorming` 后，**立即运行**：

```bash
bash scripts/brainstorm_complete.sh
```

这会自动：
- ✅ 更新 `.guide_history` 记录
- ✅ 更新项目状态为 "planning"
- ✅ 提示创建设计文档
- ✅ 提供设计文档模板
- ✅ 显示下一步操作

**或者手动执行**：

1. 更新状态：
   ```bash
   bash scripts/update_state.sh update planning "完成需求分析"
   ```

2. 创建设计文档：
   ```bash
   # 文件名格式：YYYY-MM-DD-<topic>-design.md
   touch docs/plans/$(date +%Y-%m-%d)-<feature-name>-design.md
   ```

3. 在设计文档中记录：
   - 需求概述
   - 技术方案
   - 架构设计
   - 实施计划

### 2. 创建计划 (/writing-plans)

完成 `/writing-plans` 后，**立即运行**：

```bash
bash scripts/update_state.sh update tasks "任务规划完成"
```

这会：
- ✅ 更新 `.guide_history` 记录
- ✅ 更新项目状态为 "tasks"

开始开发前确认：
- [ ] 设计文档已创建
- [ ] 任务列表已生成
- [ ] 技术方案已确定
- [ ] 状态已更新

### 3. 功能开发

开发过程中：

1. **确保文件位置正确**
   - 源代码 → `src/`
   - 测试代码 → `tests/`

2. **定期更新状态**
   ```bash
   bash scripts/update_state.sh update development "实现 <功能名称>"
   ```

3. **遵循 TDD 流程**
   - 先写测试
   - 实现功能
   - 重构代码

### 4. 开发完成

完成代码编写后，运行：

```bash
bash scripts/dev_complete.sh
```

这会：
- 更新项目状态为 "testing"
- 显示测试命令
- 提醒测试覆盖率目标
- 提示下一步操作

### 5. 测试验证

1. **运行测试**
   ```bash
   # Python
   pytest tests/ -v
   pytest tests/ --cov=src --cov-report=html
   
   # Node.js
   npm test
   npm test -- --coverage
   
   # Ruby
   bundle exec rspec
   ```

2. **检查覆盖率**
   - 总体覆盖率：> 80%
   - 核心功能：> 90%

3. **修复失败的测试**
   - 如果测试失败，修复代码
   - 重新运行测试直到全部通过

4. **更新状态**
   ```bash
   bash scripts/update_state.sh update verify "测试通过"
   ```

### 6. 代码审查

```
/requesting-code-review
```

### 7. 完成验证

```
/verification-before-completion
```

### 8. 提交代码

```bash
git add .
git commit -m "feat: <功能描述>"
```

---

## 快速参考

### 用户说什么时自动响应

| 用户说 | 自动执行 |
|--------|---------|
| "我迷路了" / "不知道做什么" | 显示完整引导 |
| "下一步做什么" / "有什么建议" | 显示下一步建议 |
| "查看状态" / "当前进度" | 显示项目状态 |
| "查看最佳实践" | 显示最佳实践 |
| "技能列表" / "有什么技能" | 显示技能速查表 |
| "检查设置" / "检查配置" | 运行设置检查 |
| "初始化项目" | 运行项目初始化 |

### 核心技能命令

| 命令 | 用途 |
|------|------|
| `/brainstorming` | 需求探索 |
| `/writing-plans` | 创建计划 |
| `/test-driven-development` | TDD 开发 |
| `/systematic-debugging` | 调试 |
| `/using-git-worktrees` | 分支管理 |
| `/requesting-code-review` | 代码审查 |
| `/verification-before-completion` | 完成验证 |
| `/finishing-a-development-branch` | 创建 PR |

### 核心脚本

| 脚本 | 用途 |
|------|------|
| `scripts/quickstart.sh` | 快速开始 |
| `scripts/guide.sh` | 智能引导 |
| `scripts/check_setup.sh` | 设置检查 |
| `scripts/update_docs.sh` | 更新文档 |

---

## 工作流程

```
项目初期 → 项目开始 → 开发中 → 里程碑完成
   ↓          ↓         ↓          ↓
 初始化    需求分析   功能开发   代码审查
```

### 阶段 1：项目初期

```bash
bash scripts/quickstart.sh
bash scripts/check_setup.sh
```

### 阶段 2：项目开始

```
/brainstorming → /writing-plans → 创建任务
```

### 阶段 3：开发中

```
/test-driven-development → 编码 → /requesting-code-review → /verification-before-completion
```

### 阶段 4：里程碑完成

```bash
npm test
bash scripts/update_docs.sh
/changelog
/finishing-a-development-branch
```

---

## 目录结构

```
项目根目录/
├── config/              # 配置文件
│   ├── env.json         # 环境变量
│   └── project.json     # 项目配置
├── docs/                # 文档
│   ├── 快速开始.md
│   ├── 完整指南.md
│   ├── API参考.md
│   ├── 最佳实践.md
│   ├── 故障排除.md
│   ├── plans/           # 设计文档
│   └── decisions/       # ADR 记录
├── scripts/             # 自动化脚本
├── examples/            # 示例项目
├── templates/           # 项目模板
├── src/                 # 源代码
├── tests/               # 测试文件
├── .guide_state         # 项目状态
└── .guide_history       # 活动历史
```

---

## 配置文件

### config/env.json

```json
{
  "PROJECT_NAME": "项目名称",
  "PROJECT_DESCRIPTION": "项目描述",
  "GITHUB_USER": "GitHub用户名",
  "GITHUB_REPO": "仓库名",
  "GITHUB_TOKEN": "访问令牌",
  "DATABASE_URL": "数据库连接",
  "MODEL": "claude-sonnet-3.5",
  "DEFAULT_BRANCH": "main"
}
```

---

## 最佳实践

### 代码提交

```
<type>(<scope>): <subject>

<body>

<footer>
```

类型：`feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### 分支命名

```
feature/<description>
bugfix/<description>
hotfix/<description>
```

### 测试覆盖率

- 总体覆盖率：> 80%
- 核心业务逻辑：> 90%

---

## 故障排除

### 迷路了？

```bash
bash scripts/guide.sh
# 或在 Claude 中说"我迷路了"
```

### 检查设置

```bash
bash scripts/check_setup.sh
```

### 技能找不到

```
/find-skills
```

---

## 文档链接

- [快速开始](docs/快速开始.md) - 5分钟上手
- [完整指南](docs/完整指南.md) - 详细功能说明
- [API参考](docs/API参考.md) - 所有命令
- [最佳实践](docs/最佳实践.md) - 工作流技巧
- [故障排除](docs/故障排除.md) - 常见问题

---

**版本**：2.0.0
**最后更新**：2026-03-09
