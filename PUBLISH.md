# NPM 发布指南

本文档指导你如何将 skill-publisher 发布到 NPM。

---

## 📋 发布前检查清单

### 1. 检查包名是否可用

```bash
npm view skill-publisher
```

如果返回 `404` 或 `ERR! 404`,说明包名可用。
如果返回包信息,说明包名已被占用,需要更换名称。

### 2. 检查 package.json

```bash
cd ~/.claude/skills/skill-publisher
cat package.json
```

确保以下字段正确:
- `name`: 包名
- `version`: 版本号 (当前 1.2.0)
- `description`: 描述
- `author`: 作者
- `license`: 许可证
- `bin`: 命令配置
- `files`: 包含的文件

### 3. 测试打包

```bash
cd ~/.claude/skills/skill-publisher
npm pack
```

会生成 `skill-publisher-1.2.0.tgz` 文件。
检查内容是否正确。

### 4. 清理测试文件

```bash
rm -f skill-publisher-*.tgz
```

---

## 🔐 NPM 账号设置

### 1. 注册 NPM 账号 (如果还没有)

访问: https://www.npmjs.com/signup

### 2. 登录 NPM

```bash
npm login
```

按提示输入:
- Username: 你的 NPM 用户名
- Password: 你的 NPM 密码
- Email: 你的邮箱

或者使用一次性登录:

```bash
npm login --auth-type=legacy
```

或者使用 token (推荐用于 CI/CD):

```bash
# 创建 token
# 访问: https://www.npmjs.com/settings/tokens

# 使用 token 登录
npm config set //registry.npmjs.org/:_authToken YOUR_TOKEN
```

### 3. 验证登录状态

```bash
npm whoami
```

应该显示你的用户名。

---

## 🚀 发布步骤

### 方法 1: 直接发布

```bash
cd ~/.claude/skills/skill-publisher
npm publish
```

### 方法 2: 使用 dry-run 先测试

```bash
# 测试发布 (不会真正发布)
npm publish --dry-run

# 如果测试通过,真正发布
npm publish
```

### 方法 3: 发布到特定 registry

```bash
# 发布到 NPM (默认)
npm publish --registry https://registry.npmjs.org/

# 或发布到其他 registry (如私有 registry)
npm publish --registry https://your-registry.com/
```

---

## 📝 发布后验证

### 1. 检查包信息

```bash
npm view skill-publisher
```

### 2. 访问 NPM 页面

https://www.npmjs.com/package/skill-publisher

### 3. 测试安装

```bash
# 全局安装测试
npm install -g skill-publisher

# 测试命令
push-skill --help
skill-publisher --help

# 卸载测试
npm uninstall -g skill-publisher
```

### 4. 使用 NPX 测试

```bash
npx skill-publisher@latest --help
```

---

## 🔄 版本更新

### 1. 更新版本号

```bash
cd ~/.claude/skills/skill-publisher

# 更新 VERSION 文件
echo "1.3.0" > VERSION

# 或使用 npm version (会自动更新 package.json)
npm version minor  # 1.2.0 -> 1.3.0
npm version patch  # 1.2.0 -> 1.2.1
npm version major  # 1.2.0 -> 2.0.0
```

### 2. 提交更改

```bash
git add VERSION package.json package-lock.json
git commit -m "chore: bump version to 1.3.0"
git push
```

### 3. 发布新版本

```bash
npm publish
```

---

## ⚠️ 常见问题

### Q1: 提示 "403 Forbidden" 或 "You do not have permission"

**原因:**
- 包名已被其他人占用
- 你没有发布权限

**解决:**
```bash
# 检查包是否存在
npm view skill-publisher

# 如果存在且不是你的,需要更换包名
# 修改 package.json 中的 name:
# "name": "@username/skill-publisher"  # 使用 scope
```

### Q2: 提示 "E404" 或 "Package not found"

**原因:**
- 包名正确,但还没发布 (这是正常的)

**解决:**
直接发布即可:
```bash
npm publish
```

### Q3: 提示 "402 Payment Required"

