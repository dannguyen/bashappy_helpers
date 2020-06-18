### helper functions to set the Terminal tab title

# More info:
# https://superuser.com/questions/105499/change-terminal-title-in-mac-os-x/#131177
# https://apple.stackexchange.com/questions/139807/what-does-update-terminal-cwd-do-in-the-terminal-of-os-x

# Note that iPython by default screws with the terminal title, so you have to manually configure it not to do that
# https://stackoverflow.com/questions/40046913/stop-ipython-from-changing-terminal-title

# Note that some manual tweaking of Terminal tab preferences is required. I'd do it in
# Applescript but AppleScript references are f****ing terrible and inadequate

function tabname {
  # Set macOS Terminal tab title to given arguments
  #
  #  $ tabname Hello this is my new tab title
  printf "\033]1;%s\007" "${*}"
}



function tadname {
    # Like tabname() except show grandparent and parent subdir path
    #
    #  Example:
    #    /Users/me/projects/subname $ tabdname hello new tab name
    #  Result title:
    #    hello new tab name – ../projects/subname

    #  Note: By default, the parent Terminal reflects the subdirectory of the
    #   currently active tab, thus making this function kind of redundant? why did i even try :(
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

