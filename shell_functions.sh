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

projects_file="$DOTFILES/projects.txt"
name_dir_separator=" -> "
fzf_projects_cd () {
    directory=$(cat "${projects_file}" | fzf)
    if [[ -z ${directory} ]] then
        return # fzf was probably escaped
    fi
    dir=$(echo "${directory}" | awk -F"${name_dir_separator}" '{print $2}')
    cd "${dir}"
}

fzf_projects_add () {
    name=${1}
    dir=${2}
    if [[ -z ${dir} || ${dir} = "." ]] then
        dir=$(pwd)
    fi
    if [[ -z ${name} ]] then
        name="$(basename "$dir")"
    fi
    echo "${name}${name_dir_separator}${dir}" >> "${projects_file}"
}
