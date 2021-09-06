"======== .vimrc ========
"
" Author: Alex Kraker
" Email: alex@alexkraker.com


" Enter the current millenium
	set nocompatible							" Set this early so folding works


"==== Tabs ====
"
	set tabstop=2
	set softtabstop=2
	set shiftwidth=2
	set autoindent
	filetype indent on						" Load filetype-specific indent files
	filetype plugin indent on			" Enable plugin based indents

" Python specific configs
" PEP 8 standards
" https://realpython.com/vim-and-python-a-match-made-in-heaven/
	au BufNewFile,BufRead *.py
		\ set tabstop=4
		\ set softtabstop=4
		\ set shiftwidth=4
		\ set textwidth=79
		\ set expandtab
		\ set autoindent
		\ set fileformat=unix

" Full stack web dev configs
" https://realpython.com/vim-and-python-a-match-made-in-heaven/
	au BufNewFile,BufRead *.js, *.html, *.css
		\ set tabstop=2
		\ set softtabstop=2
		\ set shiftwidth=2


" Tabs are not spaces because tabs are easier to read for the visually impaired.
" Excepting when the language requires. Python for example.
" See also: https://www.reddit.com/r/javascript/comments/c8drjo/nobody_talks_about_the_real_reason_to_use_tabs/
	"set expandtab								" tabs are spaces
	"set nosmarttab								" I disabled this for reasons I can't remember...


"==== Visuals ====
"
	set number										" Line numbers
	set cursorline								" Highlight cursorline
	set showcmd										" show command in bottom bar
	set wildmenu									" Visual autocomplete for command menu
	set lazyredraw								" Redraw only when we need to
	set showmatch									" highlight matching [{()}]
	set splitbelow								" Horizontal splits are below current buffer
	set colorcolumn=81						" Set vertical line
	set conceallevel=2						" Conceal links, formatting, etc for *.md files
	set termwinsize=15x0					" Set terminal window size
" Enable syntax and plugins
	syntax enable
	filetype plugin on
" Highlight vertical column a specific color
	highlight ColorColumn ctermbg=0

"==== Text Processing ====
"
	set nowrap
	set textwidth=80							" Set textwidth to 80 columns
	set wrapmargin=2							" Not sure what this does...but auto-wraps?
	autocmd FileType markdown setlocal spell	" Enable 'spell' for markdown files


"==== Folding ====
"
	set foldenable							" Open folds by default
	set foldmethod=syntax				" Default foldmethod is 'syntax'
	set foldlevel=2							" Set fold level
	"set foldmethod=indent			" Fold based on indent level
	"set foldnestmax=10					" 10 nested fold max

" Bash specific folding
	au FileType sh let g:sh_fold_enabled=5
	au FileType sh let g:is_bash=1
	au FileType sh set foldmethod=marker

" ledger specific folding
	au FileType ledger set foldmethod=syntax

" Save folds on close
" Below throws errors when closing :Toc buffer from vim-markdown plugin
	"augroup remember_folds
	"  autocmd!
	"  autocmd BufWinLeave * mkview
	"  autocmd BufWinEnter * silent! loadview
	"augroup END


"==== Key Maps ====
"
	let mapleader=" "							" Remap spacebar to leader key

" Dr. Strangelove or: How I Learned to Stop Worrying and love Vim
" https://blog.sanctum.geek.nz/vim-anti-patterns/
" Unmap arrow keys to discourage their use because vim snobbery is ok w/me
	noremap <Up> <nop>
	noremap <Down> <nop>
	noremap <Left> <nop>
	noremap <Right> <nop>

" Map <leader>ww to open my '~/wiki/_index.md' because wiki.vim
" doesn't allow me to override this configuration easily
	nnoremap <leader>ww :e ~/wiki/_index.md<CR>

" Call custom function for creating ZettelLinks from filenames yanked from fzf
" window and then paste the link from the register. Puts you in insert mode so
" you can write the description
	nnoremap <C-Z> :call ZettelLink()<CR>"apF[a


"==== Misc. ====
"
" Enable yanking to system clipboard for Fedora
	"set clipboard=unnamedplus
	" I'm not sure what this does, disabling until I know I need it...

