#!/usr/bin/env bash

if [[ "$-" == *i* ]] && [ -r "$HOME/.env/keys.sh" ]; then
  # shellcheck disable=SC1090
  . "$HOME/.env/keys.sh"
fi
