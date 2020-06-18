function xcel {
        echo "Opening '$1' in Microsoft Excel..."
        open -a 'Microsoft Excel' $1
}

function libxl {
        echo "Opening '${1}' in LibreOffice, that's praxis"
        open -a 'LibreOffice' "${1}"
}
