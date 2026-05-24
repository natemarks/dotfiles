#!/usr/bin/env bash
set -euo pipefail

main() {
  local date_stamp
  date_stamp=$(date +%Y%m%d)

  local key_path="${HOME}/.ssh/${date_stamp}"
  local pub_path="${key_path}.pub"

  if [[ -f "$key_path" ]] || [[ -f "$pub_path" ]]; then
    echo "❌ Error: SSH key already exists for today's date"
    echo ""
    [[ -f "$key_path" ]] && echo "  Private key: $key_path"
    [[ -f "$pub_path" ]] && echo "  Public key: $pub_path"
    echo ""
    echo "Remove existing keys or wait until tomorrow to create a new one."
    exit 1
  fi

  echo "Creating new Ed25519 SSH key: $key_path"
  echo ""
  read -rp "Enter comment/email for key (e.g., your@email.com): " comment

  if [[ -z "$comment" ]]; then
    echo "❌ Error: Comment cannot be empty"
    exit 1
  fi

  echo ""
  echo "⚠️  You will be prompted for a passphrase (required, cannot be empty)"
  echo ""

  if ! ssh-keygen -t ed25519 -f "$key_path" -C "$comment"; then
    echo ""
    echo "❌ Error: ssh-keygen failed"
    exit 1
  fi

  echo ""
  echo "Verifying passphrase was set..."

  if ssh-keygen -y -P "" -f "$key_path" >/dev/null 2>&1; then
    echo "❌ Error: Key was created without a passphrase"
    echo "Removing insecure key..."
    rm -f "$key_path" "$pub_path"
    echo ""
    echo "Please run again and provide a passphrase when prompted."
    exit 1
  fi

  echo "✅ Passphrase verified"
  echo ""
  echo "Setting file permissions..."
  chmod 600 "$key_path"
  chmod 644 "$pub_path"
  echo "  Private key: 600 (owner read/write only)"
  echo "  Public key:  644 (owner read/write, others read)"
  echo ""
  echo "✅ SSH key created successfully!"
  echo ""
  echo "Private key: $key_path"
  echo "Public key:  $pub_path"
  echo ""
  echo "Public key content:"
  echo "---"
  cat "$pub_path"
  echo "---"
  echo ""
  echo "To add this key to ssh-agent:"
  echo "  ssh-add $key_path"
}

main "$@"
