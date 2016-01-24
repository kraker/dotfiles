"
" vimrc/init.vim 	alex.kraker@gmail.com
" 


" Pathogen Load
execute pathogen#infect()
execute pathogen#helptags()

"
" BASIC DEFAULTS
"

"" Prettify shit 
set background =dark 		"dark | light...(this must come before syntax)
syntax on
colorscheme default

" Show tab indent
set list lcs=tab:\|\ 

"" Formatting stuff
filetype plugin indent on
filetype plugin on
set shiftwidth 		=4
set tabstop 		=4
" Highlight cursorline
set cursorline
hi CursorLine 		cterm=bold ctermbg=234 
hi ColorColumn 		ctermbg=234
"set linebreak
set textwidth		=79
set colorcolumn		=+1
set number
"set spell "spelllang=en_us
set autoindent
set smartindent
set wrap
set shell=/bin/fish
" HTML/CSS defaults
au FileType html setlocal shiftwidth=2 tabstop=2
au FileType css setlocal shiftwidth=2 tabstop=2


"
" PLUGINS 
"

" Turn on RainbowParen's plugin
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Enable Colorizer
"let g:colorizer_startup = 0
"let g:colorizer_maxlines = 1000

" CtrlP plugin settings
let g:ctrlp_map= '<c-p>'
let g:ctrlp_cmd= 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

"vim-clojure-static settings
let g:clojure_fuzzy_indent = 1

"""" Activate vim-clojure-highlight
" Evaluate Clojure buffers on load
" these don't work...??
"autocmd BufRead *.clj try | silent! Require | catch /^Fireplace/ | endtry
"autocmd Syntax clojure EnableSyntaxExtension
