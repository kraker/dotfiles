" $HOME/.config/nvim/init/plugins.vim

"==== Plugin Configs ====
"

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

"---- nerveux.nvim ----
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

"---- rainbow ----
"let g:rainbow_active = 1

"==== END Plugin Configs ====
