# NPM 发布快速指南

## 🚀 一键发布 (推荐)

我们已经创建了自动化发布脚本,使用方法:

```bash
cd ~/.claude/skills/skill-publisher
bash scripts/publish-to-npm.sh
```

脚本会自动:
1. ✅ 检查 NPM 登录状态
2. ✅ 检查包名是否可用
3. ✅ 验证文件完整性
4. ✅ 测试打包
5. ✅ 发布到 NPM
6. ✅ 创建 GitHub Release (可选)

---

## 📝 发布前准备

### 步骤 1: 注册/登录 NPM

**如果你还没有 NPM 账号:**

1. 访问 https://www.npmjs.com/signup
2. 填写注册信息
3. 验证邮箱

**登录 NPM:**

```bash
npm login
```

按提示输入:
- Username
- Password
- Email

验证登录:
```bash
npm whoami
```

应该显示你的用户名。

### 步骤 2: 检查包名

```bash
# 检查 skill-publisher 是否已被占用
npm view skill-publisher
```

**如果返回 404:**
✅ 包名可用,可以直接发布

**如果返回包信息:**
⚠️ 包名已被占用,有两个选择:

选项 A - 使用 scoped 包名:
```bash
# 修改 package.json
"name": "@yourusername/skill-publisher"

# 发布为公开包
npm publish --access public
```

选项 B - 更换包名:
```bash
# 修改 package.json
"name": "claude-skill-publisher"
# 或
"name": "skill-cli"
# 等
```

### 步骤 3: 检查文件

```bash
cd ~/.claude/skills/skill-publisher

# 确保以下文件存在
ls -la package.json README.md .npmignore

# 检查 package.json
cat package.json | grep -E '"name"|"version"|"bin"'
```

---

## 🎯 三种发布方式

### 方式 1: 使用自动化脚本 (最简单)

```bash
cd ~/.claude/skills/skill-publisher
bash scripts/publish-to-npm.sh
```

### 方式 2: 手动发布 (更灵活)

```bash
cd ~/.claude/skills/skill-publisher

# 1. 测试打包
npm pack --dry-run

# 2. 如果测试通过,发布
npm publish

# 3. 验证
npm view skill-publisher
```

### 方式 3: 分步发布 (更安全)

```bash
cd ~/.claude/skills/skill-publisher

# 1. 打包测试
npm pack
# 会生成 skill-publisher-1.2.0.tgz

# 2. 检查打包内容
tar -tzf skill-publisher-1.2.0.tgz | head -20

# 3. 清理
rm skill-publisher-*.tgz

# 4. 发布
npm publish --access public

# 5. 测试安装
npm install -g skill-publisher@1.2.0

# 6. 验证命令
push-skill --help
skill-publisher --help

# 7. 卸载测试版
npm uninstall -g skill-publisher
```

---

## ⚠️ 常见错误处理

### 错误 1: 403 Forbidden

```
npm ERR! 403 403 Forbidden - PUT https://registry.npmjs.org/skill-publisher
```

**原因:** 包名已被占用

**解决:**
```bash
# 检查包所有者
npm view skill-publisher author

# 如果是你的包,直接更新版本后发布
npm version patch
npm publish

# 如果不是你的包,使用 scoped 包
# 修改 package.json:
"name": "@yourusername/skill-publisher"

# 发布
npm publish --access public
```

### 错误 2: 402 Payment Required

```
npm ERR! 402 Payment Required
```

**原因:** Scoped 包默认是付费的

**解决:**
```bash
# 发布为公开包
npm publish --access public

# 或在 package.json 添加:
"publishConfig": {
  "access": "public"
}
```

### 错误 3: E404 Not Found

```
npm ERR! 404 Package not found
```

**原因:** 包名不存在 (这是正常的,第一次发布)

**解决:** 直接发布即可
```bash
npm publish
```

---

## ✅ 发布后验证

### 1. 查看 NPM 包信息

```bash
npm view skill-publisher
```

应该显示包的完整信息。

### 2. 访问 NPM 页面

https://www.npmjs.com/package/skill-publisher

### 3. 测试安装

```bash
# 全局安装
npm install -g skill-publisher

# 检查命令
which push-skill
which init-skill-repo
which check-skills
which batch-push
which skill-publisher

# 测试命令
push-skill --help
skill-publisher version

# 卸载
npm uninstall -g skill-publisher
```

### 4. 使用 NPX 测试

```bash
npx skill-publisher@latest version
```

---

## 📊 发布检查清单

在发布前,确认:

- [ ] 已登录 NPM (`npm whoami`)
- [ ] 包名可用或你有权限
- [ ] package.json 配置正确
- [ ] VERSION 和 package.json 版本一致
- [ ] README.md 存在
- [ ] .npmignore 存在
- [ ] bin 命令配置正确
- [ ] 所有脚本文件已包含
- [ ] 测试打包通过

---

## 🎉 发布成功后

### 更新文档

在 README.md 添加 NPM 徽章:

```markdown
[![npm version](https://badge.fury.io/js/skill-publisher.svg)](https://www.npmjs.com/package/skill-publisher)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
```

### 分享到社区

- Reddit: r/Claude, r/devtools
- Twitter: 发布推文
- GitHub: 更新 README

### 创建安装教程

在项目文档中添加:

```markdown
## 安装

### NPM (推荐)
\`\`\`bash
npm install -g skill-publisher
\`\`\`

### NPX (无需安装)
\`\`\`bash
npx skill-publisher push <skill>
\`\`\`

### 手动安装
详见 DEPLOYMENT.md
```

---

## 🔧 下一步

发布成功后,考虑:

1. **设置自动化 CI/CD**
   - GitHub Actions 自动发布

2. **添加测试**
   - 自动化测试脚本

3. **监控下载量**
   - npm stats
   - GitHub insights

4. **收集反馈**
   - Issues
   - Discussions

---

**祝发布顺利!** 🚀

如果遇到问题,检查 `PUBLISH.md` 获取详细文档。
