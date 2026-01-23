# Skill Publisher 实际使用案例

本文档包含真实的使用案例和场景,帮助你更好地使用 Skill Publisher。

## 案例 1: 日常开发工作流

### 场景
你开发了一个新的 skill,需要持续迭代和发布。

### 步骤

**1. 创建新 skill**
```bash
mkdir -p ~/.claude/skills/my-awesome-skill
cd ~/.claude/skills/my-awesome-skill

# 创建基本文件
cat > SKILL.md << 'EOF'
---
name: my-awesome-skill
description: 我的超棒技能,用于演示 Skill Publisher 的使用
license: MIT
---

# My Awesome Skill

这是一个超棒的 skill!
EOF

# 初始化并发布
初始化技能仓库 my-awesome-skill
```

**输出:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔧 初始化技能: my-awesome-skill
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📦 正在初始化 Git 仓库...
✓ Git 仓库已初始化

📝 创建 .gitignore...
✓ .gitignore 已创建

📦 添加文件到 Git...
💾 创建首次提交...
✓ 首次提交已完成

🌿 设置主分支为 main...
✓ 主分支已设置

☁️  在 GitHub 创建仓库...
仓库名称: my-awesome-skill
可见性: Public

输入仓库描述 (可选，直接回车跳过): 我的超棒技能

✅ 技能已成功发布到 GitHub!
📍 仓库地址: https://github.com/username/my-awesome-skill

🎉 下次修改后，只需运行:
  推送 my-awesome-skill
```

**2. 日常修改和推送**
```bash
# 修改 skill 文件
vim ~/.claude/skills/my-awesome-skill/SKILL.md

# 推送更新
推送 my-awesome-skill
```

**输出:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📤 推送技能: my-awesome-skill
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 当前状态:
## main...origin/main
 M SKILL.md

📝 添加更改...

请选择提交信息:
  1) 自动生成 (v1.0.0 - 2026-01-23 18:00:00)
  2) 自定义
选择 [1/2]: 2
输入提交信息: docs: 添加详细的使用说明

✓ 提交成功

🚀 推送到 GitHub...
✓ 推送成功!

📍 仓库地址: https://github.com/username/my-awesome-skill.git
🌐 在浏览器中打开...
```

**3. 批量更新多个 skills**
```bash
# 修改了多个 skills
vim ~/.claude/skills/skill-a/SKILL.md
vim ~/.claude/skills/skill-b/SKILL.md

# 批量推送
bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh skill-a skill-b
```

---

## 案例 2: 从零开始迁移现有 Skills

### 场景
你有一些 skills 还没有初始化 Git,想要批量管理和发布。

### 步骤

**1. 检查当前状态**
```bash
bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh
```

**输出:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 Skills 状态检查
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

━━━ daily-topic-selector ━━━
⚠️  未初始化 Git
  → 运行: 初始化技能仓库 daily-topic-selector

━━━ frontend-design ━━━
✓ 干净
  分支: main
  远程: username/frontend-design

━━━ pdf ━━━
📝 有未提交的更改
  分支: main
  更改文件: 3
  → 运行: 推送 pdf

━━━ my-new-skill ━━━
⚠️  未初始化 Git
  → 运行: 初始化技能仓库 my-new-skill

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 总结
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

总计:       4 个 skills
已初始化:   2 个
未初始化:   2 个
干净:       1 个
需要推送:   1 个

💡 提示: 使用以下命令初始化未配置的 skills:

  初始化技能仓库 daily-topic-selector
  初始化技能仓库 my-new-skill

💡 提示: 使用以下命令推送需要更新的 skills:

  单个推送: 推送 <skill-name>
  批量推送: bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh
```

**2. 批量初始化未配置的 skills**
```bash
初始化技能仓库 daily-topic-selector
初始化技能仓库 my-new-skill
```

**3. 推送所有需要更新的 skills**
```bash
# 方式 1: 推送所有已初始化的 skills
bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh

# 方式 2: 只推送指定的 skills
bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh pdf daily-topic-selector
```

---

## 案例 3: 版本发布流程

### 场景
你的 skill 有重大更新,需要发布新版本。

### 步骤

**1. 更新版本号**
```bash
cd ~/.claude/skills/my-awesome-skill
echo "1.1.0" > VERSION
```

**2. 更新 SKILL.md,添加版本说明**
```bash
vim SKILL.md

# 在文件顶部添加:
# ## 版本历史
# ### v1.1.0 (2026-01-23)
# - 新增: XXX 功能
# - 修复: XXX 问题
# - 优化: XXX 改进
```

**3. 推送新版本**
```bash
cd ~/.claude/skills/my-awesome-skill

# 添加并提交
git add VERSION SKILL.md
git commit -m "chore: release v1.1.0

- 新增: XXX 功能
- 修复: XXX 问题
- 优化: XXX 改进"

# 推送
git push

# 或使用推送命令
推送 my-awesome-skill
# 选择自定义提交信息: "chore: release v1.1.0"
```

**4. 创建 GitHub Release (可选)**
```bash
cd ~/.claude/skills/my-awesome-skill
gh release create v1.1.0 \
  --title "Version 1.1.0" \
  --notes "## 新功能
- XXX 功能

## Bug 修复
- XXX 问题

