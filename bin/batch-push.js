#!/usr/bin/env node
/**
 * Skill Publisher - 批量推送多个 Skills
 *
 * 使用方法:
 *   batch-push                    # 推送所有已初始化的 skills
 *   batch-push <skill1> <skill2>  # 推送指定的 skills
 */

const { spawn } = require('child_process');
const path = require('path');

const SCRIPT_DIR = path.join(__dirname, '..', 'scripts');
const BASH_SCRIPT = path.join(SCRIPT_DIR, 'batch-push.sh');

const args = process.argv.slice(2);

const bash = spawn('bash', [BASH_SCRIPT, ...args], {
  stdio: 'inherit',
  env: { ...process.env, SKILL_PUBLISHER_NPM: '1' }
});

bash.on('close', (code) => {
  process.exit(code || 0);
});
