### helper functions to set the Terminal tab title

# More info:
# https://superuser.com/questions/105499/change-terminal-title-in-mac-os-x/#131177


function tabname {
  # Set macOS Terminal tab title to given arguments
  #
  #  Example:
  #   $ tabtitle Hello this is my new tab title
  printf "\033]1;%s\007" "$*"
}

function tadname {
    # Like tabname() except show grandparent and parent subdir path
    #
    #  Example:
    #    /Users/me/projects/subname $ tabdname hello new tab name
    #  Result title:
    #    hello new tab name – ../projects/subname

    #  Note: By default, the parent Terminal reflects the subdirectory of the
    #   currently active tab, thus making this function kind of redundant?
    #
    #  WARNING: the subdir component does not auto-update
    #    when changing directories

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

