pc () {
  python -c "print($1)"
}

tmux_update_display () {
    export DISPLAY="$(tmux show-env | grep ^DISPLAY | sed -n 's/^DISPLAY=//p')"
}

put_first_in_path () {
    stripped_path=${PATH}
    new_path="$(readlink -e "${1}")"
    if [[ -z ${new_path} ]] then
        echo "${1} does not exist!"
        return
    fi
    stripped_path="$(sed "s#${new_path}##g" <<< "${stripped_path}" | sed 's/::/:/g')"
    export PATH="${new_path}:${stripped_path}"
}

add_to_path () {
    [[ "$PATH" == *$1* ]] || export PATH="${1}:${PATH}"
}

