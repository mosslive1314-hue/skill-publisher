#!/usr/bin/env node
/**
 * Skill Publisher - 初始化 Skill 并创建 GitHub 仓库
 *
 * 使用方法:
 *   init-skill-repo <skill-name>
 */

const { spawn } = require('child_process');
const path = require('path');

const SCRIPT_DIR = path.join(__dirname, '..', 'scripts');
const BASH_SCRIPT = path.join(SCRIPT_DIR, 'init-skill-repo.sh');

const args = process.argv.slice(2);

if (args.length === 0) {
  console.log('错误: 请提供技能名称\n');
  console.log('使用方法: init-skill-repo <skill-name>\n');
  console.log('这将:');
  console.log('  1. 初始化 Git 仓库');
  console.log('  2. 创建 .gitignore 文件');
  console.log('  3. 在 GitHub 创建远程仓库');
  console.log('  4. 首次提交并推送\n');
  console.log('示例:');
  console.log('  init-skill-repo my-new-skill');
  process.exit(1);
}

const bash = spawn('bash', [BASH_SCRIPT, ...args], {
  stdio: 'inherit',
  env: { ...process.env, SKILL_PUBLISHER_NPM: '1' }
});

bash.on('close', (code) => {
  process.exit(code || 0);
});
