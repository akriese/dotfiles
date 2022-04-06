pc () {
  python -c "print($1)"
}

tmux_update_display() {
    export DISPLAY="$(tmux show-env | grep ^DISPLAY | sed -n 's/^DISPLAY=//p')"
}

put_first_in_path() {
    stripped_path=${PATH}
    new_path="$(readlink -e "${1}")"
    case "${PATH}" in
        *:${new_path})
            stripped_path="$(sed "s#:${new_path}##g" <<< "${stripped_path}")"
            ;&
        ${new_path}:*)
            stripped_path="$(sed "s#${new_path}:##g" <<< "${stripped_path}")"
            ;&
    esac

    export PATH="${new_path}:${stripped_path}"
}

add_to_path() {
    [[ "$PATH" == *$1* ]] || export PATH="${1}:${PATH}"
}

