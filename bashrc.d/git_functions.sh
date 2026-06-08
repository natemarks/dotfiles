#!/usr/bin/env bash
# shellcheck disable=SC2148
# gwbdiff -  git working - branch diff
# compare file in git working directory to the same file in another branch
# write the branch file to a temp file
function gwbdiff() {
  local T_FILE
  local BRANCH
  local W_FILE
  T_FILE="$(mktemp)"
  BRANCH="${1}"
  W_FILE="${2}"
  git show "${BRANCH}":"${W_FILE}" > "${T_FILE}"
  printf "Comparing %s to %s" "${W_FILE}" "${T_FILE}"
  vim -d "${W_FILE}" "${T_FILE}"
}

function git_diff() {
  git diff --word-diff=color --word-diff-regex=. "$1" "$2"
}

# Fix github.com SSH remote to use github-natemarks host alias
function fix_github_remote() {
  local remote_name="${1:-origin}"
  local current_url

  current_url=$(git remote get-url "$remote_name" 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error: Remote '$remote_name' not found"
    return 1
  fi

  # Check if it's a github.com/natemarks remote
  if ! echo "$current_url" | grep -qE "github\.com[:/]natemarks"; then
    echo "Error: Remote '$remote_name' is not a github.com/natemarks repository"
    echo "Current URL: $current_url"
    return 1
  fi

  # Extract repo name from URL (handles both git@github.com:user/repo.git and https://github.com/user/repo.git)
  local repo_name
  repo_name=$(echo "$current_url" | sed -E 's#.*[:/]natemarks/##' | sed 's/\.git$//')

  local new_url="git@github-natemarks:natemarks/${repo_name}.git"

  echo "Updating remote '$remote_name':"
  echo "  From: $current_url"
  echo "  To:   $new_url"

  git remote set-url "$remote_name" "$new_url"

  if [ $? -eq 0 ]; then
    echo "✓ Successfully updated remote"
    echo ""
    echo "Verify with: git remote -v"
  else
    echo "✗ Failed to update remote"
    return 1
  fi
}
