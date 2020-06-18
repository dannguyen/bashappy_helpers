function wc_datafile {
    # convenience function that counts a file's (WARNING: number of lines is NOT the same as number of "rows" in a CSV)
    # number of lines if it is plaintext, or
    # number of bytes if it is not plaintext
    for fname in "$@"; do
        ftype=$(file -b --mime-type "${fname}")
        if [[ "${ftype}" == *"text"* ]]
            then wx="$(wc -l < "${fname}")"; wy="lines"
            else wx="$(wc -c < "${fname}")"; wy="bytes"
        fi
        LC_NUMERIC=en_US printf "%'15d %s: %s\n" ${wx} ${wy} "${fname}"
    done
}

function xcel {
    # Opens file(s) into Microsoft Excel; requires Excel
    #
    # Example usage:
    #   xcel mybook.xlsx
    #   xcel mybook.xls moredata.csv
    #   xcel *.csv *.xls*
    echo "Opening ${#} file(s) in Microsoft Excel"
    for fname in "$@"; do
        printf "  %s\n" "$(wc_datafile "${fname}")"
        open -a 'Microsoft Excel' "${fname}"
    done
}

function xlibre {
    # Opens file(s) into LibreOffice Calc
    # Note: requires LibreOffice; only works on macOS
    #
    # Example usage:
    #
    #   xlibre mybook.xlsx
    #   xlibre mybook.xls moredata.csv
    #   xlibre *.csv *.xls*
    echo "Opening ${#} file(s) in LibreOffice (that's praxis!)"
    for fname in "$@"; do
        printf "  %s\n" "$(wc_datafile "${fname}")"
        open -a 'LibreOffice' "${fname}"
    done
}

