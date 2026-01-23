#!/usr/bin/env node
/**
 * Skill Publisher - 推送 Skill 到 GitHub
 *
 * 使用方法:
 *   push-skill <skill-name>
 *   push-skill              # 显示帮助
 */

const { spawn } = require('child_process');
const path = require('path');

// 获取脚本目录
const SCRIPT_DIR = path.join(__dirname, '..', 'scripts');
const BASH_SCRIPT = path.join(SCRIPT_DIR, 'push-skill.sh');

// 获取命令行参数
const args = process.argv.slice(2);

// 检查是否提供了 skill 名称
if (args.length === 0) {
  console.log('错误: 请提供技能名称\n');
  console.log('使用方法: push-skill <skill-name>\n');
  console.log('示例:');
  console.log('  push-skill daily-topic-selector');
  console.log('  推送 daily-topic-selector\n');
  console.log('更多信息: https://github.com/mosslive1314-hue/skill-publisher');
  process.exit(1);
}

// 执行 bash 脚本
const bash = spawn('bash', [BASH_SCRIPT, ...args], {
  stdio: 'inherit',
  env: { ...process.env, SKILL_PUBLISHER_NPM: '1' }
});

bash.on('close', (code) => {
  process.exit(code || 0);
});

bash.on('error', (err) => {
  console.error('执行失败:', err.message);
  console.error('\n请确保:');
  console.error('  1. Git 已安装 (git --version)');
  console.error('  2. GitHub CLI 已安装 (gh --version)');
  console.error('  3. 已登录 GitHub (gh auth login)');
  process.exit(1);
});
