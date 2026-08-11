# takes space separated list of key=val paris and translates
# key=val pairs to $key=val variables
#
# useful for doing something like:
#
# ./script foo=bar
#
# and then $foo is assigned to "bar" in the script
translate_key_vals_to_variables(params)
{
    # have to use the -g flag to use the variables outside
    # of this function scope. AFAIU they get cleaned up after
    # the caller script finishes.
    for arg in "${params}"; do
        case "$arg" in
            *=*) declare -g "${arg%%=*}=${arg#*=}" ;;
        esac
    done
}
