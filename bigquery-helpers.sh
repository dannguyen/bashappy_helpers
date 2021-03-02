function bq-query {
    # copy query from stdin
    query=$(cat; echo EOF)

    # print query to stderr
    query=${query%EOF}
    >&2 printf "\033[0;32mQuery:\n%s\n\033[0m" "$query"

    #############
    # send to bq
    echo "$query" \
        | bq query --format=csv --use_legacy_sql=false --max_rows=999999999
}


# https://stackoverflow.com/questions/32363887/in-a-bash-function-how-do-i-get-stdin-into-a-variable