**原因:**
- 发布了 scoped 包 (如 @username/package)
- 默认 scoped 包是付费的

**解决:**
```bash
# 发布为公开包
npm publish --access public

# 或在 package.json 中添加:
"publishConfig": {
  "access": "public"
}
```

### Q4: 发布后找不到命令

**原因:**
- npm bin 目录不在 PATH 中

**解决:**
```bash
# 查看 npm bin 目录
npm bin -g

# 添加到 PATH
export PATH="$(npm bin -g):$PATH"

# 永久添加 (添加到 ~/.bashrc)
echo 'export PATH="$(npm bin -g):$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Q5: 如何撤销发布?

**警告:** 只能撤销 24 小时内发布的版本,且只能撤销一次!

```bash
# 撤销特定版本
npm unpublish skill-publisher@1.2.0

# 撤销整个包 (危险!)
npm unpublish skill-publisher --force
```

---

## 📊 发布检查脚本

创建自动检查脚本:

```bash
#!/bin/bash
# check-before-publish.sh

echo "🔍 NPM 发布前检查"
echo "===================="
echo ""

# 1. 检查登录
echo "1️⃣ 检查 NPM 登录..."
if npm whoami > /dev/null 2>&1; then
    echo "   ✅ 已登录: $(npm whoami)"
else
    echo "   ❌ 未登录 NPM"
    echo "   请运行: npm login"
    exit 1
fi

# 2. 检查包名
echo ""
echo "2️⃣ 检查包名..."
NAME=$(cat package.json | grep '"name"' | head -1 | cut -d'"' -f4)
if npm view "$NAME" > /dev/null 2>&1; then
    echo "   ⚠️  包名 '$NAME' 已存在"
    OWNER=$(npm view "$NAME" author)
    echo "   所有者: $OWNER"
    echo "   确认你有发布权限,或更换包名"
else
    echo "   ✅ 包名 '$NAME' 可用"
fi

# 3. 检查版本
echo ""
echo "3️⃣ 检查版本..."
VERSION=$(cat package.json | grep '"version"' | head -1 | cut -d'"' -f4)
echo "   当前版本: $VERSION"

# 4. 测试打包
echo ""
echo "4️⃣ 测试打包..."
if npm pack --dry-run > /dev/null 2>&1; then
    echo "   ✅ 打包测试通过"
else
    echo "   ❌ 打包测试失败"
    exit 1
fi

# 5. 检查必要文件
echo ""
echo "5️⃣ 检查必要文件..."
FILES=("README.md" "package.json" ".npmignore")
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file"
    else
        echo "   ❌ $file 缺失"
    fi
done

# 6. 检查 bin 命令
echo ""
echo "6️⃣ 检查 bin 命令..."
if [ -d "bin" ] && [ "$(ls -1 bin/*.js 2>/dev/null | wc -l)" -gt 0 ]; then
    echo "   ✅ bin 命令: $(ls -1 bin/*.js | wc -l) 个"
else
    echo "   ❌ bin 命令缺失"
fi

echo ""
echo "===================="
echo "✅ 检查完成!"
echo ""
echo "准备发布? 运行:"
echo "  npm publish"
echo ""
```

使用:
```bash
chmod +x check-before-publish.sh
./check-before-publish.sh
```

---

## 🎯 快速发布流程

```bash
# 1. 进入目录
cd ~/.claude/skills/skill-publisher

# 2. 检查登录 (未登录先运行 npm login)
npm whoami

# 3. 测试打包
npm pack --dry-run

# 4. 真正发布
npm publish

# 5. 验证
npm view skill-publisher
```

---

## 📚 相关资源

- **NPM 文档**: https://docs.npmjs.com/
- **NPM 发布**: https://docs.npmjs.com/cli/v8/commands/npm-publish
- **包名规范**: https://docs.npmjs.com/creating-and-publishing-unscoped-public-packages
- **Scoped 包**: https://docs.npmjs.com/creating-and-publishing-scoped-public-packages

---

**最后更新**: 2026-01-23
**版本**: v1.2.0
