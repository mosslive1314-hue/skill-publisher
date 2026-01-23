# Skill Publisher 快速参考

## 📌 已创建的文件

```
skill-publisher/
├── SKILL.md                          ✓ Skill 定义
├── README.md                         ✓ 快速开始指南
├── QUICKREF.md                       ✓ 本文件
├── scripts/
│   ├── push-skill.sh                ✓ 推送脚本
│   └── init-skill-repo.sh           ✓ 初始化脚本
└── references/
    └── GUIDE.md                      ✓ 完整使用指南
```

## 🚀 立即使用

### 1. 重新加载配置

```bash
source ~/.bashrc
```

### 2. 推送已有 Skill

```bash
推送 skill-publisher
```

### 3. 测试功能

```bash
# 查看所有可用命令
推送

# 应该显示所有 skills 列表
```

## 📝 可用命令

| 中文 | 英文 | 功能 |
|-----|------|------|
| `推送` | `push-skill` | 推送到 GitHub |
| `推送技能` | `push-skill` | 推送到 GitHub |
| `初始化技能仓库` | `init-skill-repo` | 初始化并创建仓库 |

## 🎯 使用场景

### 场景 1: 日常推送

```bash
# 修改了 skill 文件后
推送 daily-topic-selector
# 选择提交信息
# ✅ 完成!
```

### 场景 2: 首次发布

```bash
# 创建新 skill 后
初始化技能仓库 my-new-skill
# ✅ GitHub 仓库已创建!
```

## 🔧 配置位置

- **Skill 目录**: `~/.claude/skills/skill-publisher/`
- **别名配置**: `~/.bashrc`
- **推送脚本**: `~/.claude/skills/skill-publisher/scripts/push-skill.sh`
- **初始化脚本**: `~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh`

## 📚 更多信息

详细指南: `references/GUIDE.md`
