# the following env variables have to be defined:
# DOTFILES

function mklink { cmd /c mklink $args }

oh-my-posh init pwsh --config "$DOTFILES\oh-my-posh\.oh-my-posh_theme.json" | Invoke-Expression

# load fzf
Import-Module PSFzf

# Override PSReadLine's history search
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' `
                -PSReadlineChordReverseHistory 'Ctrl+r'

# Override default tab completion
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }


# Aliases
Set-Alias -Name v -Value nvim

Function list_all { Get-ChildItem -Force }
Set-Alias -Name ll -Value list_all

Function cd_to_c { Set-Location -Path C:\ }
Set-Alias -Name cdc -Value cd_to_c

Function reload_config { . $PROFILE }
Set-Alias -Name rcsrc -Value reload_config

Function online_manual { param ( $Command ) help $Command -Online }
Set-Alias -Name mano -Value online_manual

$env:PATHEXT = "$env:PATHEXT;.bat"

$projects_file = "$DOTFILES/projects.txt"
$name_dir_separator = " -> "
Function fzf_projects_cd { param ( $Query )
    if ($PSBoundParameters.ContainsKey('Query')) {
        $rg_query = "$Query.*$name_dir_separator"

        $result = (rg "$rg_query" $projects_file)

        $lines = (echo $result | Measure-Object -line).Lines
        if ($lines -ne 1) {
            $directory = $result | fzf -q "$Query"
        } else {
            $directory = $result
        }
    } else {
        $directory = cat "$projects_file" | fzf
        if ("$directory" -match "^\$") {
            $directory = Invoke-Expression -Command "`"$directory`""
        }
    }

    if ($directory -eq $null) {
        echo "Nothing chosen."
        return # fzf was probably escaped
    }

    echo $directory
    cd $directory.split($name_dir_separator)[1]
}
Set-Alias -Name pcd -Value fzf_projects_cd

Function fzf_projects_add { param ( $Name, $Dir )
    if ($Dir -eq $null -or $Dir -eq "" -or $Dir -eq ".") {
        $Dir = pwd
    }
    if ($Name -eq $null) {
        $Name = Split-Path $Dir -Leaf # Assuming that a directory is given
    }
    "$Name$name_dir_separator$Dir" >> "$projects_file"
}
Set-Alias -Name padd -Value fzf_projects_add
