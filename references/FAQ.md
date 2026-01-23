# Skill Publisher 常见问题 (FAQ)

本文档收集了用户最常遇到的问题和解决方案。

---

## 安装和配置

### Q1: 如何安装 Skill Publisher?

**A:**
```bash
# 方式 1: 从 GitHub 克隆
cd ~/.claude/skills
git clone https://github.com/yourname/skill-publisher.git

# 方式 2: 直接下载
# 访问 https://github.com/yourname/skill-publisher/releases
# 下载最新版本的 .zip 文件并解压到 ~/.claude/skills/
```

### Q2: 如何配置别名?

**A:**
```bash
# 编辑 ~/.bashrc
cat >> ~/.bashrc << 'EOF'

# Skill Publisher 别名
alias 推送='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 推送技能='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 初始化技能仓库='bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh'
alias 检查技能='bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh'
alias 批量推送='bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh'
EOF

# 重新加载配置
source ~/.bashrc
```

### Q3: 别名不生效怎么办?

**A:**
```bash
# 1. 确认配置已添加
cat ~/.bashrc | grep 推送

# 2. 重新加载配置
source ~/.bashrc

# 3. 如果还是不行,检查 shell 类型
echo $SHELL

# 如果是 zsh,需要编辑 ~/.zshrc 而不是 ~/.bashrc
```

---

## Git 和 GitHub

### Q4: 推送时提示 "Permission denied"

**A:**
```bash
# 原因 1: GitHub 身份验证过期
# 解决: 重新登录 GitHub CLI
gh auth login

# 原因 2: 没有仓库权限
# 解决: 检查仓库是否属于你
gh repo view

# 原因 3: 使用了错误的 URL
# 解决: 检查远程仓库 URL
cd ~/.claude/skills/skill-name
git remote -v

# 如果是 SSH URL,改为 HTTPS:
git remote set-url origin https://github.com/username/skill-name.git
```

### Q5: 提示 "未找到远程仓库"

**A:**
```bash
# 原因: Git 仓库已初始化但没有配置 GitHub 远程仓库

# 解决 1: 使用 GitHub CLI 创建 (推荐)
初始化技能仓库 skill-name

# 解决 2: 手动创建并配置
# 1. 访问 https://github.com/new 创建仓库
# 2. 配置远程仓库
cd ~/.claude/skills/skill-name
git remote add origin https://github.com/username/skill-name.git
git push -u origin main
```

### Q6: 推送后 GitHub 网页看不到更新

**A:**
```bash
# 原因 1: 浏览器缓存
# 解决: 强制刷新页面 (Ctrl+F5 或 Cmd+Shift+R)

# 原因 2: 推送到了错误的分支
# 解决: 检查分支
cd ~/.claude/skills/skill-name
git branch -a
git log --oneline -3

# 原因 3: 推送到了错误的仓库
# 解决: 检查远程仓库
git remote -v
```

### Q7: 如何删除远程仓库?

**A:**
```bash
# 方式 1: 使用 GitHub CLI
gh repo delete username/skill-name

# 方式 2: 网页操作
# 1. 访问 https://github.com/username/skill-name/settings
# 2. 滚动到 "Danger Zone"
# 3. 点击 "Delete this repository"
```

---

## 推送相关

### Q8: 提示 "没有新更改"

**A:**
```bash
# 原因: 所有文件已是最新状态,没有修改

# 验证: 检查 Git 状态
cd ~/.claude/skills/skill-name
git status

# 如果确实有修改但没被识别:
git add -A
git status

# 检查 .gitignore 是否忽略了文件
cat .gitignore
```

### Q9: 如何推送多个 skills?

**A:**
```bash
# 方式 1: 批量推送所有已初始化的 skills
批量推送

# 方式 2: 批量推送指定的 skills
批量推送 skill1 skill2 skill3

# 方式 3: 使用脚本
bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh skill1 skill2
```

### Q10: 如何回退到之前的版本?

**A:**
```bash
# 1. 查看提交历史
cd ~/.claude/skills/skill-name
git log --oneline -10

# 2. 回退到指定版本
git reset --hard <commit-hash>

# 3. 强制推送 (谨慎使用!)
git push --force

# 或者创建新提交回退
git revert HEAD
git push
```

### Q11: 提交信息选错了怎么办?

**A:**
```bash
# 1. 修改最后一次提交信息
git commit --amend -m "新的提交信息"

# 2. 如果已推送,需要强制推送
git push --force

# 注意: 如果别人已经拉取了你的代码,不要使用 --force
```

---

## 文件和目录

### Q12: .gitignore 不生效?

**A:**
```bash
# 原因: 文件已经被 Git 追踪

# 解决: 清除缓存
cd ~/.claude/skills/skill-name
git rm -r --cached .
git add .
git commit -m "fix: .gitignore 生效"
git push
```

### Q13: 应该提交哪些文件?

**A:**
```bash
# ✅ 应该提交:
- SKILL.md (必需)
- scripts/ (脚本文件)
- references/ (参考文档)
- assets/ (资源文件)
- VERSION (版本号)
- README.md (说明文档)
- metadata.json (元数据)

# ❌ 不应该提交:
- data/ (运行时数据)
- logs/ (日志文件)
- __pycache__/ (Python 缓存)
- *.pyc (Python 字节码)
- .env (环境变量,可能包含敏感信息)
- .DS_Store (macOS 系统文件)
- *.swp (vim 临时文件)
```

### Q14: 如何忽略已提交的文件?

