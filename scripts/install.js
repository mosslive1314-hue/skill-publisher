#!/usr/bin/env node
/**
 * Skill Publisher - 安装脚本
 *
 * 将 skill 安装到 ~/.claude/skills/skill-publisher
 */

const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

const VERSION = JSON.parse(
  fs.readFileSync(path.join(__dirname, '..', 'package.json'), 'utf8')
).version;

console.log(`
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║   Skill Publisher v${VERSION}                              ║
║                                                            ║
║   Claude Code Skill - 一键发布到 GitHub                    ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
`);

// 获取 Claude Code skills 目录
function getSkillsDir() {
  const home = os.homedir();
  return path.join(home, '.claude', 'skills');
}

// 获取 skill 安装目录
function getSkillInstallDir() {
  const skillsDir = getSkillsDir();
  return path.join(skillsDir, 'skill-publisher');
}

// 检查是否在开发环境中
function isDevelopment() {
  return __dirname.includes('skill-publisher');
}

// 显示安装信息
function showInstallInfo() {
  const skillsDir = getSkillsDir();
  const installDir = getSkillInstallDir();

  console.log('📂 安装位置:');
  console.log(`   Skills 目录: ${skillsDir}`);
  console.log(`   Skill 目录: ${installDir}`);
  console.log('');
}

// 检查必要工具
function checkTools() {
  console.log('🔍 检查必要工具...\n');

  let hasGit = false;
  let hasGh = false;

  try {
    execSync('git --version', { stdio: 'pipe' });
    console.log('✓ Git 已安装');
    hasGit = true;
  } catch {
    console.warn('⚠️  未检测到 Git');
    console.log('   请安装: https://git-scm.com/downloads\n');
  }

  try {
    execSync('gh --version', { stdio: 'pipe' });
    console.log('✓ GitHub CLI 已安装');
    hasGh = true;
  } catch {
    console.warn('⚠️  未检测到 GitHub CLI');
    console.log('   安装命令:');
    console.log('     Windows: winget install --id GitHub.cli');
    console.log('     macOS:   brew install gh');
    console.log('     Linux:   sudo apt install gh\n');
  }

  try {
    execSync('gh auth status', { stdio: 'pipe' });
    console.log('✓ GitHub CLI 已登录\n');
  } catch {
    console.warn('⚠️  未登录 GitHub');
    console.log('   请运行: gh auth login\n');
  }

  return hasGit && hasGh;
}

// 配置别名
function setupAliases() {
  const home = os.homedir();
  const bashrc = path.join(home, '.bashrc');
  const zshrc = path.join(home, '.zshrc');

  // 别名配置
  const aliases = `
# Skill Publisher 别名
alias push-skill='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias init-skill-repo='bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh'
alias check-skills='bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh'
alias batch-push='bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh'

# 中文别名
alias 推送='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 推送技能='bash ~/.claude/skills/skill-publisher/scripts/push-skill.sh'
alias 初始化技能仓库='bash ~/.claude/skills/skill-publisher/scripts/init-skill-repo.sh'
alias 检查技能='bash ~/.claude/skills/skill-publisher/scripts/check-skills.sh'
alias 批量推送='bash ~/.claude/skills/skill-publisher/scripts/batch-push.sh'
`;

  // 配置 .bashrc
  if (fs.existsSync(bashrc)) {
    const bashrcContent = fs.readFileSync(bashrc, 'utf8');
    if (!bashrcContent.includes('Skill Publisher 别名')) {
      fs.appendFileSync(bashrc, aliases);
      console.log('✓ 已添加别名到 ~/.bashrc');
      console.log('  请运行: source ~/.bashrc\n');
    } else {
      console.log('✓ 别名已配置\n');
    }
  }

  // 配置 .zshrc
  if (fs.existsSync(zshrc)) {
    const zshrcContent = fs.readFileSync(zshrc, 'utf8');
    if (!zshrcContent.includes('Skill Publisher 别名')) {
      fs.appendFileSync(zshrc, aliases);
      console.log('✓ 已添加别名到 ~/.zshrc');
      console.log('  请运行: source ~/.zshrc\n');
    }
  }
}

// 显示使用说明
function showUsage() {
  console.log('📚 快速开始:\n');
  console.log('  命令:');
  console.log('    push-skill <name>              推送 skill 到 GitHub');
  console.log('    init-skill-repo <name>         初始化新 skill');
  console.log('    check-skills                  检查所有 skills 状态');
  console.log('    batch-push [skills]           批量推送 skills\n');

  console.log('  中文别名:');
  console.log('    推送 <name>');
  console.log('    初始化技能仓库 <name>');
  console.log('    检查技能');
  console.log('    批量推送\n');

  console.log('  示例:');
  console.log('    push-skill daily-topic-selector');
  console.log('    init-skill-repo my-new-skill');
  console.log('    check-skills');
  console.log('    batch-push\n');
}

// 主函数
function main() {
  try {
    showInstallInfo();
    checkTools();
    setupAliases();
    showUsage();

    console.log('✅ 安装完成!\n');
    console.log('📖 更多信息:');
    console.log('   https://github.com/mosslive1314-hue/skill-publisher\n');
  } catch (error) {
    console.error('安装失败:', error.message);
    process.exit(1);
  }
}

main();
