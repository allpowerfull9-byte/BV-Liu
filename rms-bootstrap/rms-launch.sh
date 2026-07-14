#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

PRIVATE_BOOTSTRAP_REPO="allpowerfull9-byte/shx-ai-ops-hub"
TARGET_REPO="allpowerfull9-byte/rms-apparel-ai-os"
TARGET_PROJECT="rms-apparel-ops-tw"
WORK="${HOME}/rms-authorized-bootstrap"
LOG="${HOME}/rms-launch-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG") 2>&1

say(){ printf '\n[RMS] %s\n' "$*"; }
die(){ printf '\n[RMS FAIL] %s\n' "$*" >&2; exit 1; }

say "銳蒙斯獨立系統授權後自動部署啟動"
command -v gcloud >/dev/null || die "Cloud Shell 缺少 gcloud"
command -v git >/dev/null || die "Cloud Shell 缺少 git"

if [[ -z "$(gcloud auth list --filter=status:ACTIVE --format='value(account)' | head -1 || true)" ]]; then
  say "請在 Google 官方頁面完成登入授權"
  gcloud auth login --update-adc
fi

if ! gcloud auth application-default print-access-token >/dev/null 2>&1; then
  say "請完成 Google 應用程式部署授權"
  gcloud auth application-default login
fi

if ! command -v gh >/dev/null; then
  say "安裝 GitHub CLI"
  sudo apt-get update -qq
  sudo apt-get install -y gh
fi

if ! gh auth status >/dev/null 2>&1; then
  say "請在 GitHub 官方頁面完成授權"
  gh auth login -w -h github.com -p https
fi

say "取得銳蒙斯私人部署來源"
rm -rf "$WORK"
gh repo clone "$PRIVATE_BOOTSTRAP_REPO" "$WORK"
cd "$WORK"
[[ -s bootstrap/RMS-AUTH-DEPLOY.sh ]] || die "私人部署來源不完整"
chmod +x bootstrap/RMS-AUTH-DEPLOY.sh

export RMS_PROJECT_ID="$TARGET_PROJECT"
export RMS_GITHUB_REPO="$TARGET_REPO"
export RMS_REGION="asia-east1"

say "授權完成，開始全自動建立、部署、修復與驗收"
exec bash bootstrap/RMS-AUTH-DEPLOY.sh
