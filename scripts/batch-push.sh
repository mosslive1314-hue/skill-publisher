#!/bin/bash
# 批量推送多个 Skills 到 GitHub
# 使用方法: bash batch-push.sh [skill1 skill2 ...]

set -e

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SKILLS_DIR="$HOME/.claude/skills"
PUSH_SCRIPT="$HOME/.claude/skills/skill-publisher/scripts/push-skill.sh"

# 解析参数
if [ $# -eq 0 ]; then
    # 没有参数,推送所有已初始化 Git 的 skills
    echo -e "${BLUE}🔍 正在查找所有已初始化 Git 的 skills...${NC}"
    echo ""

    SKILLS_TO_PUSH=()
    for dir in "$SKILLS_DIR"/*/; do
        if [ -d "$dir" ]; then
            skill_name=$(basename "$dir")
            if [ -d "$dir/.git" ]; then
                # 检查是否有远程仓库
                if cd "$dir" && git remote get-url origin &>/dev/null; then
                    SKILLS_TO_PUSH+=("$skill_name")
                    echo -e "${GREEN}✓${NC} $skill_name"
                fi
            fi
        fi
    done

    if [ ${#SKILLS_TO_PUSH[@]} -eq 0 ]; then
        echo -e "${RED}❌ 未找到已初始化 Git 且配置了远程仓库的 skills${NC}"
        echo ""
        echo "提示:"
        echo "  1. 使用 '初始化技能仓库 <skill-name>' 初始化新 skill"
        echo "  2. 或手动指定 skill 名称: bash batch-push.sh skill1 skill2"
        exit 1
    fi

    echo ""
    echo -e "${BLUE}找到 ${#SKILLS_TO_PUSH[@]} 个 skills${NC}"
    echo ""
    echo -n "是否全部推送? [y/N]: "
    read -n 1 CONFIRM
    echo ""

    if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
        echo "已取消"
        exit 0
    fi

else
    # 有参数,推送指定的 skills
    SKILLS_TO_PUSH=("$@")
fi

# 开始批量推送
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📦 批量推送 Skills${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

SUCCESS_COUNT=0
FAILED_COUNT=0
FAILED_SKILLS=()

for skill in "${SKILLS_TO_PUSH[@]}"; do
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}📤 推送: ${skill}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [ ! -d "$SKILLS_DIR/$skill" ]; then
        echo -e "${RED}✗ Skill '$skill' 不存在${NC}"
        ((FAILED_COUNT++))
        FAILED_SKILLS+=("$skill (不存在)")
        echo ""
        continue
    fi

    # 使用自动提交信息 (选项 1)
    if echo "1" | bash "$PUSH_SCRIPT" "$skill" 2>&1; then
        echo -e "${GREEN}✓ $skill 推送成功${NC}"
        ((SUCCESS_COUNT++))
    else
        echo -e "${RED}✗ $skill 推送失败${NC}"
        ((FAILED_COUNT++))
        FAILED_SKILLS+=("$skill")
    fi

    echo ""
done

# 显示总结
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 推送总结${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "总计: ${#SKILLS_TO_PUSH[@]} 个 skills"
echo -e "${GREEN}成功: $SUCCESS_COUNT 个${NC}"
echo -e "${RED}失败: $FAILED_COUNT 个${NC}"

if [ $FAILED_COUNT -gt 0 ]; then
    echo ""
    echo -e "${RED}失败的 skills:${NC}"
    for skill in "${FAILED_SKILLS[@]}"; do
        echo -e "${RED}  ✗ $skill${NC}"
    done
    exit 1
else
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🎉 所有 skills 推送成功!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
fi
