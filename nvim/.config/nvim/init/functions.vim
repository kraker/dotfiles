" $HOME/.config/nvim/init/functions.vim

"==== Functions ====

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
" FZF to the vim register. We've mapped ctrl-z to call this function.
function ZettelLink()
  " Grabs whatever was yanked into the "* register with 'ctrl-y' from
  " fzf_action's and returns a string in the format of a markdown link
  let zlink = join(['[]', '(', getreg('*'), ')'], '')
  let @a = zlink
endfunction