## 改进
- XXX 优化"
```

---

## 案例 4: 多设备同步

### 场景
你在多台电脑上使用 Claude Code,需要同步 skills。

### 步骤

**电脑 A (主开发机)**

**1. 发布所有 skills**
```bash
# 检查状态
bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh

# 批量推送所有
bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh
```

**电脑 B (新设备)**

**2. 安装 Skill Publisher**
```bash
# 克隆 skill-publisher
mkdir -p ~/.claude/skills
cd ~/.claude/skills
git clone https://github.com/yourname/skill-publisher.git

# 配置别名
cat >> ~/.bashrc << 'EOF'

# Skill Publisher
alias 推送='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 推送技能='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 初始化技能仓库='bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh'
alias 检查技能='bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh'
EOF

source ~/.bashrc
```

**3. 克隆所有 skills**
```bash
# 创建克隆脚本
cat > ~/clone-skills.sh << 'EOF'
#!/bin/bash
SKILLS="daily-topic-selector frontend-design pdf skill-publisher"

for skill in $SKILLS; do
    echo "克隆 $skill..."
    cd ~/.claude/skills
    if [ ! -d "$skill" ]; then
        git clone https://github.com/yourname/$skill.git
    else
        echo "  已存在,跳过"
    fi
done
EOF

chmod +x ~/clone-skills.sh
~/clone-skills.sh
```

**4. 设置定期同步**
```bash
# 添加到 crontab (Linux/macOS) 或任务计划 (Windows)
# 每天自动拉取更新

cat > ~/sync-skills.sh << 'EOF'
#!/bin/bash
for dir in ~/.claude/skills/*/; do
    if [ -d "$dir/.git" ]; then
        echo "同步 $(basename $dir)..."
        cd "$dir"
        git pull
    fi
done
EOF

chmod +x ~/sync-skills.sh
```

---

## 案例 5: 团队协作

### 场景
你和团队成员共同维护一个 skill。

### 步骤

**1. 创建组织仓库**
```bash
# 创建 GitHub 组织仓库
gh repo create my-org/my-shared-skill \
  --public \
  --description="团队共享的 skill" \
  --source=. \
  --push
```

**2. 邀请协作者**
```bash
# 使用 GitHub CLI 或网页界面邀请成员
gh repo edit my-org/my-shared-skill --add-collaborator teammate1
gh repo edit my-org/my-shared-skill --add-collaborator teammate2
```

**3. 团队成员克隆和贡献**
```bash
# 团队成员克隆仓库
git clone https://github.com/my-org/my-shared-skill.git ~/.claude/skills/my-shared-skill

# 创建功能分支
cd ~/.claude/skills/my-shared-skill
git checkout -b feature/new-function

# 修改后推送
推送 my-shared-skill

# 或创建 Pull Request (推荐)
gh pr create --title "新增 XXX 功能" --body "实现了 XXX 功能"
```

---

## 案例 6: 自动化工作流

### 场景
每天自动检查 skills 状态并推送更新。

### 步骤

**1. 创建自动化脚本**
```bash
cat > ~/.claude/daily-sync.sh << 'EOF'
#!/bin/bash
# 每日自动同步脚本

LOG_FILE="$HOME/skills-sync.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] 开始同步" >> "$LOG_FILE"

# 检查状态
bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh >> "$LOG_FILE" 2>&1

# 如果有更改,自动推送
for dir in ~/.claude/skills/*/; do
    if [ -d "$dir/.git" ]; then
        cd "$dir"
        skill=$(basename "$dir")

        # 检查是否有未推送的更改
        if ! git diff --quiet || ! git diff --cached --quiet; then
            echo "[$DATE] 推送 $skill" >> "$LOG_FILE"
            echo "1" | bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh "$skill" >> "$LOG_FILE" 2>&1
        fi
    fi
done

echo "[$DATE] 同步完成" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"
EOF

chmod +x ~/.claude/daily-sync.sh
```

**2. 设置定时任务 (Linux/macOS)**
```bash
# 添加到 crontab
crontab -e

# 每天早上 9 点执行
0 9 * * * ~/.claude/daily-sync.sh
```

**3. Windows 任务计划**
```powershell
# 使用 PowerShell 创建任务计划
$action = New-ScheduledTaskAction -Execute "bash.exe" -Argument "~/.claude/daily-sync.sh"
$trigger = New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -TaskName "Daily Skills Sync" -Action $action -Trigger $trigger
```

---

## 常见使用场景速查

| 场景 | 命令 |
|-----|------|
| 发布新 skill | `初始化技能仓库 <name>` |
| 推送修改 | `推送 <name>` |
| 查看所有状态 | `检查技能` 或 `bash .../check-skills.sh` |
| 批量推送 | `bash .../batch-push.sh` |
| 批量推送指定 | `bash .../batch-push.sh skill1 skill2` |
| 推送所有 | `bash .../batch-push.sh` |

---

## 调试技巧

### 查看详细日志
```bash
# 在脚本中添加调试输出
bash -x ~/.claude/skills/skill-publisher/scripts/push-skill.sh skill-name
```

### 手动执行 Git 命令
```bash
cd ~/.claude/skills/skill-name
git status
git log --oneline -5
git remote -v
```

### 测试脚本
```bash
# 创建测试 skill
mkdir -p /tmp/test-skill
cd /tmp/test-skill
echo "test" > README.md

# 测试初始化
bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh test-skill
```
