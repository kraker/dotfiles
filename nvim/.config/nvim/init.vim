scriptencoding utf-8
" $HOME/.config/nvim/init.vim

"======== init.vim ========
"
" Author: Alex Kraker
" Email: alex@alexkraker.com
"
" 'You should understand every line in your .vimrc' - Vim Proverbs
" See: https://www.reddit.com/r/vim/wiki/vimrctips

" Break .vimrc/init.vim into parts to make it more manageable. 
" See: https://tuckerchapman.com/2020/05/09/vimrc_organization/

source $HOME/.config/nvim/init/plug.vim       " plugin loader
source $HOME/.config/nvim/init/general.vim    " general settings
source $HOME/.config/nvim/init/keymaps.vim    " key maps
source $HOME/.config/nvim/init/functions.vim  " custom functions
source $HOME/.config/nvim/init/plugins.vim    " plugin specific settings
