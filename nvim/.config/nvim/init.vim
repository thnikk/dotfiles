"Remap leader to comma
let mapleader =","

"Plug setup
"Install plug if needed
if ! filereadable(expand('~/.config/nvim/autoload/plug.vim'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ~/.config/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"> ~/.config/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

"Set up plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'Yggdroot/indentLine' "Show lines at indentations
Plug 'junegunn/goyo.vim' "Shuuchuu
Plug 'preservim/nerdcommenter' "Easily comment blocks of code
Plug 'tpope/vim-surround' "Highlights quotes/brackets/parantheses
Plug 'kovetskiy/sxhkd-vim' "Syntax highlighting
Plug 'mboughaba/i3config.vim' "Syntax highlighting for i3 config
Plug 'airblade/vim-gitgutter' "Shows changes from last commit in NL gutter
Plug 'itchyny/lightline.vim' "Bottom bar
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } } "Md preview
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' } "Show colors in vim
Plug 'tpope/vim-surround' "Complete tags
Plug 'mhinz/vim-startify' "Start screen
Plug 'vim-syntastic/syntastic' "Shows syntax errors
call plug#end()

"Hexokinase configuration (show color in hex code bg)
let g:Hexokinase_highlighters = [ 'background' ]

"Colors
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
colorscheme thnikk
let g:lightline = { 'colorscheme': 'thnikk', 'component': { 'percent': ''}, }

" Make delete not cut (use x instead.)
nnoremap d "_d
vnoremap d "_d

"General settings
filetype plugin on "Enable filetype plugin
syntax on "Enable syntax highlighting
set clipboard+=unnamedplus "Set clipboard to system
set tabstop=4 "Indent width
set shiftwidth=4
set noshowmode "Hide mode (shows in lightline)
set mouse=a "Enable mouse support
set wildmenu "Autocompletion
set hlsearch "Highlight search patterns
set smartcase "Lowercase search is case insensitive while uppercase is
set ignorecase "Case-insensitive search
set confirm "Prompt to save changes on exit
set expandtab "Convert tab to spaces
set linebreak "Word wrap
set number relativenumber "Set line numbers to relative
set noswapfile "Disable annoying swap behavior
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o "Disables automatic commenting on newline:
let g:indentLine_leadingSpaceChar='·'
let g:indentLine_leadingSpaceEnabled='1'

"Key mappings
"Move between wrapped lines with arrow keys
imap <silent> <Down> <C-o>gj
imap <silent> <Up> <C-o>gk
nmap <silent> <Down> gj
nmap <silent> <Up> gk
"Clean indentations
map <F7> gg=G<C-o><C-o>
"Spell-check set to <leader>o, 'o' for 'orthography':
map <leader>o :setlocal spell! spelllang=en_us<CR>
"Replace all
map <leader>s :%s//g<Left><Left>
"Insert path and replace ~ (auto-resolved) with $HOME
map <leader>r :r !sed "s,$HOME,\$HOME,g"<<< $(echo -n )<left>
"Open corresponding .pdf/.html or preview
map <leader>p :!opout <c-r>%<CR><CR>
"Add shebang
map <leader>b <Esc>O#!/usr/bin/env sh<Down><Esc>
"Complile and run C program
map <leader>r : !gcc % && ./a.out <CR>
"Disable coc
map <leader>c :CocDisable<CR>

"On save
"Clean trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e
"Restart programs on config change
autocmd BufWritePost *.rst !make html
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
autocmd BufWritePost *polybar/config* !pkill -USR1 polybar
autocmd BufWritePost *polybar/config/scripts/* !pkill -USR1 polybar
autocmd BufWritePost picom.conf !pkill -USR1 picom
autocmd BufWritePost flexget/config.yml !flexget execute
autocmd BufWritePost */st/config.h make

"Italicize comments
highlight Comment gui=italic cterm=italic

au VimLeave * call nvim_cursor_set_shape("vertical-bar")
