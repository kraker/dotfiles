" $HOME/.config/nvim/init/keymaps.vim

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
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
"inoremap {<CR> {<CR>}<ESC>O
"inoremap {;<CR> {<CR>};<ESC>O
" My own additions
"inoremap ` ``<left>

" Find files using Telescope command-line sugar.
"nnoremap <leader>ff <cmd>Telescope find_files<cr>
"nnoremap <leader>fg <cmd>Telescope live_grep<cr>
"nnoremap <leader>fb <cmd>Telescope buffers<cr>
"nnoremap <leader>fh <cmd>Telescope help_tags<cr>
