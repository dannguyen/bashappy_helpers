#!/bin/bash

# First, we must resolve the parent directory of main.sh
# more info:
# https://stackoverflow.com/a/246128/160863
_BASHAPPY_HELPERS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
_BASHAPPY_HELPERS_SUBSCRIPTS=(
    gifme.sh
    sheetcuts.sh
    tabname.sh
    tabstyle.sh
)

export _BASHAPPY_HELPERS_DIR
export _BASHAPPY_HELPERS_SUBSCRIPTS


function bashappy_helpers_info {
    printf '%s\n\t%s\n' "bashappy home directory:" "${_BASHAPPY_HELPERS_DIR}"
    echo "bashappy loaded scripts:"
    for fname in "${_BASHAPPY_HELPERS_SUBSCRIPTS[@]}"; do
        fpath="${_BASHAPPY_HELPERS_DIR}/${fname}"
        printf "\t%s\n" "${fpath}"
    done
}


function bashappy_helpers_load {
    for fname in "${_BASHAPPY_HELPERS_SUBSCRIPTS[@]}"; do
        fpath="${_BASHAPPY_HELPERS_DIR}/${fname}"
        source "$fpath"
    done
}


bashappy_helpers_load
