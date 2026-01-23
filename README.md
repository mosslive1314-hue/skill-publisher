# Skill Publisher

> 一键发布 Claude Code Skills 到 GitHub

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 🚀 一键安装

### 方法 1：直接克隆（推荐）

在 Claude Code 对话框或终端中运行：

```bash
git clone https://github.com/mosslive1314-hue/skill-publisher.git ~/.claude/skills/skill-publisher && source ~/.claude/skills/skill-publisher/scripts/install.sh
```

**安装完成！** Skill 会自动添加到你的 `~/.claude/skills/` 目录，Claude Code 会自动识别并可以使用。

### 方法 2：手动克隆

```bash
# 1. 克隆仓库
git clone https://github.com/mosslive1314-hue/skill-publisher.git ~/.claude/skills/skill-publisher

# 2. 配置别名（添加到 ~/.bashrc）
cat >> ~/.bashrc << 'EOF'

# Skill Publisher 别名
alias 推送='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 初始化技能仓库='bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh'
alias 检查技能='bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh'
alias 批量推送='bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh'
EOF

# 3. 重新加载配置
source ~/.bashrc
```

---

## ✨ 功能特性

✅ 自动初始化 Git 仓库
✅ 自动创建 .gitignore
✅ 交互式提交信息选择
✅ 一键推送到 GitHub
✅ 批量推送多个 skills
✅ 检查所有 skills 状态
✅ 自动在浏览器中打开仓库
✅ 彩色输出，清晰直观

---

## 📋 快速开始

### 推送已有 Skill

```bash
推送 daily-topic-selector
```

### 初始化新 Skill

```bash
初始化技能仓库 my-new-skill
```

### 检查所有 Skills

```bash
检查技能
```

### 批量推送

```bash
批量推送                      # 推送所有
批量推送 skill1 skill2        # 推送指定
```

---

## 📖 命令列表

| 中文命令 | 英文命令 | 功能 |
|---------|---------|------|
| `推送 <skill>` | `push-skill <skill>` | 推送 skill 到 GitHub |
| `初始化技能仓库 <skill>` | `init-skill-repo <skill>` | 初始化 skill 并创建 GitHub 仓库 |
| `检查技能` | `check-skills` | 检查所有 skills 状态 |
| `批量推送 [skills]` | `batch-push [skills]` | 批量推送 skills |

---

## 📝 使用示例

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

# 2. 创建 SKILL.md
cat > SKILL.md << 'EOF'
---
name: my-awesome-skill
description: 我的超棒技能
license: MIT
---

# My Awesome Skill
EOF

# 3. 一键发布
初始化技能仓库 my-awesome-skill

# 4. 完成! 仓库已在 GitHub 创建
📍 仓库地址: https://github.com/yourname/my-awesome-skill
```

### 示例 3: 检查状态

```bash
检查技能

# 输出:
# ━━━ daily-topic-selector ━━━
# ✓ 干净
#   分支: main
#   远程: username/daily-topic-selector
#
# ━━━ my-new-skill ━━━
# 📝 有未提交的更改
#   → 运行: 推送 my-new-skill
```

### 示例 4: 批量推送

```bash
# 推送所有已初始化的 skills
批量推送

# 推送指定的 skills
批量推送 daily-topic-selector frontend-design pdf
```

---

## 🔧 前置要求

在使用前，请确保已安装：

1. **Git** (必需)
   ```bash
   git --version
   ```

2. **GitHub CLI** (必需)
   ```bash
   gh --version
   gh auth login
   ```

---

## 📦 目录结构

```
skill-publisher/
├── SKILL.md                      # Skill 定义
├── README.md                     # 本文件
├── QUICKREF.md                   # 快速参考
├── DEPLOYMENT.md                 # 部署指南
├── VERSION                       # 版本号
├── scripts/                      # Bash 脚本
│   ├── push-skill.sh            # 推送脚本
│   ├── init-skill-repo.sh       # 初始化脚本
│   ├── check-skills.sh          # 状态检查
│   ├── batch-push.sh            # 批量推送
│   └── install.sh               # 一键安装脚本
└── references/                   # 参考文档
    ├── GUIDE.md                  # 完整指南
    ├── EXAMPLES.md               # 使用案例
    └── FAQ.md                    # 常见问题
```

---

## 📚 更多信息

- **完整指南**: [references/GUIDE.md](references/GUIDE.md)
- **使用案例**: [references/EXAMPLES.md](references/EXAMPLES.md)
- **常见问题**: [references/FAQ.md](references/FAQ.md)
- **部署指南**: [DEPLOYMENT.md](DEPLOYMENT.md)

---

## 🔄 更新

```bash
cd ~/.claude/skills/skill-publisher
git pull
```

---

## 📊 版本

**v1.2.0** - 2026-01-23

✨ 新增:
- 一键安装脚本
- 批量推送功能
- 状态检查功能
- 完整文档

---

## 🤝 贡献

欢迎贡献！请访问:
https://github.com/mosslive1314-hue/skill-publisher

---

## 📄 许可证

MIT License

---

**📍 GitHub**: https://github.com/mosslive1314-hue/skill-publisher