**A:**
```bash
# 1. 添加到 .gitignore
echo "data/" >> .gitignore

# 2. 从 Git 仓库中删除
git rm -r --cached data/

# 3. 提交更改
git commit -m "chore: 停止追踪 data 目录"
git push
```

---

## 脚本问题

### Q15: 脚本没有输出任何内容

**A:**
```bash
# 原因: 可能是颜色代码问题或脚本错误

# 解决 1: 使用调试模式运行
bash -x ~/.claude/skills/skill-publisher/scripts/push-skill.sh skill-name

# 解决 2: 检查脚本语法
bash -n ~/.claude/skills/skill-publisher/scripts/push-skill.sh

# 解决 3: 查看错误输出
bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh skill-name 2>&1 | tee error.log
```

### Q16: 脚本提示 "command not found"

**A:**
```bash
# 原因: 缺少必要的命令

# 检查 Git
git --version

# 检查 GitHub CLI
gh --version

# 如果没有安装,请先安装:
# Windows: winget install --id GitHub.cli
# macOS: brew install gh
# Linux: apt install gh (或其他包管理器)
```

### Q17: 如何禁用彩色输出?

**A:**
```bash
# 编辑脚本,注释掉颜色定义
# 或者使用环境变量
NO_COLOR=1 bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh skill-name
```

---

## 性能和优化

### Q18: 推送太慢怎么办?

**A:**
```bash
# 原因 1: 历史记录过大
# 解决: 浅克隆
git clone --depth 1 https://github.com/username/skill-name.git

# 原因 2: 网络问题
# 解决: 使用代理或 SSH
git remote set-url origin git@github.com:username/skill-name.git

# 原因 3: 文件过大
# 解决: 使用 Git LFS
git lfs install
git lfs track "*.psd"
git add .gitattributes
```

### Q19: 如何减少仓库大小?

**A:**
```bash
# 1. 清理 Git 历史
git gc --prune=now --aggressive

# 2. 移除大文件
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch large-file.zip" \
  --prune-empty --tag-name-filter cat -- --all

# 3. 使用 BFG Repo-Cleaner (推荐)
# 下载: https://rtyley.github.io/bfg-repo-cleaner/
bfg --strip-blobs-bigger-than 100M
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

---

## 错误处理

### Q20: 推送失败后如何重试?

**A:**
```bash
# 1. 查看失败原因
cd ~/.claude/skills/skill-name
git status

# 2. 解决冲突 (如果有)
git pull --rebase
git push

# 3. 或强制推送 (谨慎使用)
git push --force

# 4. 重新使用脚本
推送 skill-name
```

### Q21: 如何查看错误日志?

**A:**
```bash
# 方式 1: 使用调试模式
bash -x ~/.claude/skills/skill-publisher/scripts/push-skill.sh skill-name 2>&1 | tee push.log

# 方式 2: 查看 Git 日志
cd ~/.claude/skills/skill-name
git reflog

# 方式 3: 查看 GitHub Actions 日志 (如果配置了)
gh run list
gh run view <run-id>
```

---

## 高级问题

### Q22: 如何设置自动部署?

**A:**
```bash
# 创建 GitHub Actions 工作流
mkdir -p .github/workflows
cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy
        run: |
          echo "Deploying skill..."
          # 添加部署步骤
EOF

git add .github/workflows/deploy.yml
git commit -m "ci: add GitHub Actions"
git push
```

### Q23: 如何创建 Release?

**A:**
```bash
# 方式 1: 使用 GitHub CLI
gh release create v1.0.0 \
  --title "Version 1.0.0" \
  --notes "Release notes here"

# 方式 2: 网页操作
# 访问 https://github.com/username/skill-name/releases/new

# 方式 3: 使用脚本
cat > ~/release-skill.sh << 'EOF'
#!/bin/bash
SKILL=$1
VERSION=$2
cd ~/.claude/skills/$SKILL
gh release create "$VERSION" --title "$VERSION" --notes "Release $VERSION"
EOF
chmod +x ~/release-skill.sh
```

### Q24: 如何贡献到其他人的 skill?

**A:**
```bash
# 1. Fork 仓库
gh repo fork username/skill-name

# 2. 克隆你的 fork
git clone https://github.com/yourname/skill-name.git ~/.claude/skills/skill-name

# 3. 创建功能分支
cd ~/.claude/skills/skill-name
git checkout -b feature/new-function

# 4. 修改并推送
# ... 修改文件 ...
推送 skill-name

# 5. 创建 Pull Request
gh pr create --title "Add new function" --body "Description"
```

---

## 获取帮助

### 还是没有解决问题?

1. **查看完整文档**: `references/GUIDE.md`
2. **查看使用案例**: `references/EXAMPLES.md`
3. **查看脚本源码**: `scripts/`
4. **提交 Issue**: https://github.com/yourname/skill-publisher/issues
5. **查看 GitHub CLI 文档**: https://cli.github.com/manual/
6. **查看 Git 文档**: https://git-scm.com/doc

---

## 快速诊断清单

遇到问题时,按顺序检查:

- [ ] Git 是否已安装? `git --version`
- [ ] GitHub CLI 是否已安装? `gh --version`
- [ ] 是否已登录 GitHub? `gh auth status`
- [ ] 别名是否配置正确? `alias | grep 推送`
- [ ] 技能目录是否存在? `ls ~/.claude/skills/`
- [ ] Git 仓库是否已初始化? `cd ~/.claude/skills/skill-name && git status`
- [ ] 远程仓库是否配置? `git remote -v`
- [ ] 网络连接是否正常? `ping github.com`
- [ ] 是否有推送权限? `gh repo view`

---

**最后更新**: 2026-01-23
**版本**: v1.0.0
