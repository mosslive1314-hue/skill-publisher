# Skill Publisher 完整指南

## 目录
- [安装配置](#安装配置)
- [使用方法](#使用方法)
- [工作流程](#工作流程)
- [故障排查](#故障排查)
- [最佳实践](#最佳实践)
- [高级用法](#高级用法)

---

## 安装配置

### 前置要求

1. **Git**
   ```bash
   # 检查 Git 是否已安装
   git --version
   ```

2. **GitHub CLI**
   ```bash
   # 检查 GitHub CLI 是否已安装
   gh --version

   # Windows 安装
   winget install --id GitHub.cli

   # macOS 安装
   brew install gh

   # 登录 GitHub
   gh auth login
   ```

### 配置别名

在 `~/.bashrc` (或 `~/.zshrc`) 中添加:

```bash
# Skill Publisher 别名
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
# 或
source ~/.zshrc
```

---

## 使用方法

### 场景 1: 推送已有的 Skill

适用于: 已经初始化过 Git 仓库的 skill

```bash
# 英文命令
push-skill daily-topic-selector

# 中文命令
推送 daily-topic-selector
```

### 场景 2: 首次发布新 Skill

适用于: 刚创建的新 skill,还没有 Git 仓库

```bash
# 一键初始化并发布
初始化技能仓库 my-new-skill

# 等价于以下步骤:
# cd ~/.claude/skills/my-new-skill
# git init
# gh repo create my-new-skill --public --source=. --push
```

### 场景 3: 查看所有 Skills

```bash
# 不带参数运行
推送
# 或
push-skill

# 输出示例:
# 错误: 请提供技能名称
#
# 使用方法: push-skill <skill-name>
#
# 可用的技能:
#   ✓ daily-topic-selector (已初始化 Git)
#   ✓ frontend-design (已初始化 Git)
#     my-new-skill
```

---

## 工作流程

### 完整的发布流程

```
┌─────────────────┐
│ 1. 创建/修改 Skill │
└────────┬────────┘
         ↓
┌─────────────────┐
│ 2. 初始化 Git 仓库│
│ (init-skill-repo)│
└────────┬────────┘
         ↓
┌─────────────────┐
│ 3. 修改内容      │
└────────┬────────┘
         ↓
┌─────────────────┐
│ 4. 推送到 GitHub │
│ (push-skill)    │
└────────┬────────┘
         ↓
┌─────────────────┐
│ 5. 重复 3-4     │
└─────────────────┘
```

### 提交信息选择

每次推送时会询问提交信息:

```
请选择提交信息:
  1) 自动生成 (v2.12.0 - 2026-01-23 10:30:00)
  2) 自定义
选择 [1/2]:
```

**建议:**
- 小改动: 选择 `1` 自动生成
- 重要更新: 选择 `2` 自定义,使用约定式提交格式

---

## 故障排查

### 问题 1: "未找到远程仓库"

**错误信息:**
```
⚠️  未找到远程仓库
```

**原因:** Git 仓库已初始化,但没有配置 GitHub 远程仓库

**解决方案:**

方法 1 - 使用 GitHub CLI (推荐):
```bash
cd ~/.claude/skills/your-skill
gh repo create your-skill --public --source=. --push
```

方法 2 - 手动添加:
```bash
cd ~/.claude/skills/your-skill
git remote add origin https://github.com/<username>/your-skill.git
git push -u origin main
```

### 问题 2: "Permission denied"

**错误信息:**
```
Username for 'https://github.com': <username>
Password for 'https://<username>@github.com':
remote: Support for password authentication was removed on August 13, 2021.
```

**原因:** GitHub 不再支持密码认证,需要使用 Personal Access Token 或 GitHub CLI

**解决方案:**

1. 使用 GitHub CLI (推荐):
```bash
gh auth login
# 选择 GitHub.com
# 选择 HTTPS
# 选择 Login with a web browser
```

2. 或使用 Personal Access Token:
   - 访问 https://github.com/settings/tokens
   - 生成新 token (选择 `repo` 权限)
   - 推送时使用 token 作为密码

### 问题 3: "没有新更改"

**错误信息:**
```
✓ 没有新更改，无需提交
```

**原因:** 所有文件已是最新状态,没有修改

**验证:**
```bash
cd ~/.claude/skills/your-skill
git status
```

如果确实有修改但没被识别:
```bash
git add -A
git commit -m "manual commit"
git push
```

### 问题 4: "未找到 GitHub CLI"

**错误信息:**
```
错误: 未找到 GitHub CLI (gh)
```

**解决方案:**

Windows:
```bash
winget install --id GitHub.cli
```

macOS:
```bash
brew install gh
```

Linux:
```bash
# Ubuntu/Debian
sudo apt install gh

# CentOS/RHEL
sudo dnf install gh
```

### 问题 5: 推送后 GitHub 网页看不到更改

**原因:**
1. 浏览器缓存问题 - 刷新页面 (Ctrl+F5)
2. 推送到了错误的分支 - 检查 `git branch -a`
3. 推送到了错误的仓库 - 检查 `git remote -v`

**解决方案:**
```bash
cd ~/.claude/skills/your-skill

# 检查远程仓库
git remote -v

# 检查分支
git branch -a

# 检查最新提交
git log --oneline -3
```

---

## 最佳实践

### 1. 提交信息规范

使用约定式提交 (Conventional Commits):

```bash
# 新功能
feat: 新增 GitHub Actions 自动部署

# Bug 修复
fix: 修复推送时的编码问题

# 文档更新
docs: 更新 README 使用说明

# 性能优化
perf: 优化 Git 推送速度

# 重构
refactor: 重构初始化流程

# 测试
test: 添加单元测试

# 构建/工具
chore: 更新依赖版本
```

### 2. 版本管理

在 skill 目录中创建 `VERSION` 文件:

```bash
echo "1.0.0" > ~/.claude/skills/your-skill/VERSION
```

推送时会自动读取版本号生成提交信息。

### 3. .gitignore 最佳实践

确保不要推送:
- ❌ 运行时数据 (`data/`, `logs/`)
- ❌ 临时文件 (`*.swp`, `.DS_Store`)
- ❌ 敏感信息 (`.env`, API keys)
- ❌ IDE 配置 (`.vscode/`, `.idea/`)

应该推送:
- ✅ 代码和脚本
- ✅ 文档 (SKILL.md, README.md)
- ✅ 配置文件 (不含敏感信息)
- ✅ 测试文件

### 4. 分支管理

推荐使用 `main` 作为主分支:

```bash
# 设置 main 为默认分支
git branch -M main

# 推送 main 分支
git push -u origin main
```

### 5. 批量操作

当修改多个 skills 时,使用批量脚本:

```bash
#!/bin/bash
# batch-push.sh

for skill in daily-topic-selector frontend-design pdf; do
    echo "推送 $skill..."
    push-skill $skill
    echo "---"
done
```

### 6. 定期维护

定期检查 skills 的 Git 状态:

```bash
#!/bin/bash
# check-all-skills.sh

for dir in ~/.claude/skills/*/; do
    skill=$(basename "$dir")
    echo "=== $skill ==="

    if [ -d "$dir/.git" ]; then
        cd "$dir"
        echo "分支: $(git branch --show-current)"
        echo "状态:"
        git status -sb
        echo "远程:"
        git remote -v
    else
        echo "未初始化 Git"
    fi

    echo ""
done
```

---

## 高级用法

### 1. 自动创建 GitHub Releases

创建一个脚本来自动发布版本:

```bash
#!/bin/bash
# release-skill.sh

SKILL_NAME=$1
VERSION=$2

if [ -z "$VERSION" ]; then
    echo "使用方法: release-skill <skill-name> <version>"
    exit 1
fi

# 推送更改
push-skill $SKILL_NAME

# 创建 GitHub Release
cd ~/.claude/skills/$SKILL_NAME
gh release create "$VERSION" \
  --title "Version $VERSION" \
  --notes "Release notes for version $VERSION"
```

### 2. 自动更新 CHANGELOG

在推送前自动生成更新日志:

```bash
#!/bin/bash
# update-changelog.sh

CHANGELOG_FILE="CHANGELOG.md"
VERSION=$(cat VERSION 2>/dev/null || echo "unknown")
TIMESTAMP=$(date '+%Y-%m-%d')

if [ ! -f "$CHANGELOG_FILE" ]; then
    touch "$CHANGELOG_FILE"
fi

# 在文件开头添加新版本
cat > "$CHANGELOG_FILE.tmp" << EOF
# Changelog

## [$VERSION] - $TIMESTAMP

### Added
- 新功能 1
- 新功能 2

### Fixed
- 修复的问题

### Changed
- 变更的内容

$(cat "$CHANGELOG_FILE")

EOF

mv "$CHANGELOG_FILE.tmp" "$CHANGELOG_FILE"
```

### 3. 与 GitHub Actions 集成

在 skill 仓库中创建 `.github/workflows/test.yml`:

```yaml
name: Test Skill

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Validate SKILL.md
        run: |
          if [ ! -f "SKILL.md" ]; then
            echo "Error: SKILL.md not found"
            exit 1
          fi
      - name: Check metadata
        run: |
          grep -q "^name:" SKILL.md
          grep -q "^description:" SKILL.md
```

### 4. 自动备份

定期备份所有 skills 到私有仓库:

```bash
#!/bin/bash
# backup-all-skills.sh

BACKUP_DIR="$HOME/skills-backup-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

# 复制所有 skills
cp -r ~/.claude/skills/* "$BACKUP_DIR/"

# 创建备份仓库
cd "$BACKUP_DIR"
git init
git add -A
git commit -m "Backup $(date '+%Y-%m-%d %H:%M:%S')"
gh repo create skills-backup --private --source=. --push
```

---

## 相关资源

- **GitHub CLI 文档**: https://cli.github.com/manual/
- **Git 官方文档**: https://git-scm.com/doc
- **约定式提交**: https://www.conventionalcommits.org/
- **语义化版本**: https://semver.org/lang/zh-CN/
- **GitHub Personal Access Tokens**: https://github.com/settings/tokens
