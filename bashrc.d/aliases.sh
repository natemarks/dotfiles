#!/usr/bin/env bash
# shellcheck disable=SC2148
alias do_prune_everything='docker system prune -a'

# alias fzcod='code -n $(find ~ -maxdepth 1 -type d 2>/dev/null | fzf)'
# alias fzcof='code -n $(find . -type f 2>/dev/null  | fzf)'
# alias fzged='gedit $(find ~ -maxdepth 1 -type d 2>/dev/null | fzf)'
# alias fzgef='gedit $(find . -type f 2>/dev/null  | fzf)'

alias cdh='cd $(find ~ -maxdepth 1 -type d | fzf)'
alias cdp='cd $(find ~/projects -maxdepth 2 -type d | fzf)'
# ~/go/... is a part of the deprecated GOPATH config superceded by go modules
# https://insujang.github.io/2020-04-04/go-modules/
# alias cdp='cd $(find ~/projects ~/go/src -maxdepth 2 -type d | fzf)'
alias vim='nvim'
# use vscode in current directory
alias vcc='code -n .'
# open project in vscode using fzf
alias vcp='code -n $(find ~/projects -maxdepth 2 -type d | fzf)'
# aws account aliases
alias aws_imprivata-sandbox='export AWS_PROFILE=imprivata-sandbox'
alias aws_platform-dev='export AWS_PROFILE=i-platform-dev'
alias aws_production='export AWS_PROFILE=production'
alias aws_whoami='aws sts get-caller-identity'