" $HOME/.config/nvim/init/general.vim

" Enter the current millennium
" Vim automatically sets 'nocompatible' if it finds a vimrc/gvimrc upon
" startup. It can also have other unintended consequences.
" See: https://www.reddit.com/r/vim/wiki/vimrctips
  "set nocompatible           " Set this early so folding works

"==== Indentation ====
"
" Recommended defaults for tabs
" See: https://www.reddit.com/r/vim/wiki/tabstop
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
"set autoindent
"filetype indent on              " Load filetype-specific indent files
filetype plugin indent on       " Enable plugin based indents
" Enable syntax and plugins
syntax enable
"filetype plugin on

" Python specific configs
" PEP 8 standards
" https://realpython.com/vim-and-python-a-match-made-in-heaven/
augroup python_indents
  autocmd!
  autocmd BufNewFile,BufRead *.py setlocal
      \ tabstop=4
      \ softtabstop=4
      \ shiftwidth=4
      \ textwidth=79
      \ expandtab
      \ autoindent
      \ fileformat=unix
augroup END

" Full stack web dev configs
" https://realpython.com/vim-and-python-a-match-made-in-heaven/
augroup webdev_indents
  autocmd!
  autocmd BufNewFile,BufRead *.js,*.html,*.css setlocal
      \ tabstop=2
      \ softtabstop=2
      \ shiftwidth=2
augroup END

" Markdown specific indentation and other configs
augroup markdown_indents
  autocmd!
  autocmd BufNewFile,BufRead *.md,*.markdown setlocal
      \ tabstop=2
      \ softtabstop=2
      \ shiftwidth=2
      \ expandtab
  " Enable Vim's spellcheck for markdown files
  autocmd FileType markdown setlocal spell
augroup END

" Vimscript indentation
" See: https://google.github.io/styleguide/vimscriptguide.xml
augroup vimscript_indents
  autocmd!
  autocmd BufNewFile,BufRead *.vimrc,*.vim setlocal
      \ tabstop=2
      \ softtabstop=2
      \ shiftwidth=2
      \ expandtab
  autocmd FileType vim setlocal
      \ tabstop=2
      \ softtabstop=2
      \ shiftwidth=2
      \ expandtab
augroup END

augroup shellscript_indents
  autocmd!
  autocmd FileType sh setlocal
      \ tabstop=2
      \ softtabstop=2
      \ shiftwidth=2
      \ foldmethod=indent
  autocmd FileType sh let g:sh_fold_enabled=5
  autocmd FileType sh let g:is_bash=1
  autocmd FileType sh let g:is_sh=1
augroup END


"==== Visuals ====
"
set number          " Set relative line numbers
"set cursorline            " Highlight cursorline
set showcmd             " show command in bottom bar
set wildmenu            " Visual autocomplete for command menu
set lazyredraw            " Redraw only when we need to
set showmatch             " highlight matching [{()}]
set splitbelow            " Horizontal splits below current buffer
set colorcolumn=81          " Set vertical line
set conceallevel=2          " Conceal links/formatting for *.md files
" termwinsize is incompatible with neovim
"set termwinsize=15x0        " Set terminal window size
" Highlight vertical column a specific color
highlight ColorColumn ctermbg=0
" Theme
colorscheme tender
" Show trailing whitespace
" See: https://vim.fandom.com/wiki/Highlight_unwanted_spaces
"autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
"match ExtraWhitespace /\s\+$/
"autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
"autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"autocmd InsertLeave * match ExtraWhitespace /\s\+$/
"autocmd BufWinLeave * call clearmatches()
"^ Broken, throws errors on nvim startup

"---- Statusline ----
" See: https://www.vi-improved.org/recommendations/
" https://shapeshed.com/vim-statuslines/
" https://learnvimscriptthehardway.stevelosh.com/chapters/17.html
"set laststatus=2          " Show statusline for all windows
"set statusline=
"set statusline+=%f        " Path to the file
"set statusline+=\ -\      " Separator
"set statusline+=FileType: " Label
"set statusline+=%y        " Filetype of the file
"set statusline+=%=        " Switch to the right side
"set statusline+=%l        " Current line
"set statusline+=/         " Separator
"set statusline+=%L        " Total lines

"==== Text Processing ====
"
set nowrap
set textwidth=80          " Set textwidth to 80 columns
set wrapmargin=2          " Allow 2 chars over 80th col before
                            " wrapping text

"==== Folding ====
"
set foldenable            " Enable folds by default
set foldmethod=syntax     " Default foldmethod is 'syntax'
set foldlevel=2           " Set fold level
"set foldnestmax=10       " 10 nested fold max

" Bash specific folding
"augroup Bash
"  autocmd!
"  autocmd FileType sh
"     \ let g:sh_fold_enabled=5
"     \ let g:is_bash=1
"     \ set foldmethod=marker
"augroup END
" ^ is broken somehow...

" ledger specific folding
augroup Ledger
  autocmd!
  autocmd FileType ledger set foldmethod=syntax
augroup END

" Save folds on close
" Below throws errors when closing :Toc buffer from vim-markdown plugin
"augroup remember_folds
"  autocmd!
"  autocmd BufWinLeave * mkview
"  autocmd BufWinEnter * silent! loadview
"augroup END

"==== Misc. ====
"
" Enable yanking to system clipboard for Fedora
"set clipboard=unnamedplus
" I'm not sure what this does, disabling until I know I need it...

" Instead of closing/quitting the buffer when CTRL-W q/c just hide the buffer.
let hidden = 1
