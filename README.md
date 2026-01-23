# Skill Publisher

> 一键发布 Claude Code Skills 到 GitHub

## 快速开始

### 推送已有 Skill

```bash
推送 daily-topic-selector
```

### 初始化新 Skill

```bash
初始化技能仓库 my-new-skill
```

## 命令列表

| 中文命令 | 英文命令 | 功能 |
|---------|---------|------|
| `推送 <skill>` | `push-skill <skill>` | 推送 skill 到 GitHub |
| `推送技能 <skill>` | `push-skill <skill>` | 推送 skill 到 GitHub |
| `初始化技能仓库 <skill>` | `init-skill-repo <skill>` | 初始化 skill 并创建 GitHub 仓库 |

## 功能特性

✅ 自动初始化 Git 仓库
✅ 自动创建 .gitignore
✅ 交互式提交信息选择
✅ 一键推送到 GitHub
✅ 自动在浏览器中打开仓库
✅ 彩色输出,清晰直观

## 使用示例

### 示例 1: 推送修改

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

# 4. 完成!
✅ 推送成功!
```

### 示例 2: 发布新 Skill

```bash
# 1. 创建新 skill
mkdir -p ~/.claude/skills/my-awesome-skill
cd ~/.claude/skills/my-awesome-skill
# ... 创建 SKILL.md 等文件 ...

# 2. 一键发布
初始化技能仓库 my-awesome-skill

# 3. 完成!仓库已在 GitHub 创建
📍 仓库地址: https://github.com/yourname/my-awesome-skill
```

## 目录结构

```
skill-publisher/
├── SKILL.md                 # Skill 定义
├── README.md                # 本文件
├── scripts/                 # 可执行脚本
│   ├── push-skill.sh       # 推送脚本
│   └── init-skill-repo.sh  # 初始化脚本
└── references/             # 参考文档
    └── GUIDE.md            # 完整使用指南
```

## 故障排查

### 问题: 推送失败

**解决:**
```bash
# 检查 GitHub 登录状态
gh auth login

# 检查 Git 状态
cd ~/.claude/skills/your-skill
git status
git remote -v
```

### 问题: 找不到命令

**解决:**
```bash
# 重新加载配置
source ~/.bashrc

# 检查别名
alias 推送
```

## 更多信息

详细文档请查看: `references/GUIDE.md`

## 版本

v1.0.0 - 2026-01-23
