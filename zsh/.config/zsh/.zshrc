# Simple zshrc meant to take all of the nice features from oh-my-zsh without installing hundreds of plugins.

# History
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt hist_verify            # show command with history expansion to user before running it
HISTFILE=~/.cache/zsh_history # Move hist file to cache dir
HISTSIZE=50000
SAVEHIST=10000

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
setopt autocd		            # Automatically cd into typed directory.
stty stop undef		            # Disable ctrl-s to freeze terminal.

# Completion
autoload -U compinit
zstyle ':completion:*' menu select                                              # Tab selection
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*' # Allow case-insensitive matching
zmodload zsh/complist
compinit
_comp_options+=(globdots)	                                                    # Include hidden files in autocompletion

# Completion colors for file/dir selection
zstyle ':completion:*:default' list-colors \
    "di=1;36" "ln=35" "so=32" "pi=33" "ex=32" "bd=34;46" "cd=34;43" \
        "su=30;41" "sg=30;46" "tw=30;42" "ow=30;43"
# Fix systemctl completion
_systemctl_unit_state() {
    typeset -gA _sys_unit_state
    _sys_unit_state=( $(__systemctl list-unit-files "$PREFIX*" | awk '{print $1, $2}') )
}

## Prompt
source $HOME/.config/zsh/shrink-path.zsh            # Fish-like directories
setopt promptsubst                                  # Re-eval commands in prompt with ''
NEWLINE=$'\n'                                       # Create newline variable
ERROR="%F{red}%(?..[%?])%f"                         # Show last command's exit code
CHAR="%F{green}→%f "                                #
#DIR="%(4~|…/%2~|%~)"                               # Set dir to only show a max depth of 2
[ -n "$SSH_CLIENT" ] && HNC="red" || HNC="magenta"  # Colorize hostname based on local/ssh
PS1='%F{green}%n%f in %F{blue}$(shrink_path -f)%f at %F{$HNC}%m%f $ERROR$NEWLINE$CHAR'

# Move/delete betweeen words and directories (delimited by /)
autoload -U select-word-style
select-word-style bash

# Check previous commands in history for partial commands
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Keybinds
bindkey -e                                      # Disables weird esc behavior
bindkey '^[[3;5~' kill-word                     # [Ctrl-Backspace] - delete word backward
bindkey '^H' backward-kill-word                 # [Ctrl-Delete] - delete word forward
bindkey '^[^?' backward-kill-word               # Alt+backspace
bindkey "^[[1;5C" forward-word                  # Navigate forward and back with ctrl/alt+arrows
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[A" up-line-or-beginning-search      # Up in history
bindkey "^[[B" down-line-or-beginning-search    # Down in history
bindkey "^[[Z" reverse-menu-complete            # [Shift+Tab] Move back in completion
bindkey "\e[3~" delete-char                     # Map delete to delete

## Tmux
# Alias to start with shell ID
alias tmuxn='tmux new-session -s $$'
# If not using kitty and not on ssh session, run tmux on startup if not already running
if [ "$TERM" != "xterm-kitty" ] && [ "$TERM" != "tmux-256color" ] && [ ! -n "$SSH_CLIENT"]; then
    # Kill tmux with terminal ID if shell is closed
    _trap_exit() { tmux kill-session -t $$; }
    trap _trap_exit EXIT
    tmuxn
fi

## Source external files
# Aliases
source ~/.config/aliasrc
# Plugins
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