"==== Plugins ====
"
" vim-plug plugin manager
" We love it's simplicity
" https://github.com/junegunn/vim-plug
	call plug#begin('~/.vim/plugged')				" <- Make sure to set folder

	" tpope, the original 'Vim plugin artist'
	" https://github.com/tpope
		Plug 'tpope/vim-sensible'							" vim-sensible
		Plug 'tpope/vim-surround'							" vim-surround
	" I haven't needed this yet...
		"Plug 'tpope/vim-commentary'						" vim-commentary

	" Pretty parens
	" Not necessary...
		"Plug 'luochen1990/rainbow'

	" FZF is a blazing fast fuzzy-finder. Like ctrlp.vim but better.
	" fzf.vim requires fzf, ag, ripgrep, and bat be installed
		Plug 'junegunn/fzf'										" fzf
		Plug 'junegunn/fzf.vim'								" fzf.vim, plugin for fzf

	" I dare you to find a better note-taking and web-page building syntax than
	" Markdown. Markdown seems pretty future-proof to boot since it's just text.
		Plug 'plasticboy/vim-markdown'				" Syntax hl & folding, motions too!
		Plug 'godlygeek/tabular'							" Required by vim-markdown to fmt tables

	" Use wiki.vim w/Markdown and some custom functions to manage our personal
	" Zettelkasten. There are some promissing projects for managing a personal
	" Zettelkasten for neovim.  But we're not ready to make the leap from vim to
	" neovim yet, mostly because more time would need to be spent learning how to
	" configure neovim.  Additionally most zettelkasten projects seem to be
	" 'neuron' wrappers and 'neuron' is already no longer actively developed. This
	" doesn't seem like very future-proof solution.
		Plug 'lervag/wiki.vim'								" wiki.vim, like Vimwiki for minimalists
		Plug 'dkarter/bullets.vim'						" Renumbers ordered lists!

	" Make VIM a Python IDE
	" See: https://medium.com/nerd-for-tech/vim-as-an-ide-for-python-2021-f922da6d2cfe
	" Vim is a text editor, not an IDE. That said, linting is nice to have.
		Plug 'dense-analysis/ale'							" ale, asynchronous syntax checking

	" It's probably better to learn good Python practices the hard way first...
		"Plug 'Vimjas/vim-python-pep8-indent'	" nice PEP8 compliant indentation
	" I should probably get better at navigating using vim defaults first...
		"Plug 'jeetsukumaran/vim-pythonsense'	" python text objects and motions

	" One thing at a time, since ale offers completion, disabling for now...
		"Plug 'neoclide/coc.nvim', {'branch': 'release'}	" coc.nvim, Code completion

	" Vimwiki is more heavy handed than we would like and uses it's own syntax hl
	" and folding for Markdown. But it lacks features and doesn't do a very good
	" job at handling *.md it seems. Plugins like vim-markdown seem better suited to
	" the task, or even just the native syntax hl in vim.  Plugins should do one
	" thing and do it well. Vimwiki tries to be too many things... we've now moved
	" to wiki.vim which seems born out of these exact issues.
		"Plug 'vimwiki/vimwiki'								" Vimwiki

	" vim-zettel requires vimwiki, fzf, and fzf.vim
	" Helpful for managing a zettelkasten in Vimwiki. Has some nice features, but
	" also has some not-so-nice issues. The biggest being it's dependency on
	" Vimwiki.
		"Plug 'michal-h21/vim-zettel'					" vim-zettel

	" neuron-v2.vim would have been nice if it worked. It's basically a vimscript
	" wrapper for 'neuron'. Because neuron is no longer actively developed it
	" doesn't make sense to use this long-term or spend too much time trying to
	" resolve issues with it. Project seems defunct now anyways...
		"Plug 'chiefnoah/neuron-v2.vim'				" neuron-v2.vim

	" notoire, another plugin that just didn't really seem to work out of the box...
		"Plug 'KevinBockelandt/notoire'				" notoire

	" notational-fzf is nice but it's not necessary along with fzf.vim.  It's not
	" well documented and in the interest of reducing complexity/dependencies, I'm
	" uninstalling it.
		"Plug 'alok/notational-fzf-vim'				" notational-fzf-vim

	call plug#end()


