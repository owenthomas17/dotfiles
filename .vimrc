" Setting vimpath
set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim81,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after

" Enable filetype plugin (:help filtype)
filetype on
filetype plugin indent on
filetype indent on
set showcmd 

" Sort out colors
set background=dark
syntax on

" Show visual 'ruler' 
set colorcolumn=120
highlight ColorColumn ctermbg=Green

" Vim defaults
set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

" Setting tabbing for python/go files
set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4

" Enable fuzzy type search with :find
set path+=**

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show line numbers
set number

" When scrolling show context of n lines
set scrolloff=10

" Set window size of terminal when created with :terminal
set termwinsize=12x0

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" 
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Highlight text as you are searching
set incsearch


"Nice macro idea for the future
"
"Surround selected text in visual mode with tags or quotes and select it
"again:
"
"vnoremap ;b <ESC><ESC>`<i<b><ESC>`>3la</b><ESC>`<3lv`>3l
"
"Explanation: 
"<ESC><ESC>         Exit selection mode
"`<          go to beginning of selection
"i<b>           insert "<b>" tag
"<ESC>          exit insert mode
"`>           go to end of selection
"3l           go right as many characters as you inserted before the selection
"a</b>          append (insert after) "</b>" tag
"<ESC>          exit insert mode
"`<3l           go to beginning of selection + number of characters you
"inserted 
"v            go to visual mode
"`>3l           select until end of selection + number of characters you
"inserted 
