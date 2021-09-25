" $HOME/.config/nvim/init/plug.vim

"==== Plugins ====
"
" vim-plug plugin manager
" We love it's simplicity
" See: https://github.com/junegunn/vim-plug
call plug#begin()

" tpope, the original 'Vim plugin artist'
" See: https://github.com/tpope
  Plug 'tpope/vim-sensible'         " Start with 'sensible' defaults
  Plug 'tpope/vim-surround'         " Surround ([{}]) and other things
  Plug 'tpope/vim-repeat'           " Use '.' for repeat but works with plugins

" FZF is a blazing fast fuzzy-finder. Like ctrlp.vim but better.
" fzf.vim requires fzf, ag, ripgrep, and bat be installed.
  Plug 'junegunn/fzf'               " fzf
  Plug 'junegunn/fzf.vim'           " fzf.vim, plugin for fzf

" We've settled on Markdown for note-taking. Future-proof, easy to read/write
" on it's own, and immensely portable.
  Plug 'plasticboy/vim-markdown'    " Syntax hl & folding, motions too!
  "Plug 'godlygeek/tabular'          " Required by vim-markdown to fmt tables
  Plug 'dhruvasagar/vim-table-mode' " Better tables

" Use wiki.vim + markdown and some custom functions to manage our personal
" Zettelkasten. It's the simplest solution we've found that works and fits the
" plugins should be 'atomic' philophy.
  Plug 'lervag/wiki.vim'            " Like Vimwiki but for minimalists
  Plug 'dkarter/bullets.vim'        " Renumbers ordered lists!

"---- Visuals ----
  Plug 'jacoborus/tender.vim'       " Theme - integrates with lightline + urxvt
  Plug 'itchyny/lightline.vim'      " Simple lightweight statusline for vim
  Plug 'edkolev/tmuxline.vim'       " Matches tmux statusline to vim's 

" Make VIM a Python IDE
" See: https://medium.com/nerd-for-tech/vim-as-an-ide-for-python-2021-f922da6d2cfe
" Vim is a text editor, not an IDE. That said, linting is nice to have.
  Plug 'dense-analysis/ale'         " ale, asynchronous syntax checking

" vim-ledger
  Plug 'ledger/vim-ledger'          " vim plugin for ledger/hledger

" It's probably better to learn good Python practices the hard way first...
  "Plug 'Vimjas/vim-python-pep8-indent'  " nice PEP8 compliant indentation
" I should probably get better at navigating using vim defaults first...
  "Plug 'jeetsukumaran/vim-pythonsense'  " python text objects and motions

" One thing at a time, since ale offers completion, disabling for now...
  "Plug 'neoclide/coc.nvim', {'branch': 'release'}  " coc.nvim, Code completion

" Pretty parens
" Not necessary...
  "Plug 'luochen1990/rainbow'

" vim-airline
  "Plug 'vim-airline/vim-airline'
  "Plug 'vim-airline/vim-airline-themes'

" lualine.nvim
  "Plug 'hoob3rt/lualine.nvim'

" I haven't needed this yet...
  "Plug 'tpope/vim-commentary'  " vim-commentary

" Seems really nice and fast but FZF already does everything we need and we
" don't have to spend time configuring another plugin.
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
