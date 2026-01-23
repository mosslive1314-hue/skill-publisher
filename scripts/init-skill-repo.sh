#!/bin/bash
# 初始化 Skill 的 Git 仓库并创建 GitHub 远程仓库
# 使用方法: bash init-skill-repo.sh <skill-name>

set -e

SKILL_NAME=$1
SKILLS_DIR="$HOME/.claude/skills"
SKILL_PATH="$SKILLS_DIR/$SKILL_NAME"

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查参数
if [ -z "$SKILL_NAME" ]; then
    echo -e "${RED}错误: 请提供技能名称${NC}"
    echo ""
    echo "使用方法: init-skill-repo <skill-name>"
    echo ""
    echo "这将:"
    echo "  1. 初始化 Git 仓库"
    echo "  2. 创建 .gitignore 文件"
    echo "  3. 在 GitHub 创建远程仓库"
    echo "  4. 首次提交并推送"
    exit 1
fi

# 检查技能目录是否存在
if [ ! -d "$SKILL_PATH" ]; then
    echo -e "${RED}错误: 技能 '$SKILL_NAME' 不存在${NC}"
    echo "路径: $SKILL_PATH"
    echo ""
    echo "可用的技能:"
    ls -1 "$SKILLS_DIR" 2>/dev/null | grep -v "^\."
    exit 1
fi

cd "$SKILL_PATH"

# 检查 GitHub CLI
if ! command -v gh &>/dev/null; then
    echo -e "${RED}错误: 未找到 GitHub CLI (gh)${NC}"
    echo ""
    echo "请先安装 GitHub CLI:"
    echo "  Windows:  winget install --id GitHub.cli"
    echo "  macOS:    brew install gh"
    echo "  Linux:    apt install gh (或对应的包管理器)"
    echo ""
    echo "安装后请运行: gh auth login"
    exit 1
fi

# 检查是否已登录 GitHub
if ! gh auth status &>/dev/null; then
    echo -e "${RED}错误: 未登录 GitHub${NC}"
    echo ""
    echo "请先登录: gh auth login"
    exit 1
fi

# 获取 GitHub 用户名
GITHUB_USERNAME=$(gh api user --jq '.login' 2>/dev/null)

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔧 初始化技能: ${SKILL_NAME}${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 检查是否已初始化 Git
if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Git 仓库已存在${NC}"
    echo -n "是否重新初始化? [y/N]: "
    read -n 1 REINIT
    echo ""

    if [ "$REINIT" != "y" ] && [ "$REINIT" != "Y" ]; then
        echo "跳过 Git 初始化"
    else
        rm -rf .git
        echo -e "${BLUE}📦 正在初始化 Git 仓库...${NC}"
        git init -q
        echo -e "${GREEN}✓ Git 仓库已重新初始化${NC}"
    fi
else
    echo -e "${BLUE}📦 正在初始化 Git 仓库...${NC}"
    git init -q
    echo -e "${GREEN}✓ Git 仓库已初始化${NC}"
fi

# 创建 .gitignore
echo ""
echo -e "${BLUE}📝 创建 .gitignore...${NC}"
cat > .gitignore << 'EOF'
# 运行时数据
data/
logs/
*.log

# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
*.so
*.egg
*.egg-info/
dist/
build/

# 临时文件
.DS_Store
*.swp
*.swo
*~
.env

# Node.js
node_modules/
npm-debug.log
yarn-error.log

# IDE
.vscode/
.idea/
*.iml

# 状态文件（可选）
.circuit_breaker_*
.exit_signals
.call_count
.last_reset
EOF
echo -e "${GREEN}✓ .gitignore 已创建${NC}"

# 检查是否有 SKILL.md
if [ ! -f "SKILL.md" ]; then
    echo ""
    echo -e "${YELLOW}⚠️  警告: 未找到 SKILL.md${NC}"
    echo "Skill 目录应该包含 SKILL.md 文件"
fi

# 添加所有文件
echo ""
echo -e "${BLUE}📦 添加文件到 Git...${NC}"
git add -A

# 检查是否有文件需要提交
if git diff --cached --quiet; then
    echo -e "${YELLOW}⚠️  没有文件需要提交${NC}"
    echo ""
    echo "可能的原因:"
    echo "  - 目录为空"
    echo "  - 所有文件都被 .gitignore 忽略"
    exit 1
fi

# 首次提交
echo ""
echo -e "${BLUE}💾 创建首次提交...${NC}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
git commit -m "Initial commit - ${TIMESTAMP}" -q
echo -e "${GREEN}✓ 首次提交已完成${NC}"

# 设置主分支名称
echo ""
echo -e "${BLUE}🌿 设置主分支为 main...${NC}"
git branch -M main 2>/dev/null || git branch -M master
echo -e "${GREEN}✓ 主分支已设置${NC}"

# 检查远程仓库是否已存在
if git remote get-url origin &>/dev/null; then
    echo ""
    echo -e "${YELLOW}⚠️  远程仓库已存在${NC}"
    REMOTE_URL=$(git remote get-url origin)
    echo "当前远程仓库: $REMOTE_URL"
    echo -n "是否创建新的远程仓库? [y/N]: "
    read -n 1 CREATE_NEW
    echo ""

    if [ "$CREATE_NEW" != "y" ] && [ "$CREATE_NEW" != "Y" ]; then
        echo ""
        echo -e "${BLUE}🚀 推送到现有远程仓库...${NC}"
        git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null
        echo -e "${GREEN}✓ 推送成功${NC}"
        echo ""
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}✅ 技能已初始化并推送!${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo "📍 仓库地址: $REMOTE_URL"
        gh repo view --web 2>/dev/null &>/dev/null &
        exit 0
    fi
fi

# 创建 GitHub 仓库
echo ""
echo -e "${BLUE}☁️  在 GitHub 创建仓库...${NC}"
echo "仓库名称: $SKILL_NAME"
echo "可见性: Public"
echo ""

# 询问仓库描述
echo -n "输入仓库描述 (可选，直接回车跳过): "
read REPO_DESCRIPTION

if [ -n "$REPO_DESCRIPTION" ]; then
    gh repo create "$SKILL_NAME" --public --description "$REPO_DESCRIPTION" --source=. --push
else
    gh repo create "$SKILL_NAME" --public --source=. --push
fi

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ 技能已成功发布到 GitHub!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "📍 仓库地址: https://github.com/$GITHUB_USERNAME/$SKILL_NAME"
    echo ""
    echo -e "${BLUE}🎉 下次修改后，只需运行:${NC}"
    echo "  推送 $SKILL_NAME"
    echo "  或"
    echo "  push-skill $SKILL_NAME"
    echo ""

    # 在浏览器中打开
    echo -e "${BLUE}🌐 在浏览器中打开仓库...${NC}"
    gh repo view --web 2>/dev/null &
else
    echo ""
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}❌ 创建仓库失败${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "可能的原因:"
    echo "  1. 仓库已存在 (运行: git remote add origin <url> && git push -u origin main)"
    echo "  2. 网络连接问题"
    echo "  3. GitHub 权限问题"
    exit 1
fi
