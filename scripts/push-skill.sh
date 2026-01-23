#!/bin/bash
# Claude Code Skills 一键推送脚本
# 使用方法: bash push-skill.sh <skill-name>

set -e  # 遇到错误立即退出

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
    echo "使用方法: push-skill <skill-name>"
    echo ""
    echo "可用的技能:"
    ls -1 "$SKILLS_DIR" 2>/dev/null | grep -v "^\." | grep -v "^total" | while read dir; do
        if [ -d "$SKILLS_DIR/$dir" ]; then
            # 检查是否有 Git 仓库
            if [ -d "$SKILLS_DIR/$dir/.git" ]; then
                echo "  ✓ $dir (已初始化 Git)"
            else
                echo "    $dir"
            fi
        fi
    done
    echo ""
    echo -e "${YELLOW}提示: 运行 'init-skill-repo <skill-name>' 初始化新技能的 Git 仓库${NC}"
    exit 1
fi

# 检查技能目录是否存在
if [ ! -d "$SKILL_PATH" ]; then
    echo -e "${RED}错误: 技能 '$SKILL_NAME' 不存在${NC}"
    echo "路径: $SKILL_PATH"
    exit 1
fi

cd "$SKILL_PATH"

# 检查是否已初始化 Git
if [ ! -d ".git" ]; then
    echo -e "${BLUE}📦 未找到 Git 仓库，正在初始化...${NC}"
    git init -q

    # 创建 .gitignore
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

    echo -e "${GREEN}✓ Git 仓库已初始化${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  首次推送需要创建 GitHub 仓库${NC}"
    echo ""
    echo "运行以下命令创建仓库并推送:"
    echo "  gh repo create $SKILL_NAME --public --source=. --push"
    echo ""
    echo "或使用:"
    echo "  初始化技能仓库 $SKILL_NAME"
    exit 0
fi

# 检查远程仓库
if ! git remote get-url origin &>/dev/null; then
    echo -e "${RED}⚠️  未找到远程仓库${NC}"
    echo ""
    echo "请先创建 GitHub 仓库:"
    echo ""
    echo "方法 1 - 使用 GitHub CLI (推荐):"
    echo "  gh repo create $SKILL_NAME --public --source=. --push"
    echo ""
    echo "方法 2 - 手动创建:"
    echo "  1. 访问 https://github.com/new 创建仓库"
    echo "  2. 运行: git remote add origin https://github.com/<username>/$SKILL_NAME.git"
    echo "  3. 运行: git push -u origin main"
    echo ""
    echo "或使用:"
    echo "  初始化技能仓库 $SKILL_NAME"
    exit 1
fi

# 检查主分支名称
MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$MAIN_BRANCH" ]; then
    # 尝试从本地分支检测
    MAIN_BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -z "$MAIN_BRANCH" ]; then
        MAIN_BRANCH="main"
        git branch -M main 2>/dev/null || MAIN_BRANCH="master"
    fi
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📤 推送技能: ${SKILL_NAME}${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 显示当前状态
echo -e "${BLUE}📊 当前状态:${NC}"
git status -sb
echo ""

# 添加所有更改
echo -e "${BLUE}📝 添加更改...${NC}"
git add -A

# 检查是否有更改
if git diff --cached --quiet; then
    echo -e "${GREEN}✓ 没有新更改，无需提交${NC}"
else
    # 生成提交信息
    CURRENT_VERSION=$(cat VERSION 2>/dev/null || echo "unknown")
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    # 询问提交信息
    echo ""
    echo -e "${BLUE}请选择提交信息:${NC}"
    echo "  1) 自动生成 (v${CURRENT_VERSION} - ${TIMESTAMP})"
    echo "  2) 自定义"
    echo -n "选择 [1/2]: "
    read -n 1 CHOICE
    echo ""

    if [ "$CHOICE" = "2" ]; then
        echo -n "输入提交信息: "
        read COMMIT_MSG
    else
        COMMIT_MSG="v${CURRENT_VERSION} - ${TIMESTAMP}"
    fi

    # 提交
    git commit -m "$COMMIT_MSG"
    echo -e "${GREEN}✓ 提交成功${NC}"
fi

echo ""

# 推送到远程
echo -e "${BLUE}🚀 推送到 GitHub...${NC}"
if git push -u origin $MAIN_BRANCH 2>&1; then
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✅ 推送成功!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    REMOTE_URL=$(git remote get-url origin)
    echo "📍 仓库地址: $REMOTE_URL"

    # 尝试在浏览器中打开
    if command -v gh &>/dev/null; then
        echo -e "${BLUE}🌐 在浏览器中打开...${NC}"
        gh repo view --web 2>/dev/null &>/dev/null &
    fi
else
    echo ""
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}❌ 推送失败${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "可能的原因:"
    echo "  1. 需要身份验证 (运行 'gh auth login')"
    echo "  2. 远程仓库不存在"
    echo "  3. 网络连接问题"
    echo "  4. 分支名称不匹配"
    echo ""
    echo "建议:"
    echo "  1. 检查远程仓库: git remote -v"
    echo "  2. 重新登录: gh auth login"
    echo "  3. 手动推送: cd $SKILL_PATH && git push"
    exit 1
fi
