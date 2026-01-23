#!/bin/bash
# Skill Publisher - NPM 发布脚本

set -e

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}║   Skill Publisher - NPM 发布工具                          ║${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# 获取包信息
PACKAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PACKAGE_DIR"

PACKAGE_NAME=$(cat package.json | grep '"name"' | head -1 | cut -d'"' -f4)
PACKAGE_VERSION=$(cat package.json | grep '"version"' | head -1 | cut -d'"' -f4)

echo -e "${BLUE}📦 包信息${NC}"
echo "   名称: $PACKAGE_NAME"
echo "   版本: $PACKAGE_VERSION"
echo ""

# 1. 检查 NPM 登录
echo -e "${BLUE}1️⃣  检查 NPM 登录状态...${NC}"
if npm whoami > /dev/null 2>&1; then
    NPM_USER=$(npm whoami)
    echo -e "${GREEN}   ✅ 已登录: $NPM_USER${NC}"
else
    echo -e "${RED}   ❌ 未登录 NPM${NC}"
    echo ""
    echo "请先登录 NPM:"
    echo "  npm login"
    echo ""
    echo "或访问注册账号:"
    echo "  https://www.npmjs.com/signup"
    exit 1
fi
echo ""

# 2. 检查包名是否可用
echo -e "${BLUE}2️⃣  检查包名...${NC}"
if npm view "$PACKAGE_NAME" > /dev/null 2>&1; then
    echo -e "${YELLOW}   ⚠️  包 '$PACKAGE_NAME' 已存在${NC}"

    # 检查是否是自己的包
    OWNER=$(npm view "$PACKAGE_NAME" author 2>/dev/null || echo "")
    if [ "$OWNER" = "$NPM_USER" ] || npm access ls-collaborators "$PACKAGE_NAME" 2>/dev/null | grep -q "$NPM_USER"; then
        echo -e "${GREEN}   ✅ 你有发布权限${NC}"

        # 检查当前版本是否已存在
        if npm view "$PACKAGE_NAME@$PACKAGE_VERSION" > /dev/null 2>&1; then
            echo -e "${YELLOW}   ⚠️  版本 $PACKAGE_VERSION 已存在${NC}"
            echo -n "   是否更新版本号? [y/N]: "
            read -n 1 UPDATE_VERSION
            echo ""

            if [ "$UPDATE_VERSION" = "y" ] || [ "$UPDATE_VERSION" = "Y" ]; then
                echo "   选择版本更新类型:"
                echo "   1) patch (1.2.0 -> 1.2.1)"
                echo "   2) minor (1.2.0 -> 1.3.0)"
                echo "   3) major (1.2.0 -> 2.0.0)"
                echo -n "   选择 [1/2/3]: "
                read -n 1 BUMP_TYPE
                echo ""

                case $BUMP_TYPE in
                    1) npm version patch ;;
                    2) npm version minor ;;
                    3) npm version major ;;
                    *) echo "   取消"; exit 1 ;;
                esac

                # 同步 VERSION 文件
                NEW_VERSION=$(cat package.json | grep '"version"' | head -1 | cut -d'"' -f4)
                echo "$NEW_VERSION" > VERSION

                echo -e "${GREEN}   ✅ 版本已更新到 $NEW_VERSION${NC}"
                echo -n "   是否提交更改? [y/N]: "
                read -n 1 COMMIT
                echo ""

                if [ "$COMMIT" = "y" ] || [ "$COMMIT" = "Y" ]; then
                    git add VERSION package.json package-lock.json
                    git commit -m "chore: bump version to $NEW_VERSION"
                    echo -e "${GREEN}   ✅ 已提交${NC}"
                fi
            else
                echo "   取消发布"
                exit 0
            fi
        fi
    else
        echo -e "${RED}   ❌ 你没有发布权限${NC}"
        echo "   包所有者: $OWNER"
        echo "   解决方案:"
        echo "   1. 使用 scoped 包名: @username/skill-publisher"
        echo "   2. 更换包名"
        exit 1
    fi
else
    echo -e "${GREEN}   ✅ 包名可用${NC}"
fi
echo ""

# 3. 检查必要文件
echo -e "${BLUE}3️⃣  检查必要文件...${NC}"
REQUIRED_FILES=("package.json" "README.md" ".npmignore")
ALL_EXIST=true

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}   ✅ $file${NC}"
    else
        echo -e "${RED}   ❌ $file 缺失${NC}"
        ALL_EXIST=false
    fi
done

if [ "$ALL_EXIST" = false ]; then
    exit 1
fi
echo ""

# 4. 测试打包
echo -e "${BLUE}4️⃣  测试打包...${NC}"
if npm pack --dry-run > /dev/null 2>&1; then
    echo -e "${GREEN}   ✅ 打包测试通过${NC}"
else
    echo -e "${RED}   ❌ 打包测试失败${NC}"
    exit 1
fi
echo ""

# 5. 确认发布
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}📦 准备发布到 NPM${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo "   包名: $PACKAGE_NAME"
echo "   版本: $PACKAGE_VERSION"
echo "   作者: $NPM_USER"
echo ""
echo -e "${YELLOW}⚠️  发布后无法撤销 (24小时内只能撤销一次)${NC}"
echo ""
echo -n "确认发布? [y/N]: "
read -n 1 CONFIRM
echo ""

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "已取消"
    exit 0
fi

echo ""
echo -e "${BLUE}5️⃣  正在发布...${NC}"

# 发布
if npm publish --access public 2>&1; then
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}║   ✅ 发布成功!                                            ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}📍 NPM 页面:${NC}"
    echo "   https://www.npmjs.com/package/$PACKAGE_NAME"
    echo ""
    echo -e "${BLUE}📦 安装命令:${NC}"
    echo "   npm install -g $PACKAGE_NAME"
    echo ""
    echo -e "${BLUE}🔍 验证:${NC}"
    echo "   npm view $PACKAGE_NAME"
    echo ""

    # 创建 GitHub Release (可选)
    echo -n "是否创建 GitHub Release? [y/N]: "
    read -n 1 CREATE_RELEASE
    echo ""

    if [ "$CREATE_RELEASE" = "y" ] || [ "$CREATE_RELEASE" = "Y" ]; then
        echo ""
        echo "创建 GitHub Release..."
        gh release create "v$PACKAGE_VERSION" \
            --title "Skill Publisher v$PACKAGE_VERSION" \
            --notes "## 🚀 NPM 发布

✨ 包已发布到 NPM!

### 安装
\`\`\`bash
npm install -g $PACKAGE_NAME
\`\`\`

### 使用
\`\`\`bash
push-skill <skill>
init-skill-repo <skill>
check-skills
batch-push
\`\`\`

📍 NPM: https://www.npmjs.com/package/$PACKAGE_NAME"
        echo -e "${GREEN}   ✅ GitHub Release 已创建${NC}"
    fi
else
    echo ""
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                                                            ║${NC}"
    echo -e "${RED}║   ❌ 发布失败                                            ║${NC}"
    echo -e "${RED}║                                                            ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "请检查错误信息并重试"
    exit 1
fi
