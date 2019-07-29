" disable vi compatability
set nocompatible

"file searching
set path+=**

" Display all matching files with tab complete
set wildmenu

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" enable line count
set number relativenumber

" make splits open below, and right
set splitbelow splitright

"""""""""""""
" PACKAGES  "
"""""""""""""
"check if plug.vim is installed, download if needed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'w0rp/ale'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-vinegar'
Plug 'junegunn/goyo.vim'
call plug#end()

" indentation settings
filetype plugin on
set autoindent

"for compton exceptions
set title

"for st background color
if &term =~ '256color'
	set t_ut=
end

"for st mouse scroll
set ttymouse=sgr

" tab width
set tabstop=4
set shiftwidth=4
" change tabs to insert spaces
" set expandtab
 
" Set line width to 80 for markdown files
autocmd FileType markdown setlocal textwidth=79
 
"line folding
set foldmethod=syntax 
"automatically open all fold on file open
autocmd Syntax * normal zR


"""""""""""""""""
"	KEYBINDS	"
"""""""""""""""""
map <space>m :make <CR>
noremap <space>wv :vnew <CR>
noremap <space>wn :new <CR>
noremap <space>wh :wincmd h <CR>
noremap <space>wj :wincmd j <CR>
noremap <space>wk :wincmd k <CR>
noremap <space>wl :wincmd l <CR>

noremap <space>rh :vertical resize +5 <CR>
noremap <space>rl :vertical resize -5 <CR>
noremap <space>rj :resize -5 <CR>
noremap <space>rk :resize +5 <CR>

"Make rebinds based on filetype
autocmd FileType go map <space>m :GoRun <CR>
autocmd FileType rust map <space>m :!cargo run <CR>

"terminal keybinds
tnoremap <Esc> <C-W>N


colorscheme photon

if has("vms")
    set nobackup		" do not keep a backup file, use versions instead
else
    set backup		" keep a backup file (restore to previous version)
    if has('persistent_undo')
        set undofile	" keep an undo file (undo changes after closing)
    endif
endif

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
    packadd! matchit
endif

"""""""""""""""""""""
"       ALE         "
"""""""""""""""""""""
let g:ale_lint_on_text_changed = 'never' "only lint on save
" autocmd InsertLeave * :ALELint "lint when you leave insert mode

let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

"""""""""""""""""
"   AIRLINE     "
"""""""""""""""""
" Airline- powerline fonts
let g:airline_symbols_powerline= 1
let g:airline_theme='base16'


if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '≡'
let g:airline_symbols.maxlinenr = ''

"ale
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#warning_symbol = 'warning: '
let airline#extensions#ale#error_symbol = 'error: '

" enable fugitive for airline
let g:airline#extensions#branch#enabled = 1

" whitespace warnings
let g:airline#extensions#whitespace#checks = 
            \['indent', 'long', 'mixed-indent-file']

let g:airline#extensions#wordcount#enabled = 0
" let g:airline_section_y = ''
let g:airline_skip_empty_sections = 1
let g:airline_section_z = '%p%% ≡(%c,%l)'

"mix-indent-file special treatment for /* */ comments
let airline#extensions#c_like_langs = 
            \ ['arduino', 'c', 'cpp', 'cuda', 'go', 'javascript', 'ld', 'php']


"---------------"
"	 Vim-Go		"
"---------------"
let g:go_fmt_fail_silently = 1


"---------------"
"	Vim-Rust	"
"---------------"
"run RustFmt on save
let g:rustfmt_autosave = 1

"rusty-tags
" autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
"autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

"vim-racer
let g:racer_cmd = "~/.cargo/bin/racer"
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)
