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
zstyle ':completion:*' menu select                              # Tab selection
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
#zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"        # Colors for tab completion with CD
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Prompt
NEWLINE=$'\n' # Create newline variable
[ -n "$SSH_CLIENT" ] && HNC="red" || HNC="blue"
PS1="%{$fg[green]%}%n%{$reset_color%} in %{$fg[cyan]%}% %~ %{$reset_color%}% at %{$fg[$HNC]%}%m %{$reset_color%}% %{$fg[green]%}% $NEWLINE→ "

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
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[A" up-line-or-beginning-search      # Up in history
bindkey "^[[B" down-line-or-beginning-search    # Down in history
bindkey "^[[Z" reverse-menu-complete            # [Shift+Tab] Move back in completion

# Tmux
alias tmuxn='tmux new-session -s $$'
_trap_exit() { tmux kill-session -t $$; }
trap _trap_exit EXIT
# If not using kitty, run tmux on startup if not already running
[ "$TERM" != "xterm-kitty" ] && [ "$TERM" != "tmux-256color" ] && tmuxn

# Source external files
source ~/.config/aliasrc

# Load plugins
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 2>/dev/null
