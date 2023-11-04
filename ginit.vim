set tabstop=2 shiftwidth=2 expandtab
set mouse=a
" Enable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 1
endif
if exists(':GuiAdaptiveColor')
    GuiAdaptiveColor 1
endif


" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv

colorscheme slate

GuiFont Source Code Pro:h16

let s:fontsize = 20
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! Source Code Pro:h" . s:fontsize
endfunction

" Usar Ctr+rueda de ratón o ctr+ + o - para aumentar o disminuir el tamaño de
" letra
noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

noremap <C-+> :call AdjustFontSize(1)<CR>
noremap <C--> :call AdjustFontSize(-1)<CR>
inoremap <C-+> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C--> <Esc>:call AdjustFontSize(-1)<CR>a

noremap <F2> :GuiTreeviewToggle<CR>
inoremap <F2> <Esc>:GuiTreeviewToggle<CR>

" Movimiento natural del cursor y no línea a línea
"map <Up> g<Up>
""map <Down> g<Down>
"imap <Up> <C-[> g<Up> i
"imap <Down> <C-[> g<Down> i


