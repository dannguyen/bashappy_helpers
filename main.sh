#!/bin/bash

# First, we must resolve the parent directory of main.sh
_CUSTOM_BASH_FUNCS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export _CUSTOM_BASH_FUNCS_DIR
# more info:
# https://stackoverflow.com/a/246128/160863
_CUSTOM_BASH_FUNCS_SUBSCRIPTS=(
    gifme.sh
    sheetcuts.sh
    tabname.sh
    tabstyle.sh
)
export _CUSTOM_BASH_FUNCS_SUBSCRIPTS


function bash_custom_functions_info {
    echo "Home directory: ${_CUSTOM_BASH_FUNCS_DIR}"
    echo "Scripts loaded:"
    for fname in "${_CUSTOM_BASH_FUNCS_SUBSCRIPTS[@]}"; do
        fpath="${_CUSTOM_BASH_FUNCS_DIR}/${fname}"
        printf "\t%s\n" "${fpath}"
    done
}


function bash_custom_functions_load {
    for fname in "${_CUSTOM_BASH_FUNCS_SUBSCRIPTS[@]}"; do
        fpath="${_CUSTOM_BASH_FUNCS_DIR}/${fname}"
        source ${fpath}
    done
}


bash_custom_functions_load
