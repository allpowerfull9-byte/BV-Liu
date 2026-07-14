#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

PRIVATE_BOOTSTRAP_REPO="allpowerfull9-byte/shx-ai-ops-hub"
WORK="${HOME}/.rms-independent-bootstrap"

say(){ printf '\n\033[1;36m[RMS]\033[0m %s\n' "$*"; }
die(){ printf '\033[1;31m[FAIL]\033[0m %s\n' "$*" >&2; exit 1; }

say "銳蒙斯獨立系統授權入口"
say "你只需要在官方頁面登入並按允許；其餘由自動流程執行。"

if ! command -v gh >/dev/null 2>&1; then
  say "安裝 GitHub 官方 CLI"
  sudo apt-get update -qq
  sudo apt-get install -y gh >/dev/null
fi

if ! gh auth status >/dev/null 2>&1; then
  say "請完成 GitHub 官方登入授權"
  gh auth login --web --git-protocol https
fi

gh auth status >/dev/null 2>&1 || die "GitHub 授權尚未完成"

rm -rf "$WORK"
say "取得私人 RMS 部署啟動庫"
gh repo clone "$PRIVATE_BOOTSTRAP_REPO" "$WORK"
cd "$WORK"

test -s bootstrap/RMS-AUTH-DEPLOY.sh || die "私人啟動器不存在"
chmod +x bootstrap/RMS-AUTH-DEPLOY.sh
exec bash bootstrap/RMS-AUTH-DEPLOY.sh
