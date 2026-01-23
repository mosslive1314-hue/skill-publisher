#!/usr/bin/env node
/**
 * Skill Publisher - 检查所有 Skills 的 Git 状态
 *
 * 使用方法:
 *   check-skills
 */

const { spawn } = require('child_process');
const path = require('path');

const SCRIPT_DIR = path.join(__dirname, '..', 'scripts');
const BASH_SCRIPT = path.join(SCRIPT_DIR, 'check-skills.sh');

const bash = spawn('bash', [BASH_SCRIPT], {
  stdio: 'inherit',
  env: { ...process.env, SKILL_PUBLISHER_NPM: '1' }
});

bash.on('close', (code) => {
  process.exit(code || 0);
});
