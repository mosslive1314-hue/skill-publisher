# Skill Publisher 部署指南

本文档指导你在不同设备上安装和配置 Skill Publisher。

---

## 目录

- [前置要求](#前置要求)
- [安装步骤](#安装步骤)
- [配置别名](#配置别名)
- [验证安装](#验证安装)
- [升级方法](#升级方法)
- [卸载方法](#卸载方法)
- [多设备同步](#多设备同步)
- [故障排查](#故障排查)

---

## 前置要求

### 必需软件

1. **Git** (版本 2.0+)
   ```bash
   # 检查是否已安装
   git --version

   # Windows
   winget install Git.Git

   # macOS
   brew install git

   # Linux (Ubuntu/Debian)
   sudo apt install git
   ```

2. **GitHub CLI** (版本 2.0+)
   ```bash
   # 检查是否已安装
   gh --version

   # Windows
   winget install --id GitHub.cli

   # macOS
   brew install gh

   # Linux (Ubuntu/Debian)
   sudo apt install gh

   # 登录 GitHub
   gh auth login
   ```

3. **Bash** (或兼容的 Shell)
   - Windows: Git Bash, WSL
   - macOS: Terminal, iTerm2
   - Linux: 任何终端

### 可选软件

- **Python** (某些 skills 可能需要)
- **Node.js** (某些 skills 可能需要)

---

## 安装步骤

### 方法 1: 从 GitHub 克隆 (推荐)

```bash
# 1. 进入 skills 目录
cd ~/.claude/skills

# 2. 克隆仓库
git clone https://github.com/mosslive1314-hue/skill-publisher.git

# 3. 验证安装
ls -la skill-publisher/
```

### 方法 2: 手动下载

```bash
# 1. 访问 https://github.com/mosslive1314-hue/skill-publisher/releases
# 2. 下载最新版本的 skill-publisher.zip
# 3. 解压到 ~/.claude/skills/skill-publisher/

# Windows (PowerShell)
Expand-Archive -Path skill-publisher.zip -DestinationPath ~/.claude/skills/

# macOS/Linux
unzip skill-publisher.zip -d ~/.claude/skills/
```

### 方法 3: 使用 Skill Manager

如果你安装了 skill-manager:

```bash
# 搜索 skill-publisher
skill-manager search skill-publisher

# 安装
skill-manager install skill-publisher
```

---

## 配置别名

### Bash (Linux/macOS/Git Bash)

编辑 `~/.bashrc`:

```bash
# Skill Publisher 别名
cat >> ~/.bashrc << 'EOF'

# Skill Publisher
alias push-skill='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias init-skill-repo='bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh'
alias check-skills='bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh'
alias batch-push='bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh'

# 中文别名
alias 推送='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 推送技能='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 初始化技能仓库='bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh'
alias 检查技能='bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh'
alias 批量推送='bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh'
EOF

# 重新加载配置
source ~/.bashrc
```

### Zsh (macOS 默认)

编辑 `~/.zshrc`:

```bash
# 添加与 Bash 相同的别名到 ~/.zshrc
# 然后重新加载
source ~/.zshrc
```

### Windows PowerShell

创建 PowerShell 配置文件:

```powershell
# 检查配置文件是否存在
Test-Path $PROFILE

# 如果不存在,创建
New-Item -Path $PROFILE -Type File -Force

# 编辑配置文件
notepad $PROFILE
```

添加以下内容:

```powershell
# Skill Publisher Functions
function Push-Skill {
    param([string]$SkillName)
    bash "~\.claude\skills\skill-publisher\scripts\push-skill.sh $SkillName"
}

function Init-SkillRepo {
    param([string]$SkillName)
    bash "~\.claude\skills\skill-publisher\scripts\init-skill-repo.sh $SkillName"
}

function Check-Skills {
    bash "~\.claude\skills\skill-publisher\scripts\check-skills.sh"
}

function Batch-Push {
    bash "~\.claude\skills\skill-publisher\scripts\batch-push.sh"
}

# 别名
Set-Alias -Name 推送 -Value Push-Skill
Set-Alias -Name 初始化技能仓库 -Value Init-SkillRepo
Set-Alias -Name 检查技能 -Value Check-Skills
Set-Alias -Name 批量推送 -Value Batch-Push
```

重新加载配置:

```powershell
. $PROFILE
```

---

## 验证安装

### 1. 检查文件结构

```bash
ls -la ~/.claude/skills/skill-publisher/

# 应该看到:
# SKILL.md
# README.md
# scripts/
# references/
```

### 2. 检查脚本权限

```bash
ls -la ~/.claude/skills/skill-publisher/scripts/

# 所有 .sh 文件应该有可执行权限 (-rwxr-xr-x)

# 如果没有,手动添加:
chmod +x ~/.claude/skills/skill-publisher/scripts/*.sh
```

### 3. 测试别名

```bash
# 测试英文别名
push-skill

# 应该显示错误信息和可用 skills 列表

# 测试中文别名
推送

# 应该显示相同的输出

# 测试状态检查
检查技能

# 应该显示所有 skills 的状态
```

### 4. 测试脚本

```bash
# 测试推送脚本 (不带参数)
bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh

# 测试状态检查脚本
bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh

# 应该显示所有 skills 的状态
```

---

## 升级方法

### 从 GitHub 拉取更新

```bash
cd ~/.claude/skills/skill-publisher
git pull origin main
```

### 查看当前版本

```bash
cd ~/.claude/skills/skill-publisher
cat VERSION

# 或查看 Git 标签
git tag
```

### 切换到特定版本

```bash
cd ~/.claude/skills/skill-publisher
git tag  # 查看可用版本
git checkout v1.0.0  # 切换到指定版本
```

### 回退到之前版本

```bash
cd ~/.claude/skills/skill-publisher
git log --oneline -10  # 查看历史
git checkout <commit-hash>  # 回退到指定提交
```

---

## 卸载方法

### 1. 移除别名

编辑 `~/.bashrc` 或 `~/.zshrc`,删除 Skill Publisher 相关的别名:

```bash
# 编辑配置文件
vim ~/.bashrc

# 删除这些行:
# alias push-skill='...'
# alias 推送='...'
# 等...

# 重新加载
source ~/.bashrc
```

### 2. 删除文件

```bash
# 删除 skill-publisher 目录
rm -rf ~/.claude/skills/skill-publisher

# 或保留备份
mv ~/.claude/skills/skill-publisher ~/skill-publisher.backup
```

### 3. 清理 Git 配置 (可选)

```bash
# 如果不再使用任何 skills,清理全局 Git 配置
git config --global --unset user.name
git config --global --unset user.email
```

---

## 多设备同步

### 场景 1: 主设备 → 新设备

**在主设备上:**

```bash
# 1. 发布所有 skills
检查技能
批量推送
```

**在新设备上:**

```bash
# 1. 安装前置要求
# Git, GitHub CLI, Bash

# 2. 安装 Skill Publisher
cd ~/.claude/skills
git clone https://github.com/mosslive1314-hue/skill-publisher.git

# 3. 配置别名 (参考上面"配置别名"部分)

# 4. 克隆所有 skills
cat > ~/clone-all-skills.sh << 'EOF'
#!/bin/bash
cd ~/.claude/skills

# 从 GitHub 获取你的所有仓库
gh repo list --limit 1000 | grep 'skill' | while read repo; do
    name=$(echo $repo | awk '{print $1}')
    if [ ! -d "$name" ]; then
        echo "克隆 $name..."
        git clone https://github.com/username/$name.git
    fi
done
EOF

chmod +x ~/clone-all-skills.sh
~/clone-all-skills.sh
```

### 场景 2: 定期同步

**创建同步脚本:**

```bash
cat > ~/sync-skills.sh << 'EOF'
#!/bin/bash

for dir in ~/.claude/skills/*/; do
    if [ -d "$dir/.git" ]; then
        skill=$(basename "$dir")
        echo "同步 $skill..."

        cd "$dir"

        # 拉取最新更改
        git pull

        # 如果有本地更改,推送
        if ! git diff --quiet || ! git diff --cached --quiet; then
            echo "  发现本地更改,推送..."
            推送 $skill
        fi
    fi
done

echo "同步完成!"
EOF

chmod +x ~/sync-skills.sh
```

**设置定时任务:**

Linux/macOS (crontab):
```bash
# 编辑 crontab
crontab -e

# 每天早上 9 点同步
0 9 * * * ~/sync-skills.sh >> ~/sync-skills.log 2>&1
```

Windows (任务计划):
```powershell
# 创建 PowerShell 脚本 sync-skills.ps1
# 内容与上面的 bash 脚本类似

# 使用任务计划程序设置每天运行
# 或使用 PowerShell Register-ScheduledTask
```

---

## 故障排查

### 问题 1: 命令找不到

```bash
# 症状: bash: push-skill: command not found

# 诊断:
which push-skill
alias | grep push-skill

# 解决:
source ~/.bashrc
# 或检查 shell 类型
echo $SHELL
# 如果是 zsh,编辑 ~/.zshrc 而不是 ~/.bashrc
```

### 问题 2: 脚本无法执行

```bash
# 症状: Permission denied

# 诊断:
ls -la ~/.claude/skills/skill-publisher/scripts/*.sh

# 解决:
chmod +x ~/.claude/skills/skill-publisher/scripts/*.sh
```

### 问题 3: GitHub CLI 未登录

```bash
# 症状: not logged in

# 解决:
gh auth login
# 按提示选择:
# - GitHub.com
# - HTTPS
# - Login with a browser
```

### 问题 4: 路径问题

```bash
# Windows 路径可能是 /c/Users/... 而不是 ~/...

# 诊断:
pwd
echo $HOME

# 解决: 在脚本中使用 $HOME 而不是 ~
# 或在 ~/.bashrc 中设置:
export HOME="/c/Users/$(whoami)"
```

### 问题 5: 编码问题 (中文显示乱码)

```bash
# Windows Git Bash:

# 在 ~/.bashrc 中添加:
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 重新加载:
source ~/.bashrc
```

---

## 快速安装检查清单

完成安装后,确认以下项目:

- [ ] Git 已安装 (`git --version`)
- [ ] GitHub CLI 已安装 (`gh --version`)
- [ ] GitHub CLI 已登录 (`gh auth status`)
- [ ] skill-publisher 目录存在 (`ls ~/.claude/skills/skill-publisher`)
- [ ] 脚本有执行权限 (`ls -la ~/.claude/skills/skill-publisher/scripts/`)
- [ ] 别名已配置 (`alias | grep 推送`)
- [ ] 别名可用 (`推送` 应该显示错误信息)
- [ ] 状态检查可用 (`检查技能` 应该显示所有 skills)

---

## 下一步

安装完成后:

1. **阅读文档**:
   - `README.md` - 快速开始
   - `references/GUIDE.md` - 完整指南
   - `references/EXAMPLES.md` - 使用案例
   - `references/FAQ.md` - 常见问题

2. **测试功能**:
   ```bash
   # 检查所有 skills 状态
   检查技能

   # 推送一个 skill
   推送 skill-publisher
   ```

3. **开始使用**:
   ```bash
   # 初始化新 skill
   初始化技能仓库 my-new-skill

   # 日常推送
   推送 my-skill
   ```

---

**需要帮助?**
- GitHub Issues: https://github.com/mosslive1314-hue/skill-publisher/issues
- 完整文档: `references/GUIDE.md`

**最后更新**: 2026-01-23
**版本**: v1.0.0
