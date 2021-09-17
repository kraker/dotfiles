scriptencoding utf-8
"======== .vimrc ========
"
" Author: Alex Kraker
" Email: alex@alexkraker.com
"
" 'You should understand every line in your .vimrc' - Vim Proverbs
" See: https://www.reddit.com/r/vim/wiki/vimrctips


" Enter the current millennium
" Vim automatically sets 'nocompatible' if it finds a vimrc/gvimrc upon
" startup. It can also have other unintended consequences.
" See: https://www.reddit.com/r/vim/wiki/vimrctips
  "set nocompatible           " Set this early so folding works

"==== Plugins ====
"
" vim-plug plugin manager
" We love it's simplicity
" https://github.com/junegunn/vim-plug
  call plug#begin()        " <- Make sure to set folder

  " tpope, the original 'Vim plugin artist'
  " https://github.com/tpope
    Plug 'tpope/vim-sensible'     " vim-sensible
    Plug 'tpope/vim-surround'     " vim-surround
    Plug 'tpope/vim-repeat'       " vim-repeat
  " I haven't needed this yet...
    "Plug 'tpope/vim-commentary'  " vim-commentary

  " FZF is a blazing fast fuzzy-finder. Like ctrlp.vim but better.
  " fzf.vim requires fzf, ag, ripgrep, and bat be installed
    Plug 'junegunn/fzf'       " fzf
    Plug 'junegunn/fzf.vim'     " fzf.vim, plugin for fzf

  " I dare you to find a better note-taking and web-page building syntax than
  " Markdown. Markdown seems pretty future-proof to boot since it's just text.
    Plug 'plasticboy/vim-markdown'  " Syntax hl & folding, motions too!
    Plug 'godlygeek/tabular'    " Required by vim-markdown to fmt tables

  " Use wiki.vim w/Markdown and some custom functions to manage our personal
  " Zettelkasten. There are some promissing projects for managing a personal
  " Zettelkasten for neovim.  But we're not ready to make the leap from vim to
  " neovim yet, mostly because more time would need to be spent learning how to
  " configure neovim.  Additionally most zettelkasten projects seem to be
  " 'neuron' wrappers and 'neuron' is already no longer actively developed. This
  " doesn't seem like very future-proof solution.
    Plug 'lervag/wiki.vim'      " wiki.vim, like Vimwiki for minimalists
    Plug 'dkarter/bullets.vim'    " Renumbers ordered lists!

  "---- Themes ----
    Plug 'jacoborus/tender.vim'

  " vim-airline
    "Plug 'vim-airline/vim-airline'
    "Plug 'vim-airline/vim-airline-themes'
  " lightline.vim
    Plug 'itchyny/lightline.vim' 
  " lualine.nvim
    "Plug 'hoob3rt/lualine.nvim'

  " tmuxline.vim
    Plug 'edkolev/tmuxline.vim'

  " Make VIM a Python IDE
  " See: https://medium.com/nerd-for-tech/vim-as-an-ide-for-python-2021-f922da6d2cfe
  " Vim is a text editor, not an IDE. That said, linting is nice to have.
    Plug 'dense-analysis/ale'     " ale, asynchronous syntax checking

  " It's probably better to learn good Python practices the hard way first...
    "Plug 'Vimjas/vim-python-pep8-indent'  " nice PEP8 compliant indentation
  " I should probably get better at navigating using vim defaults first...
    "Plug 'jeetsukumaran/vim-pythonsense'  " python text objects and motions

  " One thing at a time, since ale offers completion, disabling for now...
    "Plug 'neoclide/coc.nvim', {'branch': 'release'}  " coc.nvim, Code completion

  " vim-ledger
    Plug 'ledger/vim-ledger'    " vim plugin for ledger/hledger

  " Pretty parens
  " Not necessary...
    "Plug 'luochen1990/rainbow'

  " telescope.nvim
    "Plug 'nvim-lua/plenary.nvim'
    "Plug 'nvim-telescope/telescope.nvim'
  " Optional dependencies for telescope.nvim
    "Plug 'sharkdp/bat'
    "Plug 'sharkdp/fd'
    "Plug 'BurntSushi/ripgrep'
    "Plug 'nvim-treesitter/nvim-treesitter'
    "Plug 'neovim/nvim-lspconfig'
    "Plug 'kyazdani42/nvim-web-devicons'

  " nerveux.nvim
    "Plug 'nvim-lua/popup.nvim'
    "Plug 'pyrho/nerveux.nvim'

  " neuron.nvim
  " Plugin throws errors, not sure why, didn't spend too much time
  " troubleshooting it...
    "Plug 'oberblastmeister/neuron.nvim'
    "Plug 'nvim-lua/popup.nvim'

  " Vimwiki is more heavy handed than we would like and uses it's own syntax hl
  " and folding for Markdown. But it lacks features and doesn't do a very good
  " job at handling *.md it seems. Plugins like vim-markdown seem better suited to
  " the task, or even just the native syntax hl in vim.  Plugins should do one
  " thing and do it well. Vimwiki tries to be too many things... we've now moved
  " to wiki.vim which seems born out of these exact issues.
    "Plug 'vimwiki/vimwiki'     " Vimwiki

  " vim-zettel requires vimwiki, fzf, and fzf.vim
  " Helpful for managing a zettelkasten in Vimwiki. Has some nice features, but
  " also has some not-so-nice issues. The biggest being it's dependency on
  " Vimwiki.
    "Plug 'michal-h21/vim-zettel'   " vim-zettel

  " notational-fzf is nice but it's not necessary along with fzf.vim.  It's not
  " well documented and in the interest of reducing complexity/dependencies, I'm
  " uninstalling it.
    "Plug 'alok/notational-fzf-vim' " notational-fzf-vim

  call plug#end()

