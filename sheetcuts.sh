function xcel {
    # Opens file(s) into Microsoft Excel
    # Note: requires Microsoft Excel;  only works on macOS
    #
    # Example usage:
    #
    # $ xcel mybook.xlsx
    # $ xcel *.xls*
    # $ xcel *.csv
    echo "Attempting to open ${#} file(s) in Microsoft Excel"
    for fname in "$@"; do
        printf "\t%s\n" "${fname}"
        open -a 'Microsoft Excel' "${fname}"
    done
}

function xlibre {
    # Opens file(s) into LibreOffice Calc
    # Note: requires LibreOffice; only works on macOS
    #
    # Example usage:
    #
    # $ xlibre mybook.xlsx
    # $ xlibre *.csv
    echo "Attempting to open ${#} file(s) in LibreOffice (that's praxis!)"
    for fname in "$@"; do
        printf "\t%s\n" "${fname}"
        open -a 'LibreOffice' "${fname}"
    done
}
