#!/bin/bash
# 检查所有 Skills 的 Git 状态
# 使用方法: bash check-skills.sh

set -e

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

SKILLS_DIR="$HOME/.claude/skills"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}🔍 Skills 状态检查${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

TOTAL_COUNT=0
INITIALIZED_COUNT=0
UNINITIALIZED_COUNT=0
NEEDS_PUSH_COUNT=0
CLEAN_COUNT=0

for dir in "$SKILLS_DIR"/*/; do
    if [ -d "$dir" ]; then
        skill_name=$(basename "$dir")
        ((TOTAL_COUNT++))

        echo -e "${CYAN}━━━ $skill_name ━━━${NC}"

        if [ ! -d "$dir/.git" ]; then
            # 未初始化 Git
            echo -e "${YELLOW}⚠️  未初始化 Git${NC}"
            echo -e "  → 运行: ${GREEN}初始化技能仓库 $skill_name${NC}"
            ((UNINITIALIZED_COUNT++))
        else
            # 已初始化 Git
            ((INITIALIZED_COUNT++))
            cd "$dir"

            # 获取分支信息
            CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")

            # 检查是否有未提交的更改
            if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
                # 有未提交的更改
                echo -e "${YELLOW}📝 有未提交的更改${NC}"
                echo -e "  分支: ${CYAN}$CURRENT_BRANCH${NC}"

                # 显示状态摘要
                CHANGED_FILES=$(git status --short | wc -l)
                echo -e "  更改文件: ${YELLOW}$CHANGED_FILES${NC}"

                # 显示未跟踪文件
                UNTRACKED=$(git ls-files --others --exclude-standard | wc -l)
                if [ $UNTRACKED -gt 0 ]; then
                    echo -e "  未跟踪: ${YELLOW}$UNTRACKED${NC}"
                fi

                ((NEEDS_PUSH_COUNT++))
                echo -e "  → 运行: ${GREEN}推送 $skill_name${NC}"

            elif [ -n "$(git log origin/$CURRENT_BRANCH..$CURRENT_BRANCH 2>/dev/null)" ] 2>/dev/null; then
                # 有未推送的提交
                AHEAD_COUNT=$(git log origin/$CURRENT_BRANCH..$CURRENT_BRANCH 2>/dev/null | grep "^commit" | wc -l)
                echo -e "${YELLOW}⬆️  有未推送的提交 ($AHEAD_COUNT 个)${NC}"
                echo -e "  分支: ${CYAN}$CURRENT_BRANCH${NC}"
                ((NEEDS_PUSH_COUNT++))
                echo -e "  → 运行: ${GREEN}推送 $skill_name${NC}"

            else
                # 工作目录干净
                echo -e "${GREEN}✓ 干净${NC}"
                echo -e "  分支: ${CYAN}$CURRENT_BRANCH${NC}"

                # 显示远程仓库
                if git remote get-url origin &>/dev/null; then
                    REMOTE_URL=$(git remote get-url origin)
                    # 简化 URL 显示
                    SHORT_URL=$(echo "$REMOTE_URL" | sed 's|https://github.com/||' | sed 's|git@github.com:||' | sed 's|\.git$||')
                    echo -e "  远程: ${CYAN}$SHORT_URL${NC}"
                else
                    echo -e "  ${YELLOW}⚠️  未配置远程仓库${NC}"
                    echo -e "  → 运行: ${GREEN}初始化技能仓库 $skill_name${NC}"
                fi

                ((CLEAN_COUNT++))
            fi
        fi

        echo ""
    fi
done

# 显示总结
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}📊 总结${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "总计:       $TOTAL_COUNT 个 skills"
echo -e "${GREEN}已初始化:   $INITIALIZED_COUNT 个${NC}"
echo -e "${YELLOW}未初始化:   $UNINITIALIZED_COUNT 个${NC}"
echo -e "${GREEN}干净:       $CLEAN_COUNT 个${NC}"
echo -e "${YELLOW}需要推送:   $NEEDS_PUSH_COUNT 个${NC}"
echo ""

if [ $UNINITIALIZED_COUNT -gt 0 ]; then
    echo -e "${YELLOW}💡 提示: 使用以下命令初始化未配置的 skills:${NC}"
    echo ""
    for dir in "$SKILLS_DIR"/*/; do
        if [ -d "$dir" ] && [ ! -d "$dir/.git" ]; then
            skill_name=$(basename "$dir")
            echo -e "  ${GREEN}初始化技能仓库 $skill_name${NC}"
        fi
    done
    echo ""
fi

if [ $NEEDS_PUSH_COUNT -gt 0 ]; then
    echo -e "${YELLOW}💡 提示: 使用以下命令推送需要更新的 skills:${NC}"
    echo ""
    echo -e "  单个推送: ${GREEN}推送 <skill-name>${NC}"
    echo -e "  批量推送: ${GREEN}bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh${NC}"
    echo ""
fi

if [ $CLEAN_COUNT -eq $INITIALIZED_COUNT ] && [ $UNINITIALIZED_COUNT -eq 0 ]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}🎉 所有 skills 都是最新状态!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
fi
