### helper functions to set the tab title


function tabname {
  # Set macOS tab title to given arguments, sans directory path
  #   $ tabtitle Hello this is my new tab title
  printf "\033]1;%s\007" "$*"
}

function tadname {
    # like tabname() except show grandparent and parent subdir path
    # WARNING: the subdir component does not auto-update when changing directories
    #
    #  Example:
    #    /Users/me/projects/subname $ tabdname hello new tab name

    #  Result title:
    #    hello new tab name – ../projects/subname
    gname=$(basename "$(dirname $(pwd))")
    pname=$(basename "$(pwd)")
    if [ "$gname" = '/' ]
        then subname="/"
        else subname="../${gname}/"
    fi
    if [ "$pname" = '/' ]
        then subname="${subname}"
        else subname="${subname}${pname}/"
    fi

    tabname "$* – ${subname}"
}

# More info:
# https://superuser.com/questions/105499/change-terminal-title-in-mac-os-x/#131177
