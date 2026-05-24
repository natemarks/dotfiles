#!/usr/bin/env bash
set -euo pipefail

main() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Error: Not a git repository"
    exit 1
  fi

  if ! git remote get-url origin >/dev/null 2>&1; then
    echo "❌ Error: No 'origin' remote configured"
    exit 1
  fi

  local current_url
  current_url=$(git remote get-url origin)

  echo "Current remote URL: $current_url"

  if [[ "$current_url" =~ ^https:// ]]; then
    echo "✅ Already using HTTPS - no conversion needed"
    echo ""
    echo "Testing HTTPS authentication..."

    if git ls-remote origin HEAD >/dev/null 2>&1; then
      echo "✅ HTTPS authentication successful!"
      exit 0
    else
      echo "❌ HTTPS authentication failed"
      echo ""
      echo "Your credentials may not be configured correctly."
      echo "If using GitHub, ensure your Personal Access Token is stored."
      exit 1
    fi
  fi

  local https_url=""

  if [[ "$current_url" =~ ^git@([^:]+):(.+)$ ]]; then
    local host="${BASH_REMATCH[1]}"
    local repo_path="${BASH_REMATCH[2]}"
    https_url="https://${host}/${repo_path}"
  elif [[ "$current_url" =~ ^ssh://git@([^/]+)/(.+)$ ]]; then
    local host="${BASH_REMATCH[1]}"
    local repo_path="${BASH_REMATCH[2]}"
    https_url="https://${host}/${repo_path}"
  else
    echo "⚠️  Warning: Remote URL is not SSH format"
    echo "Supported formats: git@host:path or ssh://git@host/path"
    echo "Cannot convert URL: $current_url"
    exit 1
  fi

  echo "Converting to HTTPS..."
  echo "New URL: $https_url"

  git remote set-url origin "$https_url"

  local actual_url
  actual_url=$(git remote get-url origin)

  if [[ "$actual_url" != "$https_url" ]]; then
    echo "❌ Error: URL was not changed correctly"
    echo "Expected: $https_url"
    echo "Actual: $actual_url"
    exit 1
  fi

  echo ""
  echo "✅ Successfully converted remote to HTTPS"
  echo ""
  echo "Testing HTTPS authentication..."

  if git ls-remote origin HEAD >/dev/null 2>&1; then
    echo "✅ HTTPS authentication successful!"
  else
    echo "❌ HTTPS authentication failed"
    echo ""
    echo "Your credentials may not be configured correctly."
    echo "If using GitHub, ensure your Personal Access Token is stored."
    exit 1
  fi
}

main "$@"
