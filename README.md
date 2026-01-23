# Skill Publisher

> 一键发布 Claude Code Skills 到 GitHub

## 🚀 快速安装

### 方法 1: NPM 全局安装 (推荐)

```bash
npm install -g skill-publisher
```

安装后即可使用:

```bash
push-skill <skill>              # 推送 skill
init-skill-repo <skill>         # 初始化 skill
check-skills                    # 检查状态
batch-push                      # 批量推送
```

### 方法 2: 使用 NPX (无需安装)

```bash
npx skill-publisher push <skill>
npx skill-publisher init <skill>
npx skill-publisher check
```

### 方法 3: 手动安装

详见 `DEPLOYMENT.md` 或 `NPM.md`

---

## 📋 快速开始

### 推送已有 Skill

```bash
push-skill daily-topic-selector
```

### 初始化新 Skill

```bash
init-skill-repo my-new-skill
```

### 检查所有 Skills

```bash
check-skills
```

### 批量推送

```bash
batch-push                      # 推送所有
batch-push skill1 skill2        # 推送指定
```

---

## 📖 命令列表

| NPM 命令 | 中文别名 | 英文别名 | 功能 |
|---------|---------|---------|------|
| `push-skill <skill>` | `推送` | `push-skill` | 推送 skill |
| `init-skill-repo <skill>` | `初始化技能仓库` | `init-skill-repo` | 初始化 skill |
| `check-skills` | `检查技能` | `check-skills` | 检查状态 |
| `batch-push [skills]` | `批量推送` | `batch-push` | 批量推送 |

### 主命令

```bash
skill-publisher push <skill>      # 推送
skill-publisher init <skill>      # 初始化
skill-publisher check             # 检查
skill-publisher batch [skills]    # 批量
skill-publisher version           # 版本
skill-publisher help              # 帮助
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
✅ 彩色输出,清晰直观
✅ 支持 NPM/NPX 全局安装

---

## 📝 使用示例

### 示例 1: 推送修改

```bash
# 1. 编辑 skill
vim ~/.claude/skills/daily-topic-selector/SKILL.md

# 2. 推送
push-skill daily-topic-selector

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
init-skill-repo my-awesome-skill

# 4. 完成!仓库已在 GitHub 创建
📍 仓库地址: https://github.com/yourname/my-awesome-skill
```

### 示例 3: 检查状态

```bash
check-skills

# 输出:
# ━━━ daily-topic-selector ━━━
# ✓ 干净
#   分支: main
#   远程: username/daily-topic-selector
#
# ━━━ my-new-skill ━━━
# 📝 有未提交的更改
#   → 运行: push-skill my-new-skill
```

### 示例 4: 批量推送

```bash
# 推送所有已初始化的 skills
batch-push

# 推送指定的 skills
batch-push daily-topic-selector frontend-design pdf
```

---

## 📦 目录结构

```
skill-publisher/
├── SKILL.md                      # Skill 定义
├── README.md                     # 本文件
├── QUICKREF.md                   # 快速参考
├── DEPLOYMENT.md                 # 部署指南
├── NPM.md                        # NPM 安装指南
├── VERSION                       # 版本号
├── package.json                  # NPM 配置
├── bin/                          # NPM 命令
│   ├── push-skill.js
│   ├── init-skill-repo.js
│   ├── check-skills.js
│   ├── batch-push.js
│   └── skill-publisher.js
├── scripts/                      # Bash 脚本
│   ├── push-skill.sh
│   ├── init-skill-repo.sh
│   ├── check-skills.sh
│   ├── batch-push.sh
│   ├── test.sh
│   └── postinstall.js
└── references/                   # 参考文档
    ├── GUIDE.md                  # 完整指南
    ├── EXAMPLES.md               # 使用案例
    └── FAQ.md                    # 常见问题
```

---

## 🔧 前置要求

在使用前,请确保已安装:

1. **Git** (必需)
   ```bash
   git --version
   ```

2. **GitHub CLI** (必需)
   ```bash
   gh --version
   gh auth login
   ```

3. **Node.js** (使用 NPM 时需要)
   ```bash
   node --version  # 需要 >= 14.0.0
   ```

---

## ❓ 故障排查

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

### 问题: 找不到命令 (NPM)

**解决:**
```bash
# 检查是否安装成功
npm list -g skill-publisher

# 查看 npm bin 目录
npm bin -g

# 重新安装
npm install -g skill-publisher
```

### 问题: 找不到命令 (别名)

**解决:**
```bash
# 重新加载配置
source ~/.bashrc

# 检查别名
alias | grep 推送
```

---

## 📚 更多信息

- **完整指南**: `references/GUIDE.md`
- **使用案例**: `references/EXAMPLES.md`
- **常见问题**: `references/FAQ.md`
- **部署指南**: `DEPLOYMENT.md`
- **NPM 安装**: `NPM.md`

---

## 🔄 更新

```bash
# NPM 安装
npm update -g skill-publisher

# 手动安装
cd ~/.claude/skills/skill-publisher
git pull
```

---

## 📊 版本

**v1.1.0** - 2026-01-23

✨ 新增:
- NPM/NPX 全局安装支持
- 批量推送功能
- 状态检查功能
- 完整文档

---

## 🤝 贡献

欢迎贡献!请访问:
https://github.com/mosslive1314-hue/skill-publisher

---

## 📄 许可证

MIT License

---

**📍 GitHub**: https://github.com/mosslive1314-hue/skill-publisher