"==== END Plugins ====


"==== Indentation ====
"
" Recommended defaults for tabs
" See: https://www.reddit.com/r/vim/wiki/tabstop
  set tabstop=8
  set softtabstop=4
  set shiftwidth=4
  set expandtab
  "set autoindent
  filetype indent on              " Load filetype-specific indent files
  filetype plugin indent on       " Enable plugin based indents

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
" Enable syntax and plugins
  syntax enable
  filetype plugin on
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
  set foldmethod=syntax         " Default foldmethod is 'syntax'
  set foldlevel=2           " Set fold level
  "set foldnestmax=10         " 10 nested fold max

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


"==== Key Maps ====
"
  let mapleader=' '           " Remap spacebar to leader key

" Reload $MYVIMRC
  nnoremap <leader>r :so $MYVIMRC<CR> 
" Edit $MYVIMRC
  nnoremap <leader>ev :e $MYVIMRC<CR>

" Dr. Strangelove or: How I Learned to Stop Worrying and love Vim
" https://blog.sanctum.geek.nz/vim-anti-patterns/
" Unmap arrow keys to discourage their use because vim snobbery is ok w/me
  noremap <Up> <nop>
  noremap <Down> <nop>
  noremap <Left> <nop>
  noremap <Right> <nop>

" Remap split navigations to something a little more sane
" See: https://realpython.com/vim-and-python-a-match-made-in-heaven/
  nnoremap <C-J> <C-W><C-J>
  nnoremap <C-K> <C-W><C-K>
  nnoremap <C-L> <C-W><C-L>
  nnoremap <C-H> <C-W><C-H>

" Map <leader>ww to open my '~/wiki/_index.md' because wiki.vim
" doesn't allow me to override this configuration easily
  nnoremap <leader>ww :e ~/wiki/_index.md<CR>

" Call custom function for creating ZettelLinks from filenames yanked from fzf
" window and then paste the link from the register. Puts you in insert mode so
" you can write the description
  nnoremap <c-z> :call ZettelLink()<CR>"apF[a

"---- fzf key maps ----
  nnoremap <leader>ff :Files<CR>
  nnoremap <leader>fb :Buffers<CR>
  nnoremap <leader>fa :Ag<CR>
  nnoremap <leader>fr :Rg<CR>
  nnoremap <leader>fbl :BLines<CR>
