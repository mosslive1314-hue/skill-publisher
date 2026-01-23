#!/usr/bin/env node
/**
 * Skill Publisher - 主命令
 *
 * 使用方法:
 *   skill-publisher <command> [options]
 *
 * 命令:
 *   push <skill>      推送 skill 到 GitHub
 *   init <skill>      初始化 skill 并创建 GitHub 仓库
 *   check             检查所有 skills 状态
 *   batch [skills]    批量推送 skills
 *   version           显示版本信息
 *   help              显示帮助信息
 */

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

const VERSION = JSON.parse(
  fs.readFileSync(path.join(__dirname, '..', 'package.json'), 'utf8')
).version;

const SCRIPTS_DIR = path.join(__dirname, '..', 'scripts');

// 显示帮助信息
function showHelp() {
  console.log(`
Skill Publisher v${VERSION}
一键发布 Claude Code Skills 到 GitHub

使用方法:
  skill-publisher <command> [options]

命令:
  push <skill>      推送 skill 到 GitHub
  init <skill>      初始化 skill 并创建 GitHub 仓库
  check             检查所有 skills 状态
  batch [skills]    批量推送 skills
  version           显示版本信息
  help              显示帮助信息

示例:
  skill-publisher push daily-topic-selector
  skill-publisher init my-new-skill
  skill-publisher check
  skill-publisher batch
  skill-publisher batch skill1 skill2

快捷命令 (npm 安装后可用):
  push-skill <skill>        # 等同于 skill-publisher push
  init-skill-repo <skill>   # 等同于 skill-publisher init
  check-skills              # 等同于 skill-publisher check
  batch-push [skills]       # 等同于 skill-publisher batch

更多信息:
  https://github.com/mosslive1314-hue/skill-publisher
`);
}

// 执行 bash 脚本
function runScript(scriptName, args = []) {
  const scriptPath = path.join(SCRIPTS_DIR, scriptName);

  if (!fs.existsSync(scriptPath)) {
    console.error(`错误: 脚本不存在 - ${scriptPath}`);
    process.exit(1);
  }

  const bash = spawn('bash', [scriptPath, ...args], {
    stdio: 'inherit',
    env: { ...process.env, SKILL_PUBLISHER_NPM: '1' }
  });

  bash.on('close', (code) => {
    process.exit(code || 0);
  });
}

// 主函数
function main() {
  const command = process.argv[2];
  const args = process.argv.slice(3);

  switch (command) {
    case 'push':
      if (args.length === 0) {
        console.error('错误: 请提供技能名称');
        console.error('\n使用方法: skill-publisher push <skill-name>');
        process.exit(1);
      }
      runScript('push-skill.sh', args);
      break;

    case 'init':
      if (args.length === 0) {
        console.error('错误: 请提供技能名称');
        console.error('\n使用方法: skill-publisher init <skill-name>');
        process.exit(1);
      }
      runScript('init-skill-repo.sh', args);
      break;

    case 'check':
      runScript('check-skills.sh');
      break;

    case 'batch':
      runScript('batch-push.sh', args);
      break;

    case 'version':
      console.log(`Skill Publisher v${VERSION}`);
      break;

    case 'help':
    default:
      showHelp();
      break;
  }
}

main();
