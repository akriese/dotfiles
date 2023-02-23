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
