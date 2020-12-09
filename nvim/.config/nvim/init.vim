"Remap leader to comma
let mapleader =","
let g:indentLine_setConceal = 0
set title

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
Plug 'kovetskiy/sxhkd-vim' "Syntax highlighting for sxhkd config
Plug 'mboughaba/i3config.vim' "Syntax highlighting for i3 config
Plug 'airblade/vim-gitgutter' "Shows changes since last commit in NL gutter
Plug 'itchyny/lightline.vim' "Bottom bar
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } } "Md preview
Plug 'norcalli/nvim-colorizer.lua'
Plug 'vim-syntastic/syntastic' "Shows syntax errors
Plug 'vimwiki/vimwiki'
call plug#end()

"Enable persistent undo
if has("persistent_undo")
    set undodir=$HOME/.local/nvim/undo
    set undofile
endif

"Disable word wrap for email
au filetype mail :setlocal fo-=t

"Change vimwiki directory
let g:vimwiki_list = [{'path': '~/.local/wiki',
                      \ 'path_html': '~/.local/wiki_html'}]
let g:vimwiki_global_ext = 0

"Hexokinase configuration (show color in hex code bg)
"let g:Hexokinase_highlighters = [ 'background' ]

"Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"Ignore filetypes with syntastic
let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "passive_filetypes": ["python", "cpp"] }

"Colors
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    "Enable colorizer.lua by default (needs to be after set termguicolors
    lua require'colorizer'.setup()
endif
colorscheme thnikk
let g:lightline = { 'colorscheme': 'thnikk', 'component': { 'percent': ''}, }

"Fix keybinds
"Make delete not cut (use x instead.)
nnoremap d "_d
vnoremap d "_d
"Make paste not yank (why would anyone even want this?)
xnoremap p "_dP

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
set updatetime=100
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o "Disables automatic commenting on newline:
let g:indentLine_leadingSpaceChar='·' "Show leading spaces with a dot
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
map <leader>/ :r !sed "s,$HOME,\$HOME,g"<<< $(echo -n )<left>
"Open corresponding .pdf/.html or preview
map <leader>p :!opout <c-r>%<CR><CR>
"Add shebang
map <leader>b <Esc>O#!/usr/bin/env sh<Down><Esc>
"Complile and run C program
map <leader>r : !gcc % && ./a.out <CR>
"Disable coc
map <leader>c :CocDisable<CR>
"Hide rulers
map <leader>r :set nu! norelativenumber!<CR>
"Hide/show lightline
map <leader>l :set laststatus=1<CR>
map <leader>L :set laststatus=2<CR>
map <leader>x :!chmod +x %<CR><CR>
"Clear highlighting from search
nnoremap <esc><esc> :noh<return>

"On save
"Clean trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e
"Restart programs on config change
autocmd BufWritePost *.rst !make html
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd && notify-send "Restarting sxhkd"
autocmd BufWritePost *polybar/config* !pkill -USR1 polybar
autocmd BufWritePost *mako/config* !makoctl reload
autocmd BufWritePost *polybar/config/scripts/* !pkill -USR1 polybar
autocmd BufWritePost picom.conf !pkill -USR1 picom
autocmd BufWritePost */st/config.h make

"Italicize comments
highlight Comment gui=italic cterm=italic

"Create directories if they don't exist
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