"==== Plugin Configs ====
"

"---- rainbow ----
	"let g:rainbow_active = 1

"---- vim-markdown ----
	let g:vim_markdown_frontmatter = 1			" YAML frontmatter syntax highlighting
	let g:vim_markdown_autowrite = 1				" Auto-write when following link
	let g:vim_markdown_new_list_item_indent = 0		" Don't auto-indent new li's
	let g:vim_markdown_conceal_code_blocks = 0		" Show fenced code-blocks


"---- wiki.vim ----
	let g:wiki_root = '~/wiki'						" Set wiki root
	let g:wiki_link_extension = '.md'			" Set extension for wiki's is '.md'
	let g:wiki_link_target_type = 'md'		"
	let g:wiki_filetypes = ['md']					" Wiki files are markdown filetype
	let g:wiki_write_on_nav = 1						" Save current buffer before navigating

" Set function for creating new links
	let g:wiki_map_link_create = 'LinkCreate'
	function LinkCreate(description) abort
		" Custom function for creating links
		let date_format = "%Y%m%d%H%M%S"
		let date = strftime(date_format)
		let title = substitute(tolower(a:description), '\s\+', '-', 'g')
		let link = date . '-' . title
		return link
	endfunction

" Set new zettel template
	let g:wiki_templates = [
				\	{ 'match_re': '.*',
				\		'source_filename': '.template.md'},
				\	]
" Custom function to create a capitalized title from the 'context.name' string
" provided by the wiki.vim plugin.
	function Title(context)
		" Get title from context.name, remove leading numbers,
		" and title-case the string
		let name = a:context.name
		" Remove leading numbers, split into words at '-' characters, and join with
		" spaces in-between words
		let lowercase_title = join(split(substitute(name, '[0-9]\+-', '', 'g'), '-'), ' ')
		" title-case the string using substitution
		let title = substitute(lowercase_title, '\<.', '\u&', 'g')
		return title
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
	let g:bullets_enabled_file_types = ['markdown']		" Enable for *.md files


"---- ale ---
" See: https://medium.com/nerd-for-tech/vim-as-an-ide-for-python-2021-f922da6d2cfe
	" Let all work on these filetypes
	"let g:ale_sign_error = '✘'
	"let g:ale_sign_warning = '⚠'
	" Note: linters that ale uses must be installed separately
	let g:ale_linters = {
		\	'python': 'all',
		\	'vim': 'all',
		\	'markdown': 'all'}
	" Remove trailing lines and trim whitespace on all files by default
	let g:ale_fixers = {
		\	'*': ['remove_trailing_lines', 'trim_whitespace'],
		\	'python': ['isort', 'yapf']}
	"let g:ale_lsp_suggestions = 1
	let g:ale_fix_on_save = 1
	"let g:ale_go_gofmt_options = '-s'
	"let g:ale_go_gometalinter_options = '— enable=gosimple — enable=staticcheck'
	let g:ale_completion_enabled = 1	" Disable completion when using something else
	"let g:ale_echo_msg_error_str = 'E'
	"let g:ale_echo_msg_warning_str = 'W'
	"let g:ale_echo_msg_format = '[%linter%] [%severity%] %code: %%s'


"---- notational-fzf-vim ----
" We no longer use this plugin, but leaving configs here for posterity
" Search these directories in NV
	"let g:nv_search_paths = ['~/wiki',
	"											\	'~/work/code',
	"											\	'~/work/docs',
	"											\	'~/work/mediawiki',
	"											\	'~/work/wiki']
	"let g:nv_create_note_window = 'split'	" New notes are created in vertical split


"==== Custom Functions ====

" Custom function to create a zettel link out of file-names that were copied from
" FZF to the vim register. We've mapped ctrl-z above to call this function.
	function ZettelLink()
		" Grabs whatever was yanked into the "* register with 'ctrl-y' from
		" fzf_action's and returns a string in the format of a markdown link
		let zlink = join(['[]', '(', getreg('*'), ')'], '')
		let @a = zlink
	endfunction
