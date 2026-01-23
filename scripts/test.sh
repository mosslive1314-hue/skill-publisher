#!/bin/bash
# Skill Publisher 测试脚本

echo "==================================="
echo "Skill Publisher 功能测试"
echo "==================================="
echo ""

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$HOME/.claude/skills/skill-publisher/scripts"

# 测试 1: 检查脚本文件
echo "📁 测试 1: 检查脚本文件"
echo "-----------------------------------"

SCRIPTS=("push-skill.sh" "init-skill-repo.sh" "check-skills.sh" "batch-push.sh")
ALL_EXIST=true

for script in "${SCRIPTS[@]}"; do
    if [ -f "$SCRIPT_DIR/$script" ]; then
        SIZE=$(wc -l < "$SCRIPT_DIR/$script")
        echo "✓ $script ($SIZE 行)"
    else
        echo "✗ $script 不存在"
        ALL_EXIST=false
    fi
done

if [ "$ALL_EXIST" = true ]; then
    echo "✅ 所有脚本文件存在"
else
    echo "❌ 部分脚本文件缺失"
    exit 1
fi

echo ""

# 测试 2: 检查脚本语法
echo "🔍 测试 2: 检查脚本语法"
echo "-----------------------------------"

ALL_VALID=true

for script in "${SCRIPTS[@]}"; do
    if bash -n "$SCRIPT_DIR/$script" 2>/dev/null; then
        echo "✓ $script 语法正确"
    else
        echo "✗ $script 语法错误"
        ALL_VALID=false
    fi
done

if [ "$ALL_VALID" = true ]; then
    echo "✅ 所有脚本语法正确"
else
    echo "❌ 部分脚本有语法错误"
    exit 1
fi

echo ""

# 测试 3: 检查可执行权限
echo "🔐 测试 3: 检查可执行权限"
echo "-----------------------------------"

ALL_EXEC=true

for script in "${SCRIPTS[@]}"; do
    if [ -x "$SCRIPT_DIR/$script" ]; then
        echo "✓ $script 有执行权限"
    else
        echo "✗ $script 没有执行权限"
        ALL_EXEC=false
    fi
done

if [ "$ALL_EXEC" = true ]; then
    echo "✅ 所有脚本有执行权限"
else
    echo "❌ 部分脚本缺少执行权限"
    exit 1
fi

echo ""

# 测试 4: 检查文档文件
echo "📚 测试 4: 检查文档文件"
echo "-----------------------------------"

DOCS=(
    "SKILL.md"
    "README.md"
    "QUICKREF.md"
    "DEPLOYMENT.md"
    "references/GUIDE.md"
    "references/EXAMPLES.md"
    "references/FAQ.md"
)

ALL_EXIST=true

for doc in "${DOCS[@]}"; do
    if [ -f "$SKILLS_DIR/skill-publisher/$doc" ]; then
        SIZE=$(wc -l < "$SKILLS_DIR/skill-publisher/$doc")
        echo "✓ $doc ($SIZE 行)"
    else
        echo "✗ $doc 不存在"
        ALL_EXIST=false
    fi
done

if [ "$ALL_EXIST" = true ]; then
    echo "✅ 所有文档文件存在"
else
    echo "❌ 部分文档文件缺失"
    exit 1
fi

echo ""

# 测试 5: 检查 Git 仓库
echo "🐙 测试 5: 检查 Git 仓库"
echo "-----------------------------------"

cd "$SKILLS_DIR/skill-publisher"

if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "✓ Git 仓库已初始化"

    # 检查远程仓库
    if git remote get-url origin > /dev/null 2>&1; then
        REMOTE_URL=$(git remote get-url origin)
        echo "✓ 远程仓库已配置: $REMOTE_URL"
    else
        echo "⚠️  远程仓库未配置"
    fi

    # 检查分支
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    echo "✓ 当前分支: $BRANCH"

    # 检查最新提交
    LATEST_COMMIT=$(git log -1 --oneline 2>/dev/null || echo "unknown")
    echo "✓ 最新提交: $LATEST_COMMIT"
else
    echo "✗ Git 仓库未初始化"
    exit 1
fi

echo ""

# 测试 6: 检查别名配置
echo "🔧 测试 6: 检查别名配置"
echo "-----------------------------------"

ALIASES=("推送" "推送技能" "初始化技能仓库" "检查技能" "批量推送")
FOUND=0

for alias_name in "${ALIASES[@]}"; do
    if grep -q "alias.*$alias_name" ~/.bashrc 2>/dev/null; then
        echo "✓ 别名 '$alias_name' 已配置"
        ((FOUND++))
    else
        echo "⚠️  别名 '$alias_name' 未配置"
    fi
done

echo "已配置别名: $FOUND/${#ALIASES[@]}"

echo ""

# 测试 7: 功能测试 - 检查 skills
echo "🔍 测试 7: 功能测试 - 检查 skills"
echo "-----------------------------------"

TOTAL=0
INITIALIZED=0

for dir in "$SKILLS_DIR"/*/; do
    if [ -d "$dir" ]; then
        ((TOTAL++))
        skill_name=$(basename "$dir")

        if [ -d "$dir/.git" ]; then
            ((INITIALIZED++))
        fi
    fi
done

echo "总共 skills: $TOTAL"
echo "已初始化 Git: $INITIALIZED"
echo "未初始化: $((TOTAL - INITIALIZED))"

if [ $INITIALIZED -gt 0 ]; then
    echo "✅ 找到已初始化的 skills"
else
    echo "⚠️  没有找到已初始化的 skills"
fi

echo ""

# 总结
echo "==================================="
echo "📊 测试总结"
echo "==================================="
echo ""
echo "✅ 所有基础测试通过!"
echo ""
echo "📦 技能文件: 4 个脚本"
echo "📚 文档文件: 7 个文档"
echo "🎯 已配置别名: $FOUND/${#ALIASES[@]}"
echo "🔧 已初始化 skills: $INITIALIZED/$TOTAL"
echo ""
echo "🎉 Skill Publisher 已就绪!"
echo ""
echo "📝 快速开始:"
echo "  检查技能          # 查看所有 skills 状态"
echo "  推送 <skill>      # 推送指定 skill"
echo "  批量推送          # 推送所有 skills"
echo ""
