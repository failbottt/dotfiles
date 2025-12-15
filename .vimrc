color industry

let mapleader = ","

nnoremap <leader><leader> <C-^>

" use vim-compatible mode (close to classic vi)
set nocompatible
" allow backspace over everything set backspace=indent,eol,start
" show line numbers
set number

" highlight current line
set cursorline

" enable incremental search
set incsearch
" enable autoindent
set ai

" case-insensitive search unless uppercase used
set ignorecase
set smartcase

" show matching brackets
set showmatch

" no swap files (makes it easier to drop anywhere)
set noswapfile

" simple status line
set laststatus=2

" use spaces instead of tabs (optional, portable)
set expandtab
set shiftwidth=4
set softtabstop=4

" minimal visual tweaks
set showcmd          " show partial commands
set ruler            " show cursor position

" keep it fast and simple
set lazyredraw

" disable insert-mode autocomplete completely
set completeopt=
set complete=
set nospell

" Use ripgrep for :grep
set wildignore+=*/node_modules/*,*/vendor/*,*/__pycache__/*,*.o,*.a,*.so,*.exe
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif
nnoremap S :silent! execute 'grep' expand('<cword>')<CR>:copen<CR>

" Function to search user input and open quickfix
function! SearchPromptQuickfix() abort
  " Prompt the user for a search term (regex allowed)
  let l:term = input('st: ')
  if empty(l:term)
    return
  endif

  " Use :grep (which now calls rg) with the term
  silent! execute 'grep! ' . l:term

  " Open quickfix window
  copen
endfunction

" Map backslash to trigger the search prompt
nnoremap \ :call SearchPromptQuickfix()<CR>

function! SearchFilesQuickfix() abort
  " Prompt the user for a search term
  let l:term = input('sf: ')
  if empty(l:term)
      return
  endif

  " Populate quickfix with file names
  silent! execute 'grep! --files --glob "*' . l:term . '*" ./'

  " Fetch the current quickfix list
  let qf = getqflist()

  " Build proper quickfix entries as dictionaries
  let entries = []
  for item in qf
      if has_key(item, 'text') && !empty(item.text)
          call add(entries, {
                \ 'filename': item.text,
                \ 'lnum': 1,
                \ 'col': 1,
                \ 'text': 'File match'
                \ })
      endif
  endfor

  " Replace quickfix list
  call setqflist(entries)

  " Open quickfix window
  copen
endfunction

" Map to key, e.g., backslash + f
nnoremap <leader>f :call SearchFilesQuickfix()<CR>