" Map <ESC> to enter normal mode in terminal buffer
  "tnoremap <Esc> <C-\><C-n>
  " ^ this messes up the fuzzy finder in fzf when you type <ESC>...
  " Solution: https://github.com/junegunn/fzf.vim/issues/544
  tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"

" Open terminal in split
  nnoremap <leader>t :split term://bash<CR>i

" Map strip trailing whitespace
" See: https://vim.fandom.com/wiki/Remove_unwanted_spaces
  nnoremap <leader>dtw :%s/\s\+$//e<CR>

" markdown table format
  nnoremap <leader>mtf :TableFormat<CR>

" Automatic closing brackets
" See: https://stackoverflow.com/questions/21316727/automatic-closing-brackets-for-vim
  "inoremap " ""<left>
  "inoremap ' ''<left>
  "^ has unintended consequences when not writing code. Need to refactor to only
  "apply when I want it to. Namely when writing code it's ok, but when writing
  "writing it's not.
  inoremap ( ()<left>
  inoremap [ []<left>
  inoremap { {}<left>
  inoremap {<CR> {<CR>}<ESC>O
  inoremap {;<CR> {<CR>};<ESC>O
  " My own additions
  inoremap ` ``<left>

" Find files using Telescope command-line sugar.
  "nnoremap <leader>ff <cmd>Telescope find_files<cr>
  "nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  "nnoremap <leader>fb <cmd>Telescope buffers<cr>
  "nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"==== Misc. ====
"
" Enable yanking to system clipboard for Fedora
  "set clipboard=unnamedplus
  " I'm not sure what this does, disabling until I know I need it...

  " Instead of closing/quitting the buffer when using CTRL-W q/c just hide the
  " buffer.
  let hidden = 1


"==== Plugin Configs ====
"

"---- rainbow ----
  "let g:rainbow_active = 1

"---- vim-markdown ----
  let g:vim_markdown_frontmatter = 1    " YAML frontmatter syntax highlight
  let g:vim_markdown_autowrite = 1    " Auto-write when following link
  let g:vim_markdown_new_list_item_indent = 0    " Don't auto-indent new li's
  let g:vim_markdown_conceal_code_blocks = 0    " Show fenced code-blocks
  let g:vim_markdown_folding_style_pythonic = 0 " Folding in 'pythonic' style

"---- wiki.vim ----
  let g:wiki_root = '~/wiki'          " Set wiki root
  let g:wiki_link_extension = '.md'   " Set extension for wiki's is '.md'
  let g:wiki_link_target_type = 'md'  " Determines type of link used when creating links
  let g:wiki_filetypes = ['md']       " Wiki files are markdown filetype
  let g:wiki_write_on_nav = 1         " Save current buffer before navigating
  let g:wiki_journal = {
      \ 'name' : 'journal',
      \ 'frequency' : 'daily',
      \ 'date_format' : {
      \ 'daily' : '%Y-%m-%d',
      \ 'weekly' : '%Y_w%V',
      \ 'monthly' : '%Y_m%m',
      \ },
      \}

" Set function for creating new links
  let g:wiki_map_link_create = 'LinkCreate'
  function LinkCreate(description) abort
    " Custom function for creating links
    let date_format = '%Y%m%d%H%M%S'
    let date = strftime(date_format)
    let title = substitute(tolower(a:description), '\s\+', '-', 'g')
    let link = date . '-' . title
    return link
  endfunction

" Set new zettel template
  let g:wiki_templates = [
      \ { 'match_re' : '\d\{4}-\d\{2}-\d\{2}',
      \   'source_filename' : '/home/akraker/wiki/.journal.md' },
      \ { 'match_re' : '.\+',
      \   'source_filename' : '/home/akraker/wiki/.template.md'}
      \]
" Custom function to create a capitalized title from the 'context.name' string
" provided by the wiki.vim plugin.
  function Title(context)
    " Get title from context.name, remove leading numbers,
    " and title-case the string
    let name = a:context.name
    " Remove leading numbers, split into words at '-' characters, and join
    " with spaces in-between words
    let lowercase_title = join(
        \ split(
        \ substitute(name, '[0-9]\+-', '', 'g'),
        \ '-'),
        \ ' ')
    " title-case the string using substitution
    let title = substitute(lowercase_title, '\<.', '\u&', 'g')
    return title
  endfunction

" Custom function to create a zettel link out of file-names that were copied from
" FZF to the vim register. We've mapped ctrl-z above to call this function.
  function ZettelLink()
    " Grabs whatever was yanked into the "* register with 'ctrl-y' from
    " fzf_action's and returns a string in the format of a markdown link
    let zlink = join(['[]', '(', getreg('*'), ')'], '')
    let @a = zlink
  endfunction

"---- fzf.vim ----
" Set 'fzf_action' so that we can _yank_ file-names to the paste buffer
" https://github.com/junegunn/fzf.vim/issues/772
" See also: https://github.com/junegunn/fzf/blob/master/README-VIM.md
  let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'ctrl-y': {lines -> setreg('*', join(lines, "\n"))}}
  " ctrl-y copies the file-path to the "* register
  " Type :reg to see registers. "*p will paste the contents of the register to
  " the current buffer

"---- bullets.vim ----
  let g:bullets_enabled_file_types = ['markdown']    " Enable for *.md files

"---- lightline.vim ----
  set noshowmode
  let g:lightline = {'colorscheme': 'tender'}

"---- ale ---
" See: https://medium.com/nerd-for-tech/vim-as-an-ide-for-python-2021-f922da6d2cfe
  let g:ale_enabled = 0
  "let g:ale_sign_error = '✘'
  "let g:ale_sign_warning = '⚠'
  " Note: linters that ale uses must be installed separately
  let g:ale_linters = {
      \ 'python'  :   'all',
      \ 'vim'   :   'all',
      \ 'markdown':   'all'}
  " Remove trailing lines and trim whitespace on all files by default
  let g:ale_fixers = {
      \ '*'     : ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python'  : ['isort', 'yapf']}
  "let g:ale_lsp_suggestions = 1
  let g:ale_fix_on_save = 0
  "let g:ale_go_gofmt_options = '-s'
  "let g:ale_go_gometalinter_options = '— enable=gosimple — enable=staticcheck'
  let g:ale_completion_enabled = 0  " Enable completion in ale
  "let g:ale_echo_msg_error_str = 'E'
  "let g:ale_echo_msg_warning_str = 'W'
  "let g:ale_echo_msg_format = '[%linter%] [%severity%] %code: %%s'

"---- tmuxline.vim ----
  let g:tmuxline_preset = {
      \ 'a'   : '[#S]',
      \ 'win' : '#I:#W#F',
      \ 'cwin': '#I:#W#F',
      \ 'x'   : '#(whoami)',
      \ 'y'   : '#h',
      \ 'z'   : '%H:%M:%S %Y-%m-%d',
      \ 'options' : {
      \ 'status-justify'  : 'left',
      \ 'status-interval' : '1'}
      \}
  let g:tmuxline_separators = {
      \ 'left'      : '',
      \ 'left_alt'  : '>',
      \ 'right'     : '',
      \ 'right_alt' : '<',
      \ 'space'     : ' '}

"---- neveux.nvim ----
  "lua require 'nerveux'.setup()

"---- neuron.nvim ----
"lua << EOF
"require('neuron').setup({
"  virtual_titles = true,
"  mappings = true,
"  run = nil, -- function to run when in neuron dir
"  neuron_dir = '~/wiki', -- the directory of all of your notes, expanded by default (currently supports only one directory for notes, find a way to detect neuron.dhall to use any directory)
"  leader = 'gz', -- the leader key to for all mappings, remember with 'go zettel'
"})
"EOF

"---- notational-fzf-vim ----
" We no longer use this plugin, but leaving configs here for posterity
" Search these directories in NV
  "let g:nv_search_paths = ['~/wiki',
  "    \  '~/work/code',
  "    \  '~/work/docs',
  "    \  '~/work/mediawiki',
  "    \  '~/work/wiki']
  "let g:nv_create_note_window = 'split'  " New notes are created in vertical split

"==== END Plugin Configs ====


"==== Custom Functions ====


