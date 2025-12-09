color industry

let mapleader = ","

nnoremap <leader><leader> <C-^>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Use vim-compatible mode (close to classic vi)
set nocompatible

" Allow backspace over everything
set backspace=indent,eol,start

" Show line numbers
set number

" Highlight current line
set cursorline

" Enable incremental search
set incsearch

" Enable autoindent
set ai

" Case-insensitive search unless uppercase used
set ignorecase
set smartcase

" Show matching brackets
set showmatch

" No swap files (makes it easier to drop anywhere)
set noswapfile

" Simple status line
set laststatus=2

" Use spaces instead of tabs (optional, portable)
set expandtab
set shiftwidth=4
set softtabstop=4

" Minimal visual tweaks
set showcmd          " show partial commands
set ruler            " show cursor position

" Keep it fast and simple
set lazyredraw

" Disable insert-mode autocomplete completely
set completeopt=
set complete=
set nospell

