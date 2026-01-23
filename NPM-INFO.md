# NPM 发布说明

## 📦 NPM 包信息

- **包名**: `@mosslive1314-hue/skill-publisher`
- **版本**: 1.2.0
- **类型**: Public scoped package

## 🚀 发布到 NPM

### 前提条件

1. **NPM 账号**
   - 访问 https://www.npmjs.com/signup 注册
   - 验证邮箱

2. **登录 NPM**
   ```bash
   npm login
   ```

### 发布步骤

```bash
# 1. 检查包名是否可用
npm view @mosslive1314-hue/skill-publisher
# 如果返回 404，说明包名可用 ✅

# 2. 测试打包
npm pack
# 会生成 @mosslive1314-hue-skill-publisher-1.2.0.tgz

# 3. 检查打包内容
tar -tzf @mosslive1314-hue-skill-publisher-1.2.0.tgz | head -20

# 4. 清理测试文件
rm @mosslive1314-hue-skill-publisher-*.tgz

# 5. 发布
npm publish --access public
```

### 验证发布

```bash
# 查看 NPM 包信息
npm view @mosslive1314-hue/skill-publisher

# 访问 NPM 页面
# https://www.npmjs.com/package/@mosslive1314-hue/skill-publisher
```

## 💡 使用方式

### NPM 安装

```bash
npm install @mosslive1314-hue/skill-publisher
```

### NPX (无需安装)

```bash
npx @mosslive1314-hue/skill-publisher
```

### NPM 全局安装

```bash
npm install -g @mosslive1314-hue/skill-publisher
```

## ⚠️ 注意事项

1. **Scoped 包**: `@mosslive1314-hue/skill-publisher` 必须使用 `--access public` 发布
2. **Postinstall 脚本**: 自动配置别名到 `~/.bashrc`
3. **无依赖**: 纯 skill 包，没有 node_modules 依赖

## 🔄 更新版本

```bash
# 更新 VERSION
echo "1.3.0" > VERSION

# 更新 package.json
npm version minor

# 提交
git add VERSION package.json
git commit -m "chore: bump version to 1.3.0"
git push

# 发布到 NPM
npm publish --access public
```

## 📊 下载统计

查看下载量:
```bash
npm view @mosslive1314-hue/skill-publisher
```

或访问:
https://npmjs.com/package/@mosslive1314-hue/skill-publisher
