#!/usr/bin/env bash
# https://gist.github.com/natemarks/aebb7e84010d4bc37270d554106cb38b
set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT


usage() {
  cat <<EOF
Usage: decrypt [-h] [-v] [-f] arg1 [arg2...]

Decrypt an encrypted file with a .gpg extension to the same location with the
.gpg extension stripped. It will exit if the destination file already exists
unless the --force option is used.

example - overwrite dd.txt:
symm_decrypt.sh --force ./dd.txt.gpg

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-f, --force     Force overwrite of destination file
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    # shellcheck disable=SC2034
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  force="FALSE"

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -xv ;;
    --no-color) NO_COLOR=1 ;;
    -f | --force) force="TRUE" ;; # example flag
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

  return 0
}

parse_params "$@"
setup_colors


TARGET="${args[0]}"
ABSTARGET="$(realpath "${TARGET}")"
CLEAR=${ABSTARGET%".gpg"}

# fail if the target encrypted file does not exist
if [ ! -f "${ABSTARGET}" ]; then
  echo "file not found: ${ABSTARGET}"
  exit 1
fi

# fail if the target encrypted file does not have a .gpg extension becuase
# we won't know what to name the new decrypted file
if [ -n "${TARGET##*.gpg}" ]; then
  echo "invalid filename: ${ABSTARGET} does not have a .gpg extension"
  exit 2
fi

# don't overwrite an existing decrypted file without --force
if [ -f "${CLEAR}" ] && [ "${force}" != "TRUE" ] ; then
  echo "file exists: ${CLEAR}. Use --force to overwrite"
  exit 3
fi

if [ -f "${CLEAR}" ] ; then
  msg "OVERWRITE: ${ABSTARGET} ==> ${CLEAR}"
else
  msg "CREATE: ${ABSTARGET} ==> ${CLEAR}"
fi

gpg --decrypt --output "${CLEAR}" "${ABSTARGET}"