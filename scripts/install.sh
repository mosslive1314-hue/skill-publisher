#!/bin/bash
# Skill Publisher - 一键安装脚本

set -e

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}║   Skill Publisher - 一键安装                              ║${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

SKILLS_DIR="$HOME/.claude/skills"
SKILL_DIR="$SKILLS_DIR/skill-publisher"

# 检查是否已安装
if [ -d "$SKILL_DIR" ]; then
    echo -e "${YELLOW}⚠️  Skill Publisher 已安装${NC}"
    echo ""
    echo "位置: $SKILL_DIR"
    echo ""
    echo -n "是否更新? [y/N]: "
    read -n 1 UPDATE
    echo ""

    if [ "$UPDATE" = "y" ] || [ "$UPDATE" = "Y" ]; then
        echo "正在更新..."
        cd "$SKILL_DIR"
        git pull
        echo -e "${GREEN}✓ 更新完成${NC}"
    fi

    echo ""
    echo "已安装的命令:"
    echo "  推送 <skill>"
    echo "  初始化技能仓库 <skill>"
    echo "  检查技能"
    echo "  批量推送"
    echo ""
    exit 0
fi

# 创建 skills 目录
if [ ! -d "$SKILLS_DIR" ]; then
    echo "创建 skills 目录: $SKILLS_DIR"
    mkdir -p "$SKILLS_DIR"
fi

# 克隆仓库
echo ""
echo -e "${BLUE}📦 正在克隆仓库...${NC}"
git clone https://github.com/mosslive1314-hue/skill-publisher.git "$SKILL_DIR"

echo -e "${GREEN}✓ 克隆完成${NC}"
echo ""

# 配置别名
echo -e "${BLUE}🔧 配置命令别名...${NC}"
echo ""

# 检测 shell 配置文件
if [ -f "$HOME/.bashrc" ]; then
    CONFIG_FILE="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    CONFIG_FILE="$HOME/.zshrc"
else
    CONFIG_FILE="$HOME/.bashrc"
    touch "$CONFIG_FILE"
fi

# 添加别名
if ! grep -q "Skill Publisher 别名" "$CONFIG_FILE" 2>/dev/null; then
    cat >> "$CONFIG_FILE" << 'EOF'

# Skill Publisher 别名
alias 推送='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 初始化技能仓库='bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh'
alias 检查技能='bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh'
alias 批量推送='bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh'
EOF

    echo -e "${GREEN}✓ 别名已添加到 $CONFIG_FILE${NC}"
else
    echo -e "${GREEN}✓ 别名已配置${NC}"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║   ✅ 安装成功!                                            ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "📍 安装位置: $SKILL_DIR"
echo ""
echo "📝 使用命令:"
echo "  推送 <skill>              推送 skill 到 GitHub"
echo "  初始化技能仓库 <skill>     初始化新 skill"
echo "  检查技能                   检查所有 skills 状态"
echo "  批量推送                   批量推送 skills"
echo ""
echo -e "${YELLOW}⚠️  请运行以下命令使别名生效:${NC}"
echo "  source $CONFIG_FILE"
echo ""
echo "或重新打开终端窗口"
echo ""
echo "📚 更多信息:"
echo "   https://github.com/mosslive1314-hue/skill-publisher"
echo ""
