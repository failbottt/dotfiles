# takes space separated list of key=val paris and translates
# key=val pairs to $key=val variables
#
# useful for doing something like:
#
# ./script foo=bar baz=foo
#
# and then $foo is assigned to "bar" in the script
translate_key_vals_to_variables()
{
    for arg in "$@"; do
        case "$arg" in
            *=*) eval "${arg%%=*}=${arg#*=}" ;;
        esac
    done
}

# gets confirmation before continuing a script.
#
# y/Y are yes everything else aborts
confirm()
{
    echo ""
    read -r -p "$@ [yY]: " reply
    [[ "$reply" =~ ^[yY]$ ]] || { echo "Aborted."; exit 1; }
    echo ""
}
