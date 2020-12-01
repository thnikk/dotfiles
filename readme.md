# Personal dotfiles
The included stow\_all.sh will stow all subdirectories.

## Neovim
When launching neovim for the first time, it will automatically install all necessary plugins. You need to restart it for it to actually load the plugins.

## Firefox userchrome
Firefox userchrome and user.js are both included and symlinked to any profile folders with stow\_all.sh. You need to go to about:config and manually enable "toolkit.legacyUserProfilecustomizations.stylesheets to enable userchrome, otherwise you will see no change.


