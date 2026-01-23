# NPM/NPX 安装指南

Skill Publisher 现已支持通过 NPM/NPX 一键安装!

---

## 🚀 快速安装

### 方法 1: 全局安装 (推荐)

```bash
npm install -g skill-publisher
```

安装后即可在任意位置使用命令:

```bash
# 推送 skill
push-skill <skill-name>

# 初始化 skill
init-skill-repo <skill-name>

# 检查状态
check-skills

# 批量推送
batch-push
```

### 方法 2: 使用 NPX (无需安装)

```bash
# 使用 NPX 直接运行
npx skill-publisher push <skill-name>
npx skill-publisher init <skill-name>
npx skill-publisher check
npx skill-publisher batch
```

### 方法 3: 本地安装

```bash
# 克隆仓库
git clone https://github.com/mosslive1314-hue/skill-publisher.git
cd skill-publisher

# 安装依赖
npm install

# 链接到全局
npm link
```

---

## 📋 可用命令

安装后可使用以下命令:

### 快捷命令

| 命令 | 说明 | 示例 |
|-----|------|------|
| `push-skill <skill>` | 推送 skill 到 GitHub | `push-skill daily-topic-selector` |
| `init-skill-repo <skill>` | 初始化新 skill | `init-skill-repo my-skill` |
| `check-skills` | 检查所有 skills 状态 | `check-skills` |
| `batch-push [skills]` | 批量推送 skills | `batch-push` 或 `batch-push skill1 skill2` |

### 主命令

```bash
# 使用主命令
skill-publisher push <skill>      # 推送 skill
skill-publisher init <skill>      # 初始化 skill
skill-publisher check             # 检查状态
skill-publisher batch [skills]    # 批量推送
skill-publisher version           # 显示版本
skill-publisher help              # 显示帮助
```

---

## 🔧 前置要求

在使用前,请确保已安装:

1. **Git** (必需)
   ```bash
   git --version
   # Windows: winget install Git.Git
   # macOS: brew install git
   # Linux: sudo apt install git
   ```

2. **GitHub CLI** (必需)
   ```bash
   gh --version
   # Windows: winget install --id GitHub.cli
   # macOS: brew install gh
   # Linux: sudo apt install gh
   ```

3. **Node.js** (使用 NPM 安装时需要)
   ```bash
   node --version  # 需要 >= 14.0.0
   # 下载: https://nodejs.org/
   ```

4. **登录 GitHub**
   ```bash
   gh auth login
   ```

---

## 📖 使用示例

### 示例 1: 发布新 Skill

```bash
# 1. 创建 skill 目录
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

这是一个超棒的 skill!
EOF

# 3. 初始化并发布
init-skill-repo my-awesome-skill

# ✅ 完成! GitHub 仓库已创建
```

### 示例 2: 日常推送

```bash
# 修改 skill 文件
vim ~/.claude/skills/my-awesome-skill/SKILL.md

# 推送更新
push-skill my-awesome-skill

# 选择提交信息
# ✅ 完成!
```

### 示例 3: 检查所有 Skills

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

# 或推送指定的 skills
batch-push skill1 skill2 skill3
```

---

## 🔄 更新

```bash
# 更新到最新版本
npm update -g skill-publisher

# 或重新安装
npm install -g skill-publisher@latest
```

---

## 🗑️ 卸载

```bash
npm uninstall -g skill-publisher
```

---

## 🆚 对比: NPM 安装 vs 手动安装

| 特性 | NPM 安装 | 手动安装 |
|-----|---------|---------|
| 安装难度 | ⭐ 简单 | ⭐⭐ 中等 |
| 命令可用性 | ✅ 全局可用 | ⚠️ 需要配置别名 |
| 更新方式 | npm update | git pull |
| 依赖管理 | ✅ 自动 | ❌ 手动 |
| 跨平台支持 | ✅ 优秀 | ⚠️ 需要适配 |
| 推荐场景 | 快速上手 | 高级定制 |

---

## 🔍 故障排查

### 问题 1: 命令找不到

```bash
# 检查是否安装成功
npm list -g skill-publisher

# 查看 npm bin 目录
npm bin -g

# 确保 npm bin 目录在 PATH 中
echo $PATH | grep -o "[^:]*npm[^:]*"
```

### 问题 2: 权限错误 (macOS/Linux)

```bash
# 使用 sudo 安装
sudo npm install -g skill-publisher

# 或配置 npm 目录
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
npm install -g skill-publisher
```

### 问题 3: GitHub CLI 未登录

```bash
gh auth login
```

### 问题 4: Git 或 Node.js 版本过低

```bash
# 检查版本
git --version    # 需要 >= 2.0
node --version   # 需要 >= 14.0

# 升级 Node.js (使用 nvm)
nvm install node
```

---

## 📚 更多信息

- **完整文档**: https://github.com/mosslive1314-hue/skill-publisher
- **使用案例**: `references/EXAMPLES.md`
- **常见问题**: `references/FAQ.md`
- **部署指南**: `DEPLOYMENT.md`

---

## 🤝 贡献

欢迎贡献!请访问:
https://github.com/mosslive1314-hue/skill-publisher

---

**最后更新**: 2026-01-23
**版本**: v1.1.0
