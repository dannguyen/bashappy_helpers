
# https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality
# https://trac.ffmpeg.org/wiki/How%20to%20speed%20up%20/%20slow%20down%20a%20video
function gifme {
    # Note: gifme requires ffmpeg
    local HELPMSG; read -r -d '' HELPMSG <<EOF
gifme:
  Quickie conversion of a movie file to GIF; requires ffmpeg and the relevant codecs

  Usage:
    $ gifme INPUT_PATH [-OPTIONS]

  Options:
       -f: frames per second; default is ${DEFAULT_FPS}
       -o: output filename; default is: gifme-INPUT_PATH.gif
       -s: speedup/slowdown factor; 1.1 to 10 for 1.1x to 10x faster; use values from 0.1 to <1.0 to slow down
       -w: width in number of pixels; default is ${DEFAULT_PX_WIDTH}, i.e. keep aspect ratio

  Example:

    $ gifme ~/Downloads/mymovie.mp4 -w 200 -f 15 -s 2

      creates a GIF that is 200-pixels wide,
        15 frames per second, 2x speed, and saves it
        to: ~/Downloads/gifme-mymovie.mp4.gif
EOF

    local OPTIND f o w
    local CONFIGMSG
    local FFCMD

    local DEFAULT_FPS=30
    local DEFAULT_PX_WIDTH=-1
    local DEFAULT_SPEEDUP=1

    if [ -z "$1" ]; then
        >&2 echo "$HELPMSG"
        return 0
    else
      # First, parse the input filename, i.e the first argument
      input_name="${1}"
      input_dir="$(dirname "${input_name}")"
      input_fname="$(basename "${input_name}")"

      # derive the default output_name
      output_name="${input_dir}/gifme-${input_fname}.gif"
      shift

      # then figure out optional parameters
      fps=$DEFAULT_FPS
      speedfactor=$DEFAULT_SPEEDUP
      width_pixels=$DEFAULT_PX_WIDTH


      while getopts ":f:o:s:w:" flag; do
        case "${flag}" in
          f) fps=${OPTARG};;
          o) output_name=${OPTARG} ;;
          s) speedfactor=${OPTARG} ;;
          w) width_pixels=${OPTARG} ;;
          :)
              >&2  echo "Error: -${OPTARG} requires an argument."
              >&2  echo ""
              >&2  echo "${HELPMSG}"
              return 0
              ;;
          *)
              >&2 echo "Unrecognized argument: ${OPTARG}"
              >&2 echo ""
              >&2 echo "${HELPMSG}"
              return 0
              ;;
        esac
      done

      # very easy to accidentally pass in a second argument as output file, e.g.
      #  $ gifme mymovie.mp4 mymovie.gif  (instead of -o mymovie.gif)
      # We want to error out in that situation
      shift $(( OPTIND - 1 ))
      if [ "$#" -ne 0 ]; then
        >&2 printf '%s\n%s\n' "ERROR!" "Received $# unexpected argument(s): $*"
        >&2 printf '%s\n  %s\n' 'Expected usage:' '$ gifme INPUT_PATH [-OPTIONS]'
        return 0
      fi


  read -r -d '' CONFIGMSG <<EOF
-----
  Input path:        ${input_name}
  Frames per second: ${fps}
  Speed factor:      ${speedfactor}
  Scaled width:      ${width_pixels}px
  Output path:       ${output_name}
EOF
>&2 echo "$CONFIGMSG"


  read -r -d '' FFCMD << EOFCMD
ffmpeg -hide_banner -loglevel warning -stats -y \\
    -filter_complex "minterpolate='mi_mode=mci:mc_mode=aobmc:vsbmc=1:fps=${fps}',setpts=PTS/${speedfactor},scale=${width_pixels}:-1:flags=lanczos[x];[x]split[x1][x2];\\
    [x1]palettegen[p];[x2][p]paletteuse" \\
    -i "${input_name}"  \\
    "${output_name}"
EOFCMD

    >&2 printf "\nStarting up ffmpeg...\n"
    >&2 printf "\n%s\n\n" "${FFCMD}"

    eval "${FFCMD}"


    >&2 echo "Leaving gifme..."
    >&2 echo "$CONFIGMSG"
  fi
}

