# 技能测试文档

本文档记录 Claude 项目技能的测试步骤和结果。

---

## 环境检查

### 运行完整检查

```bash
bash scripts/check_setup.sh
```

**预期结果：** 所有 16 项检查通过

---

## 脚本测试

### 1. setup_plugins.sh

**目的：** 检查插件和技能安装状态

**命令：**
```bash
bash scripts/setup_plugins.sh
```

**预期输出：**
- 列出所有已安装的核心技能
- 列出已安装的插件
- 提示使用 check_setup.sh 进行完整检查

### 2. setup_hooks.sh

**目的：** 配置 Claude hooks

**命令：**
```bash
bash scripts/setup_hooks.sh
```

**预期输出：**
- 创建 `~/.claude/hooks/pre_commit`
- 创建 `~/.claude/hooks/post_commit`
- 设置执行权限

### 3. check_setup.sh

**目的：** 验证所有设置是否正确

**命令：**
```bash
bash scripts/check_setup.sh
```

**检查项：**
1. Claude Code CLI
2. feature-dev 插件
3. compound-engineering 插件
4. brainstorming 技能
5. writing-plans 技能
6. test-driven-development 技能
7. systematic-debugging 技能
8. using-git-worktrees 技能
9. requesting-code-review 技能
10. verification-before-completion 技能
11. Hooks 目录
12. pre_commit hook
13. post_commit hook
14. 项目配置文件
15. CLAUDE.md
16. Git 仓库

---

## 功能测试

### 测试 1: 使用 brainstorming 技能

**场景：** 开始一个新功能开发

**步骤：**
1. 运行 `/brainstorming`
2. 回答澄清问题
3. 查看提出的方案
4. 确认设计方案

**预期：** 技能正常启动，能够进行对话

### 测试 2: 使用 writing-plans 技能

**场景：** 创建实施计划

**步骤：**
1. 运行 `/writing-plans`
2. 查看生成的任务列表
3. 检查依赖关系

**预期：** 生成详细的实施计划

### 测试 3: 使用 using-git-worktrees

**场景：** 创建功能分支

**步骤：**
1. 运行 `/using-git-worktrees`
2. 查看创建的 worktree

**预期：** 成功创建隔离的开发环境

---

## Hooks 测试

### 测试 pre_commit hook

**命令：**
```bash
~/.claude/hooks/pre_commit
```

**预期：**
- 检查项目类型（package.json/Gemfile/pyproject.toml）
- 运行相应的 lint 和测试命令
- 输出完成消息

### 测试 post_commit hook

**命令：**
```bash
~/.claude/hooks/post_commit
```

**预期：**
- 运行文档更新脚本
- 输出完成消息

---

## 测试记录

| 日期 | 测试项 | 结果 | 备注 |
|------|--------|------|------|
| 2026-03-07 | check_setup.sh | ✓ 通过 | 16/16 检查通过 |
| 2026-03-07 | setup_plugins.sh | ✓ 通过 | 核心技能已安装 |
| 2026-03-07 | setup_hooks.sh | ✓ 通过 | Hooks 已创建 |

---

## 故障排除

### 问题：技能未找到

**解决：**
```bash
/find-skills
```

### 问题：Hooks 未执行

**解决：**
```bash
chmod +x ~/.claude/hooks/*
```

### 问题：插件未安装

**解决：**
```bash
npx claude-plugins install <plugin-name>
```

---

**最后更新：** 2026-03-07