---
name: lark-skill-publisher
version: 1.2.0
description: "🚀 一键发布 Claude Code Skills 到 GitHub - 自动初始化仓库、创建 GitHub 仓库、一键推送、批量推送、状态检查。让你专注创作，发布交给机器。"
metadata:
  category: "development"
  requires:
    bins: ["git", "gh"]
---

# lark-skill-publisher v1.2.0 - Skill 发布助手

> **一键发布 Claude Code Skills 到 GitHub** — 让你专注创作，发布交给机器。

## 🎯 定位

Skill Publisher 是一个**开发效率工具**，帮你一键发布 Claude Code Skills 到 GitHub：

- 修改完 Skill 文件，一条命令推送到 GitHub
- 新建 Skill，一条命令初始化 + 创建 GitHub 仓库 + 首次推送
- 批量推送多个 Skills，检查所有 Skills 状态
- 支持中文别名，符合国内使用习惯

**适合**:
- 你经常用 Claude Code 创建 Skills
- 你想要把自己写的 Skills 开源分享出去
- 你嫌每次 git add/commit/push 太麻烦
- 想要一个自动化的发布 workflow

## ✨ 核心能力

| 能力 | 说明 |
|------|------|
| 🚀 **一键推送** | 修改完 Skill，一条命令完成 add/commit/push |
| 🎉 **初始化新建** | 一条命令初始化 Git + 创建 GitHub 仓库 + 首次推送 |
| 🔍 **状态检查** | 扫描所有 Skills，显示哪些有未提交更改 |
| 📦 **批量推送** | 一次推送多个 Skills，节省时间 |
| 🎨 **友好交互** | 彩色输出，交互式选择提交信息，清晰提示 |
| 🇨🇳 **中文友好** | 内置中文别名，直接用「推送」「初始化」「检查」就能用 |

## 🗺️ 工作流

```
  你编辑 Skill 文件
    ↓
  push-skill <skill-name>
    ↓
  自动检查 → 选择提交信息 → 一键推送完成
    ↓
  GitHub 仓库更新完成 ✅
```

## 🚀 快速开始

### 一键安装（推荐）

在 Claude Code 对话框运行：

```bash
npm install @mosslive1314-hue/skill-publisher
```

安装完成自动配置别名，立即可用。

### 可用命令

| 中文命令 | 英文命令 | 功能 |
|---------|---------|------|
| `推送 <skill>` | `push-skill <skill>` | 推送 Skill 到 GitHub |
| `初始化技能仓库 <skill>` | `init-skill-repo <skill>` | 初始化 Skill 并创建 GitHub 仓库 |
| `检查技能` | `check-skills` | 检查所有 Skills 状态 |
| `批量推送 [skills]` | `batch-push [skills]` | 批量推送多个 Skills |

## 🛠️ 脚本说明

### push-skill.sh

主要推送脚本，一键完成所有操作：

```bash
bash push-skill.sh <skill-name>
```

功能：
1. 检查 Git 状态
2. 如果未初始化，询问是否初始化
3. 添加所有更改
4. 交互式选择提交信息
   - 选项 1: 自动生成 `v{VERSION} - {TIMESTAMP}`（从 VERSION 文件读取）
   - 选项 2: 自定义提交信息
5. 推送到 GitHub

### init-skill-repo.sh

初始化新 Skill 并创建 GitHub 仓库：

```bash
bash init-skill-repo.sh <skill-name>
```

功能：
1. 初始化 Git 仓库
2. 自动创建 `.gitignore`（包含 Python/tmp/log 等常用规则）
3. 使用 GitHub CLI 在 GitHub 创建公开仓库
4. 配置远程地址
5. 首次提交并推送

### check-skills.sh

检查所有 Skills 状态：

```bash
bash check-skills.sh
```

输出：
- 列出每个 Skill 的 Git 状态
- 标识哪些有未提交更改
- 给出操作建议

### batch-push.sh

批量推送多个 Skills：

```bash
bash batch-push.sh [skill1 skill2 ...]
```

功能：
- 循环推送每个 Skill
- 使用自动提交信息（无交互）
- 统计成功/失败数量
- 显示最终结果

## 📝 提交信息规范

推荐使用**约定式提交**（Conventional Commits）：

| 前缀 | 用途 |
|------|------|
| `feat:` | 新增功能 |
| `fix:` | 修复 Bug |
| `docs:` | 文档更新 |
| `perf:` | 性能优化 |
| `refactor:` | 代码重构 |
| `test:` | 测试相关 |

## 🔒 安全边界

### 禁止操作
- ❌ 不会修改你的 Skill 代码内容
- ❌ 不会删除任何文件
- ❌ 不会访问任何非 Skill 目录
- ❌ 不会上传你的私密信息

### 需要确认
- ⚠️ 创建 GitHub 仓库需要确认（GitHub CLI 会交互确认）
- ⚠️ 推送需要你有 GitHub 权限（gh auth login 完成）

## 💡 设计哲学

- **最小完备** - 只做发布，不干涉创作
- **约定大于配置** - 合理默认值，大多数情况不用改配置
- **渐进披露** - 复杂参数可选，默认够用
- **省力** - 让机器做重复劳动，人专注创作

## 📊 为什么需要这个工具？

每次修改完 Skill 都要：
```
cd ~/.claude/skills/xxx
git add .
git commit -m "..."
git push
```

重复劳动浪费时间，容易错。用 Skill Publisher，一条命令搞定。

**你专注创作 Skill，发布交给机器。**

## 📝 测试用例

### 测试用例 1: 推送已存在 Skill
**输入**: `推送 my-existing-skill`  
**预期**: 检测到更改，提示选择提交信息，推送成功  
**验证**: GitHub 上能看到新提交

### 测试用例 2: 初始化新 Skill
**输入**: `初始化技能仓库 my-new-skill`  
**预期**: 初始化 Git，创建 GitHub 仓库，首次推送成功  
**验证**: GitHub 上能看到新建的仓库

### 测试用例 3: 检查状态
**输入**: `检查技能`  
**预期**: 输出所有 Skills 状态，标识需要推送的 Skills  
**验证**: 输出完整，状态正确

### 测试用例 4: 批量推送
**输入**: `批量推送 skill1 skill2 skill3`  
**预期**: 依次推送所有 Skill，显示结果统计  
**验证**: 全部推送成功，统计正确

## 📚 参考资料

- [GitHub CLI 官方文档](https://cli.github.com/manual/)
- [Git 官方文档](https://git-scm.com/doc)
- [约定式提交](https://www.conventionalcommits.org/)
- [Claude Code 文档](https://docs.anthropic.com/claude-code/overview)

## 📞 联系方式

- **作者**: 买买 (@mosslive1314-hue)
- **GitHub**: https://github.com/mosslive1314-hue/skill-publisher
- **NPM**: https://www.npmjs.com/package/@mosslive1314-hue/skill-publisher

## 🎯 结语

> **让专业的人做专业的事**
>
> 你专注构思和创作 Skill
>
> 发布、Git 操作、GitHub 管理交给 Skill Publisher

