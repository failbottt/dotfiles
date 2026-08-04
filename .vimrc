if has("termguicolors")
  set termguicolors
endif
color slate

let mapleader = ","
nnoremap <leader><leader> <C-^>

set nocompatible
set backspace=indent,eol,start
" set number
set cursorline
set incsearch
set autoindent
set ignorecase
set smartcase
set showmatch
set noswapfile
set laststatus=2
set expandtab
set shiftwidth=4
set softtabstop=4
set showcmd
set ruler
set hidden
set completeopt=
set complete=
set nospell

set wildignore+=*/node_modules/*,*/vendor/*,*/__pycache__/*,*.o,*.a,*.so,*.exe
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

if executable('fzf') && executable('rg')
  function! SS() abort
    let term = expand('<cword>')
    if empty(term)
      return
    endif
    let tmpfile = tempname()
    silent execute '!rg --line-number --no-heading --color=never ' . shellescape(term) . ' | fzf > ' . shellescape(tmpfile)
    redraw!
    if filereadable(tmpfile)
      let lines = readfile(tmpfile)
      if !empty(lines) && lines[0] !=# ''
        let parts = split(lines[0], ':', 3)
        if len(parts) >= 2
          execute 'edit ' . fnameescape(parts[0])
          execute parts[1]
        endif
      endif
      call delete(tmpfile)
    endif
  endfunction
  nnoremap S :call SS()<CR>

  function! FF() abort
    let tmpfile = tempname()
    silent execute '!rg --files 2>/dev/null | fzf > ' . shellescape(tmpfile)
    redraw!
    if filereadable(tmpfile)
      let lines = readfile(tmpfile)
      if !empty(lines) && lines[0] !=# ''
        execute 'edit ' . fnameescape(lines[0])
      endif
      call delete(tmpfile)
    endif
  endfunction
  nnoremap <leader>f :call FF()<CR>

  function! FS() abort
    let term = input('search: ')
    if empty(term)
      return
    endif
    let tmpfile = tempname()
    silent execute '!rg --line-number --no-heading --color=never ' . shellescape(term) . ' | fzf > ' . shellescape(tmpfile)
    redraw!
    if filereadable(tmpfile)
      let lines = readfile(tmpfile)
      if !empty(lines) && lines[0] !=# ''
        let parts = split(lines[0], ':', 3)
        if len(parts) >= 2
          execute 'edit ' . fnameescape(parts[0])
          execute parts[1]
        endif
      endif
      call delete(tmpfile)
    endif
  endfunction
  nnoremap \ :call FS()<CR>

  function! SF() abort
    let term = input('sf: ')
    if empty(term)
      return
    endif
    let tmpfile = tempname()
    silent execute '!rg --files --glob ' . shellescape('*' . term . '*') . ' 2>/dev/null | fzf > ' . shellescape(tmpfile)
    redraw!
    if filereadable(tmpfile)
      let lines = readfile(tmpfile)
      if !empty(lines) && lines[0] !=# ''
        execute 'edit ' . fnameescape(lines[0])
      endif
    call delete(tmpfile)
  endif
endfunction
  nnoremap <leader>f :call SF()<CR>
endif

function! COPY()
  let l:save_reg = getreg('"')
  let l:save_regtype = getregtype('"')

  silent normal! gvy
  let l:text = getreg('"')

  call setreg('"', l:save_reg, l:save_regtype)

  if executable('xsel')
    call system('xsel --clipboard --input', l:text)
  elseif executable('xclip')
    call system('xclip -selection clipboard', l:text)
  elseif executable('pbcopy')
    call system('pbcopy', l:text)
  elseif executable('copy')
    call system('copy', l:text)
  else
    echoerr 'No clipboard utility found (xsel, xclip, pbcopy, copy)'
    return
  endif
  echo 'copied'
endfunction
vnoremap <leader>y :<C-u>call COPY()<CR>

function! LIST_BUFFERS()
    " 1. getbufinfo({'buflisted': 1}) gets detailed info for all listed buffers
    " 2. map() converts that info into the format setqflist() expects
    let l:list = map(getbufinfo({'buflisted': 1}), '{
                \ "bufnr": v:val.bufnr,
                \ "lnum": v:val.lnum,
                \ "col": 1,
                \ "text": "Buffer: " . bufname(v:val.bufnr)
                \ }')

    " Set the quickfix list and open the window
    call setqflist(l:list)
    copen
    redraw!
endfunction
nnoremap <leader>b :<C-u>call LIST_BUFFERS()<CR>

function! TRIM_TRAILING_WHITESPACE()
  let l:save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', l:save_cursor)
endfunction

if exists(':augroup')
  augroup trim_whitespace_on_save
    autocmd!
    autocmd BufWritePre * call TRIM_TRAILING_WHITESPACE()
  augroup END

  augroup close_quickfix_on_enter
      autocmd!
      autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
  augroup END
endif
