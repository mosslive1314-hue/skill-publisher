#!/usr/bin/env node
/**
 * Skill Publisher - 安装后脚本
 *
 * 在 npm install 后自动执行，用于配置环境
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

const VERSION = JSON.parse(
  fs.readFileSync(path.join(__dirname, '..', 'package.json'), 'utf8')
).version;

console.log(`
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║   Skill Publisher v${VERSION}                              ║
║                                                            ║
║   一键发布 Claude Code Skills 到 GitHub                    ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
`);

// 检查必要工具
function checkTools() {
  const { spawnSync } = require('child_process');

  console.log('🔍 检查必要工具...\n');

  // 检查 Git
  const git = spawnSync('git', ['--version'], { shell: true });
  if (git.status !== 0) {
    console.warn('⚠️  警告: 未检测到 Git');
    console.log('   请安装 Git: https://git-scm.com/downloads\n');
  } else {
    console.log('✓ Git 已安装');
  }

  // 检查 GitHub CLI
  const gh = spawnSync('gh', ['--version'], { shell: true });
  if (gh.status !== 0) {
    console.warn('⚠️  警告: 未检测到 GitHub CLI');
    console.log('   请安装 GitHub CLI:');
    console.log('     Windows: winget install --id GitHub.cli');
    console.log('     macOS:   brew install gh');
    console.log('     Linux:   apt install gh\n');
  } else {
    console.log('✓ GitHub CLI 已安装');
  }

  // 检查登录状态
  const auth = spawnSync('gh', ['auth', 'status'], { shell: true, stdio: 'pipe' });
  if (auth.status !== 0) {
    console.warn('⚠️  未登录 GitHub');
    console.log('   请运行: gh auth login\n');
  } else {
    console.log('✓ GitHub CLI 已登录');
  }
}

// 显示快速开始指南
function showQuickStart() {
  console.log('\n📚 快速开始:\n');
  console.log('  命令:');
  console.log('    push-skill <name>              推送 skill 到 GitHub');
  console.log('    init-skill-repo <name>         初始化新 skill');
  console.log('    check-skills                  检查所有 skills 状态');
  console.log('    batch-push [skills]           批量推送 skills');
  console.log('    skill-publisher <command>      主命令 (见下文)\n');

  console.log('  示例:');
  console.log('    push-skill daily-topic-selector');
  console.log('    init-skill-repo my-new-skill');
  console.log('    check-skills');
  console.log('    batch-push');
  console.log('    batch-push skill1 skill2\n');

  console.log('  主命令:');
  console.log('    skill-publisher push <skill>');
  console.log('    skill-publisher init <skill>');
  console.log('    skill-publisher check');
  console.log('    skill-publisher batch [skills]');
  console.log('    skill-publisher version');
  console.log('    skill-publisher help\n');

  console.log('  更多信息:');
  console.log('    https://github.com/mosslive1314-hue/skill-publisher\n');
}

// 主函数
function main() {
  try {
    checkTools();
    showQuickStart();

    console.log('✅ 安装完成!\n');
  } catch (error) {
    console.error('安装后脚本执行失败:', error.message);
    process.exit(1);
  }
}

main();
