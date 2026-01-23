---
name: skill-publisher
description: 一键发布 Claude Code Skills 到 GitHub。使用场景: (1) 推送已修改的 skill 到 GitHub 仓库, (2) 初始化新 skill 并创建 GitHub 仓库, (3) 批量推送多个 skills, (4) 管理 skill 的 Git 仓库。当用户说"推送 skill"、"发布 skill"、"把 skill 上传到 GitHub"、"创建 skill 仓库"时触发。
license: MIT
---

# Skill Publisher

一键发布 Claude Code Skills 到 GitHub 仓库。

## 快速开始

### 推送已有 Skill

当用户修改了 skill 文件后,直接运行:

```bash
push-skill <skill-name>
```

脚本会自动:
1. 检查 Git 状态
2. 添加所有更改
3. 提示选择提交信息
4. 推送到 GitHub

### 初始化新 Skill

对于全新创建的 skill:

```bash
init-skill-repo <skill-name>
```

脚本会自动:
1. 初始化 Git 仓库
2. 创建 .gitignore 文件
3. 在 GitHub 创建仓库
4. 首次提交并推送

之后每次修改只需运行 `push-skill <skill-name>`。

### 检查所有 Skills 状态

```bash
check-skills
```

显示所有 skills 的 Git 状态,包括:
- 已初始化/未初始化
- 有未提交的更改
- 有未推送的提交
- 远程仓库配置

### 批量推送多个 Skills

```bash
# 推送所有已初始化的 skills
batch-push

# 推送指定的 skills
batch-push skill1 skill2 skill3
```

## 核心 Scripts

### scripts/push-skill.sh

主要的推送脚本,提供完整的一键推送功能。

**使用方法:**
```bash
bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh <skill-name>
```

**功能:**
- 自动初始化 Git 仓库 (如果不存在)
- 自动创建 .gitignore 文件
- 智能检测文件变更
- 交互式提交信息选择
- 一键推送到 GitHub

**提交信息选项:**
1. 自动生成: `v{VERSION} - {TIMESTAMP}` (从 VERSION 文件读取)
2. 自定义: 用户输入自定义提交信息

### scripts/init-skill-repo.sh

初始化 skill 的 Git 仓库并创建 GitHub 远程仓库。

**使用方法:**
```bash
bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh <skill-name>
```

**功能:**
- 初始化 Git 仓库
- 创建 .gitignore
- 创建 GitHub 仓库 (使用 GitHub CLI)
- 配置远程仓库
- 首次提交并推送

### scripts/check-skills.sh

检查所有 skills 的 Git 状态。

**使用方法:**
```bash
bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh
```

**功能:**
- 扫描所有 skills 目录
- 显示每个 skill 的 Git 状态
- 标识需要推送的 skills
- 提供操作建议

**输出信息:**
- 未初始化 Git 的 skills
- 有未提交更改的 skills
- 有未推送提交的 skills
- 干净的 skills 及远程仓库信息

### scripts/batch-push.sh

批量推送多个 skills 到 GitHub。

**使用方法:**
```bash
# 推送所有已初始化的 skills
bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh

# 推送指定的 skills
bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh skill1 skill2 skill3
```

**功能:**
- 批量处理多个 skills
- 使用自动提交信息 (避免交互)
- 显示推送进度和结果
- 统计成功/失败数量

## 推送工作流

### 标准流程

```
1. 修改 skill 文件
   ↓
2. 运行 push-skill
   ↓
3. 选择提交信息
   ↓
4. 自动推送到 GitHub
```

### 提交信息最佳实践

推荐使用约定式提交 (Conventional Commits) 格式:

- `feat:` 新功能
- `fix:` Bug 修复
- `docs:` 文档更新
- `perf:` 性能优化
- `refactor:` 代码重构
- `test:` 测试相关

**示例:**
```bash
# 选择自定义提交信息
选择 [1/2]: 2
输入提交信息: feat: 新增 GitHub 自动发布功能
```

## 批量操作

### 推送多个 Skills

创建批量推送脚本:

```bash
#!/bin/bash
for skill in daily-topic-selector frontend-design pdf; do
    echo "推送 $skill..."
    bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh $skill
done
```

### 查看所有 Skills 状态

```bash
for dir in ~/.claude/skills/*/; do
    skill=$(basename "$dir")
    echo "=== $skill ==="
    cd "$dir"
    git status -sb 2>/dev/null || echo "未初始化 Git"
    echo ""
done
```

## .gitignore 规则

脚本自动创建的 `.gitignore` 包含:

```
# 运行时数据
data/
logs/
*.log

# Python
__pycache__/
*.pyc
*.pyo
*.egg-info/

# 临时文件
.DS_Store
*.swp
.env

# 状态文件
.circuit_breaker_*
.exit_signals
.call_count
.last_reset
```

## 故障排查

### 问题: 未找到远程仓库

**解决:**
```bash
# 使用 GitHub CLI 创建
gh repo create <skill-name> --public --source=. --push

# 或手动添加远程仓库
git remote add origin https://github.com/<username>/<skill-name>.git
```

### 问题: 推送失败 (Permission denied)

**解决:**
```bash
# 重新进行 GitHub 身份验证
gh auth login
```

### 问题: 没有新更改

**原因:** 所有文件已是最新状态,无需提交。

**验证:**
```bash
cd ~/.claude/skills/<skill-name>
git status
```

## 别名配置

在 `~/.bashrc` 中添加:

```bash
# 英文别名
alias push-skill='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias init-skill-repo='bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh'

# 中文别名
alias 推送='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 推送技能='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 初始化技能仓库='bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh'
```

重新加载配置:
```bash
source ~/.bashrc
```

## 使用示例

### 示例 1: 日常修改推送

```bash
# 1. 编辑 skill
vim ~/.claude/skills/daily-topic-selector/SKILL.md

# 2. 推送
推送 daily-topic-selector

# 3. 选择提交信息
请选择提交信息:
  1) 自动生成 (v2.12.0 - 2026-01-23 10:30:00)
  2) 自定义
选择 [1/2]: 2
输入提交信息: docs: 更新使用说明

# 4. 等待推送完成
✅ 推送成功!
```

### 示例 2: 首次发布新 Skill

```bash
# 1. 创建新 skill
mkdir -p ~/.claude/skills/my-new-skill
cd ~/.claude/skills/my-new-skill
# ... 编辑 SKILL.md 等文件 ...

# 2. 初始化并创建 GitHub 仓库
初始化技能仓库 my-new-skill

# 3. 以后每次修改只需
推送 my-new-skill
```

### 示例 3: 批量推送

```bash
# 创建批量推送脚本
cat > ~/push-all.sh << 'EOF'
#!/bin/bash
skills="daily-topic-selector frontend-design pdf skill-publisher"
for skill in $skills; do
    echo "推送 $skill..."
    推送 $skill
    echo "---"
done
EOF

chmod +x ~/push-all.sh
~/push-all.sh
```

## 相关资源

- GitHub CLI 文档: https://cli.github.com/manual/
- Git 官方文档: https://git-scm.com/doc
- 约定式提交: https://www.conventionalcommits.org/
