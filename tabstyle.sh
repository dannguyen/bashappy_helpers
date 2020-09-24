# helper functions for changing the styles of a Terminal tab,
#    e.g. background color and theme


# Helpful resources:
# https://superuser.com/questions/1188772/mac-command-to-change-the-background-color-in-a-terminal
# https://apple.stackexchange.com/questions/348762/how-to-have-a-random-background-color-in-terminal-app
# https://stackoverflow.com/questions/8063228/how-do-i-check-if-a-variable-exists-in-a-list-in-bash



tabbg(){
    # run `tabbg` with no arguments to get the help message
    # Note: tabbg requires osascript, i.e. MacOS
    local OCMD=""
    local RED=0; local GRN=0; local BLU=0;
    local HELPMSG; read -r -d '' HELPMSG <<EOF

tabbg:

    a bash function (using AppleScript) to change the theme or background
    color of MacOS Terminal

Sample usage:

    tabbg help                # print this help message

    tabbg 42 255 120          # change background to rgb(42, 255, 120)

    tabbg rand                # random background color

    tabbg x                   # change background to preset of "x"
                              # Available presets:
                              #   x (my xtra favorite preset)
                              #   b (dark bluish)
                              #   g (greenish, great for python)
                              #   l (light lavender)
                              #   r (burnt red, great for ruby)---
EOF


    # do a random rgb value; note that we don't normalize to 255
    if [[ "$1" == "rand" ]]; then
        RED=$((2000 + RANDOM % 21000))
        GRN=$((2000 + RANDOM % 21000))
        BLU=$((2000 + RANDOM % 21000))
    # otherwise, check if first arg is a rgb preset
    elif [[ "$1" == "x" ]]; then
        RED=11000; GRN=14000; BLU=20000  # 'x' is my fav
    elif [[ "$1" == "b" ]]; then
        RED=5000;  GRN=5000; BLU=15000   # 'b' is dark bluish
    elif [[ "$1" == "l" ]]; then
        RED=23000; GRN=16000; BLU=27000  # 'l' is some light lavender fun
    elif [[ "$1" == "g" ]]; then
        RED=9000;  GRN=20000; BLU=11000  # 'g' is python time
    elif [[ "$1" == "r" ]]; then
        RED=18000;  GRN=7000; BLU=8000   # 'r' is ruby time

    # if there are 0 arguments, or the 1st argument is unrecognized AND is non-numeric
    #     then don't change anything, but do print a help message
    elif [[ -z $1 || -n ${1//[0-9]/} || $1 -lt 0 ]]; then
        >&2 echo "$HELPMSG"
        return 0

    # else, interpret it as a list of RGB values, expressed as integers from 0 to 255
    else
        [[ "$1" -gt 0 && "$1" -le 255 ]] && RED=$(($1*65535/255)) || RED=0 ;
        [[ "$2" -gt 0 && "$2" -le 255 ]] && GRN=$(($2*65535/255)) || GRN=0 ;
        [[ "$3" -gt 0 && "$3" -le 255 ]] && BLU=$(($3*65535/255)) || BLU=0 ;
    fi


    if [[ -z "$OCMD" ]]; then
        OCMD="tell application \"Terminal\" to set background color of window 1 to {$RED, $GRN, $BLU}"
    fi
    # tell user what's going on via stderr
    >&2 echo "#  $OCMD"
    osascript -e "${OCMD}"
}

tabth(){
    # run `tabth` with no arguments to get the help message
    # Note: tabbg requires osascript, i.e. MacOS
    local OCMD=""
    local THEMES=(pro basic grass homebrew ocean) ## preset themes
    local THEMECOUNT=${#THEMES[@]}
    local HELPMSG; read -r -d '' HELPMSG <<EOFX

tabth:

    a bash function (using AppleScript) to change the macOS Terminal theme

Sample usage:

    tabth help                # print this help message


    tabth rand                # random theme
    tabth grass               # use the "grass" Terminal theme
                              # ${THEMECOUNT} available themes:
$(printf '                              # - %s\n' ${THEMES[@]})
---
EOFX


    # if first argument matches a $THEMES name, then ignore other args, and change terminal theme
    if [[ "$1" == "rand" ]]; then
        tidx=$((RANDOM % ${THEMECOUNT}))
        themename=${THEMES[${tidx}]}
    elif [[ " ${THEMES[@]} " =~ " ${1} " ]]; then
        # if first and only argument matches a preset theme name, e.g. 'grass'
        # more info: https://stackoverflow.com/a/15394738/160863
        themename="${1}"
    else
        >&2 echo "$HELPMSG"
        return 0
    fi

    OCMD="tell application \"Terminal\" to set current settings of window 1 to settings set \"$themename\""


    >&2 echo "#  $OCMD"
    osascript -e "${OCMD}"

}



function tabc {
  # 2020-09-24
  # sloppy hack combining tabbg and tabname, to allow for:

  #    $ tabc '42 255 120' this is my tab name

  # the first arg goes to tabbg and MUST be quoted

  tabbg "${1}"
  # this basically copies tabname(), because I don't know how to import that function for now
  printf "\033]1;%s\007" "${*:2}"
}
