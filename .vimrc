" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
    finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
    set nobackup		" do not keep a backup file, use versions instead
else
    set backup		" keep a backup file (restore to previous version)
    if has('persistent_undo')
        set undofile	" keep an undo file (undo changes after closing)
    endif
endif

if &t_Co > 2 || has("gui_running")
    " Switch on highlighting the last used search pattern.
    set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
    au!

    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
    packadd! matchit
endif

colorscheme photon

" enable line count
set number

" indentation settings
filetype plugin on
set autoindent

"for compton exceptions
set title

" tab width
set tabstop=4
set shiftwidth=4
" change tabs to insert spaces
set expandtab


" plugin POOP
execute pathogen#infect()


""""""""""""""""""""""
"AIRLINE
""""""""""""""""""""""
" Airline- powerline fonts
let g:airline_symbols_ascii= 1
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
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''

" enable fugitive for airline
let g:airline#extensions#branch#enabled = 1

" whitespace warnings
let g:airline#extensions#whitespace#checks = [ 'indent', 'long', 'mixed-indent-file' ]

let g:airline#extensions#wordcount#enabled = 1
let g:airline_section_y = ''
let g:airline_skip_empty_sections = 1
" let g:airline_section_z(line number, column number)
let g:airline_section_z = 'line:%l col:%c'

"mix-indent-file special treatment for /* */ comments
let airline#extensions#c_like_langs = ['arduino', 'c', 'cpp', 'cuda', 'go', 'javascript', 'ld', 'php']


" autoopen nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
let g:NERDTreeWinSize = 22 

" auto close tree if last window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" open tree keybind
map <C-t> :NERDTreeToggle<CR>

" " gutentags
let g:gutentags_enabled = 1

" tagbar
autocmd FileType * nested :call tagbar#autoopen(0)
let g:tagbar_width = 22 


let g:tagbar_type_php = {
    \ 'kinds' : [
        \ 'n:namespaces:0:0',
        \ 'a:use aliases:1:0',
        \ 'd:constant definitions:0:0',
        \ 'i:interfaces',
        \ 't:traits',
        \ 'c:classes',
        \ 'f:functions',
        \ '?:unknown',
    \ ],
\ }

