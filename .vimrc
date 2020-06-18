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

    " highlight search matches
    set hlsearch

    " filetype specific textwidth
    autocmd FileType markdown setlocal textwidth=79
    autocmd FileType python setlocal textwidth=120

    au BufRead,BufNewFile *.nix set filetype=sh

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
    Plug 'tpope/vim-vinegar'  " makes netrw better
    Plug 'tpope/vim-commentary' " comment things with <gcc>
    Plug 'airblade/vim-gitgutter'  " show git changes in gutter, allows undo to revert line change
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " download fzf if not found
    Plug 'junegunn/fzf.vim'  " enables fzf integration with vim
    Plug 'PProvost/vim-ps1'     " powershell syntax highlighting
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    call plug#end()


"---------------"
"      FZF      "
"---------------"
    " change Files command to show file previews
    command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>1)


"---------------"
"      COC      "
"---------------"
    " supported languages
    let g:coc_global_extensions=[ 'coc-omnisharp' ]
    " Some servers have issues with backup files, see #649.
    " set nobackup
    " set nowritebackup

    " Give more space for displaying messages.
    set cmdheight=2

    " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    " delays and poor user experience.
    set updatetime=300

    " Don't pass messages to |ins-completion-menu|.
    set shortmess+=c

    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved.
    set signcolumn=yes

    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
    " position. Coc only does snippet and additional edit on confirm.
    " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
    " if exists('*complete_info')
    "     inoremap <expr> <cr> complete_info()["selected"]
    "     != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
    " else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " endif

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    xmap <leader>=  <Plug>(coc-format-selected)
    nmap <leader>=  <Plug>(coc-format-selected)
