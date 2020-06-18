


# https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality
function gifme {
    local OPTIND o w

    HELPME="Usage: \
    $0 INPUT_VIDEO_FILENAME  [-w SCALE_WIDTH_TO_PIXELS] [-o OUTPUT_FILENAME] \
       -w: width in number of pixels (default is to keep aspect ratio) \
       -o: output filename (default is: INPUT_VIDEO_FILENAME.gif)"

    if [ -z "$1" ]; then

      echo ${HELPME}

    else
      input_name="${1}"
      shift

      width_pixels=-1
      output_name="${input_name}.gif"
      while getopts ":o:w:" flag; do
        case "${flag}" in
          o) output_name=${OPTARG} ;;
          w) width_pixels=${OPTARG} ;;
          :)
              echo "Error: -${OPTARG} requires an argument."
              echo ${HELPME}
              ;;
          *)
              echo ${HELPME}
              ;;
        esac
      done

      echo "Reading from: ${input_name}"
      echo "Scale to width: ${width_pixels}"
      echo "Writing to: ${output_name}"

      ffmpeg -i "${input_name}"  \
      -filter_complex "fps=30,scale=${width_pixels}:-1:flags=lanczos[x];[x]split[x1][x2]; [x1]palettegen[p];[x2][p]paletteuse" \
      ${output_name}


  fi
}

