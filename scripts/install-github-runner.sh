#!/usr/bin/env zsh
set -euo pipefail

if [[ $# -ne 2 ]]; then
  print "Usage: $0 <owner> <repo>" >&2
  exit 64
fi

owner="$1"
repo="$2"
runner_dir="${RUNNER_DIR:-$HOME/actions-runner-$repo}"
runner_version="${RUNNER_VERSION:-2.329.0}"
runner_archive="actions-runner-osx-arm64-${runner_version}.tar.gz"
runner_url="https://github.com/actions/runner/releases/download/v${runner_version}/${runner_archive}"

if ! command -v gh >/dev/null 2>&1; then
  print "GitHub CLI is required. Install with: brew install gh" >&2
  exit 69
fi

if ! gh auth status >/dev/null 2>&1; then
  print "GitHub CLI is not authenticated. Run: gh auth login" >&2
  exit 77
fi

mkdir -p "$runner_dir"
cd "$runner_dir"

if [[ ! -f config.sh ]]; then
  curl -L -o "$runner_archive" "$runner_url"
  tar xzf "$runner_archive"
fi

token="$(gh api --method POST "repos/${owner}/${repo}/actions/runners/registration-token" --jq .token)"

if [[ ! -f .runner ]]; then
  ./config.sh \
    --url "https://github.com/${owner}/${repo}" \
    --token "$token" \
    --name "$(scutil --get LocalHostName)-ios" \
    --labels "self-hosted,macOS,ios,xcode" \
    --unattended \
    --replace
fi

./svc.sh install
./svc.sh start

print "Runner installed and started for ${owner}/${repo}."
