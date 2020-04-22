"-----------------------"
"	GENERAL SETTINGS	"
"-----------------------"
    " disable vi compatability
    set nocompatible

    " colorscheme location is ~/.vim/colors
    colorscheme photon

    "file searching
    set path=$PWD**

    " Display all matching files with tab complete
    set wildmenu
    set wildignore+=env/*

    " disable showmode so jedi can show call signatures in command line
    set noshowmode

    " disable statusline
    set laststatus=0

    " disable showmode so jedi can show call signatures in command line
    set noshowmode

    " enable line count
    set number relativenumber

    " make splits open below, and right
    set splitbelow splitright

    "mode based line color
    autocmd InsertEnter,InsertLeave * set cul!

    " use backup/undo files
    set backup 
    set undofile  " allows undos from previous sessions

    " consolidate backup/swap files into .vim 
    set backupdir=~/.vim/backup
    set directory=~/.vim/swaps
    set undodir=~/.vim/undo

"------------------------"
"    SYNTAX/FORMATTING   "
"------------------------"
    " indentation settings
    filetype plugin on
    set autoindent 
    set foldmethod=indent

    " tab width
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set fileformat=unix

    " change tabs to insert spaces
    set expandtab

    " filetype specific textwidth
    autocmd FileType markdown setlocal textwidth=79
    autocmd FileType python setlocal textwidth=120

    " remove trailing whitespace on save for python files only
    autocmd! BufWritePre *.py %s/\s\+$//e


"-----------------------"
"	TERMINAL SETTINGS	"
"------------------------"
    " distinguish alt from esc
    " https://stackoverflow.com/questions/6778961/alt-key-shortcuts-not-working-on-gnome-terminal-with-vim/10216459#10216459
    let c='a'
    while c <= 'z'
        exec "set <A-".c.">=\e".c
        exec "imap \e".c." <A-".c.">"
        let c = nr2char(1+char2nr(c))
    endw

    " set timeout lengths for keybinds
    " determines how long vim waits after you press first part of keybind
    set timeout ttimeoutlen=50

    set mouse=a " putty mouse scrolling


"---------------"
"	KEYBINDS	"
"---------------"
    " open command window with ;
    nnoremap ; :
    nnoremap : ;
    vnoremap ; :
    vnoremap : ;

    " Window splits
    noremap <space>wv :vnew <CR>
    noremap <space>wn :new <CR>
    noremap <space>wh :wincmd h <CR>
    noremap <space>wj :wincmd j <CR>
    noremap <space>wk :wincmd k <CR>
    noremap <space>wl :wincmd l <CR>

    " resize window splits
    noremap <space>rh :vertical resize +5 <CR>
    noremap <space>rl :vertical resize -5 <CR>
    noremap <space>rj :resize -5 <CR>
    noremap <space>rk :resize +5 <CR>

    " scroll 5 lines at a time with Alt
    nnoremap <A-j> 5j
    nnoremap <A-k> 5k

    " open fzf
    nnoremap \f :Files<CR>

    " open fugitive git status
    nnoremap \t :Gst<CR>

    " clear previous search highlight with tilde key
    nnoremap ` :let @/ = "" <CR>

    " reload syntax highlighting (when folds mess strings up)
    nnoremap \r :syntax sync fromstart<CR>

    " fold diff files with \z
    nnoremap \z :setlocal foldmethod=expr foldexpr=DiffFold(v:lnum) <CR>
    function! DiffFold(lnum)
        let line = getline(a:lnum)
        if line =~ '^\(---\|+++\|@@\) '
            return 1
        elseif line[0] =~ '[-+ ]'
            return 2
        else
            return 0
        endif
    endfunction


"---------------"
"	PACKAGES	"
"---------------"
    "check if plug.vim is installed, download if needed
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    " Remember to run PlugInstall after adding to this list
    call plug#begin('~/.vim/plugged')
    Plug 'tpope/vim-fugitive'  " git wrapper. Enables :Gbl, :Gst, :Git diff <branch>
    Plug 'airblade/vim-gitgutter'  " show git changes in gutter, allows Hunk undo to revert line change
    Plug 'tpope/vim-vinegar'  " makes netrw better
    Plug 'davidhalter/jedi-vim'  " python IDE features like autocomplete and goto def
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " download fzf if not found
    Plug 'junegunn/fzf.vim'  " enables fzf integration with vim
    call plug#end()


"-----------"
"	Jedi    "
"-----------"
    "  disable auto completion for object methods
    "  press ctrl space for popup
    let g:jedi#popup_on_dot = 0   
    let g:jedi#completions_enabled = 1
    let g:jedi#show_call_signatures = 2
    let g:jedi#rename_command = ""  " this was conflicting with syntax sync fromstart


"---------------"
"      FZF      "
"---------------"
    " change Files command to show file previews
    command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>1)
