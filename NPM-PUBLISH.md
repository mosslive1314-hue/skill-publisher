# 📦 NPM 发布指南

## 🎯 目标

将 skill-publisher 发布到 NPM，让其他用户可以在 Claude Code 中通过 `npm install` 一键安装。

---

## ✅ 发布前检查

### 1. 检查包名是否可用

```bash
npm view @mosslive1314-hue/skill-publisher
```

如果返回 404，说明包名可用 ✅

### 2. 验证 package.json

```bash
cd ~/.claude/skills/skill-publisher
cat package.json
```

关键配置：
- ✅ `name`: `@mosslive1314-hue/skill-publisher` (scoped 包名)
- ✅ `version`: `1.2.0`
- ✅ `publishConfig.access`: `public` (公开包)

---

## 🚀 发布步骤

### 步骤 1: 登录 NPM

```bash
npm login
```

如果没有 NPM 账号：
1. 访问 https://www.npmjs.com/signup
2. 注册账号
3. 运行 `npm login`

### 步骤 2: 测试打包

```bash
cd ~/.claude/skills/skill-publisher
npm pack
```

会生成 `@mosslive1314-hue-skill-publisher-1.2.0.tgz`

检查打包内容：
```bash
tar -tzf @mosslive1314-hue-skill-publisher-1.2.0.tgz | head -20
```

清理测试文件：
```bash
rm @mosslive1314-hue-skill-publisher-*.tgz
```

### 步骤 3: 发布到 NPM

```bash
npm publish --access public
```

`--access public` 是必需的，因为这是 scoped 包（`@username/package-name`）。

### 步骤 4: 验证发布

```bash
# 查看 NPM 包信息
npm view @mosslive1314-hue/skill-publisher

# 访问 NPM 页面
# https://www.npmjs.com/package/@mosslive1314-hue/skill-publisher
```

---

## 📝 发布后更新 README

发布成功后，README.md 中已经包含 NPM badge：

```markdown
[![npm version](https://badge.fury.io/js/@mosslive1314-hue%2Fskill-publisher.svg)](https://www.npmjs.com/package/@mosslive1314-hue/skill-publisher)
```

用户可以看到最新版本号。

---

## 🧪 测试安装

让其他用户测试安装：

```bash
# 在 Claude Code 对话中运行
npm install @mosslive1314-hue/skill-publisher
```

安装完成后，skill 会自动在 `~/.claude/skills/skill-publisher`，并可用。

---

## ⚠️ 常见错误

### 错误 1: 403 Forbidden

```
npm ERR! 403 403 Forbidden
```

**原因：** 没有使用 `--access public`

**解决：**
```bash
npm publish --access public
```

### 错误 2: 包名已存在

```
npm ERR! 404 Package not found
```

**原因：** 这实际上是正常的（第一次发布）

**解决：** 继续发布即可

### 错误 3: 权限错误

```
npm ERR! E401 Unauthorized
```

**原因：** 未登录或 token 过期

**解决：**
```bash
npm login
```

---

## 🎉 发布成功后

### 1. 创建 GitHub Release

```bash
gh release create v1.2.0 \
  --title "Skill Publisher v1.2.0 - NPM 发布" \
  --notes "## 🎉 NPM 发布

✨ 包已发布到 NPM!

### 安装
\`\`\`bash
npm install @mosslive1314-hue/skill-publisher
\`\`\`

安装后即可在 Claude Code 中使用一键推送功能。

📍 NPM: https://www.npmjs.com/package/@mosslive1314-hue/skill-publisher"
```

### 2. 更新文档

在 README.md 顶部已有：
- ✅ NPM 版本 badge
- ✅ 一键安装命令
- ✅ 完整使用说明

### 3. 分享给社区

- Reddit: r/Claude
- Twitter: 发布推文
- GitHub Discussions

---

## 📊 版本更新

下次更新时：

```bash
cd ~/.claude/skills/skill-publisher

# 1. 更新版本
echo "1.3.0" > VERSION
npm version minor  # 自动更新 package.json

# 2. 提交
git add VERSION package.json package-lock.json
git commit -m "chore: bump version to 1.3.0"
git push

# 3. 发布
npm publish --access public
```

---

## 🔐 安全建议

1. **使用 .npmignore**
   - ✅ 已配置，不会发布敏感文件

2. **检查 package.json**
   - ✅ 已移除 `bin` 字段
   - ✅ 只包含必要的 `scripts`

3. **定期更新依赖**
   - 当前无依赖（纯 skill）

---

## ✅ 检查清单

发布前确认：

- [ ] 已登录 NPM (`npm whoami`)
- [ ] 包名是 scoped (`@mosslive1314-hue/skill-publisher`)
- [ ] `publishConfig.access` 是 `public`
- [ ] `scripts/install.js` 存在
- [ ] README.md 有安装说明
- [ ] VERSION 和 package.json 版本一致
- [ ] 测试打包成功

---

**准备发布？运行：**

```bash
npm publish --access public
```
