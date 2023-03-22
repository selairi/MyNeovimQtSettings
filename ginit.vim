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

GuiFont Source Code Pro:h14

let s:fontsize = 14
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

noremap <F1> :e ~/.config/nvim/help.txt<CR>
inoremap <F1> <Esc>:e ~/.config/nvim/help.txt<CR>

noremap <F2> :GuiTreeviewToggle<CR>
inoremap <F2> <Esc>:GuiTreeviewToggle<CR>

noremap <F3> :BuffergatorToggle<CR>
inoremap <F3> <Esc>:BuffergatorToggle<CR>

" Movimiento natural del cursor y no línea a línea
"map <Up> g<Up>
""map <Down> g<Down>
"imap <Up> <C-[> g<Up> i
"imap <Down> <C-[> g<Down> i

"Menús

" clear all the menus
call quickui#menu#reset()

" Menu functions
function! SearchBox()
	let cword = expand('<cword>')
	let title = 'Enter text to search:'
	let text = quickui#input#open(title, cword, 'search')
	if text != ''
		let text = escape(text, '[\/*~^')
		call feedkeys("\<ESC>/" . text . "\<cr>", 'n')
	endif
endfunc

function! GoToLineBox()
	let cword = expand('<cword>')
	let title = 'Go to line:'
	let text = quickui#input#open(title, cword, 'search')
	if text != ''
		let text = escape(text, '[\/*~^')
		call feedkeys("\<ESC>" . text . "G")
	endif
endfunc

function! JumpToMarkBox()
  let content = [
        \ [ 'Mark 0', ],
        \ [ 'Mark 1', ],
        \ [ 'Mark 2', ],
        \ [ 'Mark 3', ],
        \ [ 'Mark 4', ],
        \]
  let opts = {'title': 'select'}
  let text = quickui#listbox#inputlist(content, opts)
  call feedkeys("\<ESC>`" . text)
endfunc

function! InsertMarkBox()
  let content = [
        \ [ 'Mark 0', ],
        \ [ 'Mark 1', ],
        \ [ 'Mark 2', ],
        \ [ 'Mark 3', ],
        \ [ 'Mark 4', ],
        \]
  let opts = {'title': 'select'}
  let text = quickui#listbox#inputlist(content, opts)
  call feedkeys("\<ESC>m" . text)
endfunc

function! SaveSessionBox()
  let content = [
        \ [ 'Session 1', 'mksession ~/.config/nvim/Session-1.vim' ],
        \ [ 'Session 2', 'mksession ~/.config/nvim/Session-2.vim' ],
        \ [ 'Session 3', 'mksession ~/.config/nvim/Session-3.vim' ],
        \ [ 'Session 4', 'mksession ~/.config/nvim/Session-4.vim' ],
        \ [ 'Session 5', 'mksession ~/.config/nvim/Session-5.vim' ],
        \]
  let opts = {'title': 'Select one'}
  call quickui#listbox#open(content, opts)
endfunc

function! LoadSessionBox()
  let content = [
        \ [ 'Session 1', 'source ~/.config/nvim/Session-1.vim' ],
        \ [ 'Session 2', 'source ~/.config/nvim/Session-2.vim' ],
        \ [ 'Session 3', 'source ~/.config/nvim/Session-3.vim' ],
        \ [ 'Session 4', 'source ~/.config/nvim/Session-4.vim' ],
        \ [ 'Session 5', 'source ~/.config/nvim/Session-5.vim' ],
        \]
  let opts = {'title': 'Select one'}
  call quickui#listbox#open(content, opts)
endfunc

function! ToggleFileExplorer()
  " File explorer settings
  let g:netrw_liststyle = 3
  let g:netrw_browse_split = 4
  let g:netrw_altv = 1
  let g:netrw_winsize = 15
  Lexplore
endfunc

" install a 'File' menu, use [text, command] to represent an item.
call quickui#menu#install('&File', [
      \ [ "&New File\t:enew", 'enew' ],
      \ [ "&Open File\t:e file_name", 'execute "e " . system("kdialog --getopenfilename")' ],
      \ [ "&Close\t:q", 'q' ],
      \ [ "--", '' ],
      \ [ "&Save\t:w", 'w'],
      \ [ "Save &As\t:w file_name", 'execute "w " . system("kdialog --getsavefilename")' ],
      \ [ "Save All\t:wa", 'wa' ],
      \ [ "--", '' ],
      \ ["Load session\t:source session.vim", 'call LoadSessionBox()'],
      \ ["Save session\t:mksession session.vim", 'call SaveSessionBox()'],
      \ [ "--", '' ],
      \ [ "E&xit\t:q!", 'q!' ],
      \ ])

" items containing tips, tips will display in the cmdline
call quickui#menu#install('&Edit', [
      \ [ "Undo\tu", 'call feedkeys("\<ESC>u")', '' ],
      \ [ "Redo\tCtrl r", 'call feedkeys("\<ESC>\<C-r>")', '' ],
      \ [ "&Copy\t\"+y", '"+y', '' ],
      \ [ "&Paste\t\"+p", '"+p', '' ],
      \ [ "Select \tv", 'call feedkeys("\<ESC>v")', '' ],
      \ [ "Select block\tCtrl v", 'call feedkeys("\<ESC>\<C-v>")', '' ],
      \ [ "Select all\tggvGG", 'call feedkeys("\<ESC>ggvGG")', '' ],
      \ [ "--", '' ],
      \ ["Find text\t/text", 'call SearchBox()'],
      \ ["Find next\tn", 'call feedkeys("\<ESC>n")'],
      \ ["Go to line\tlineG", 'call GoToLineBox()'],
      \ ["Insert mark\tmx", 'call InsertMarkBox()'],
      \ ["Jump to mark\t`x", 'call JumpToMarkBox()'],
      \ ["Completion\tCtrl n", 'call feedkeys("\<ESC>i\<right>\<C-n>")'],
      \ [ "--", '' ],
      \ ['Show line numbers %{&nu? "Off":"On"}', 'set nu!'],
      \ ['Set &Cursor Line %{&cursorline? "Off":"On"}', 'set cursorline!'],
      \ ])

" script inside %{...} will be evaluated and expanded in the string
call quickui#menu#install("&Tools", [
			\ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!'],
			\ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
      \ [ "Teminal\t:terminal", 'terminal', '' ],
      \ [ "Open/Close file explorer\t:Lexplore", 'call ToggleFileExplorer()', '' ],
      \ [ '--', ''],
      \ [ "Install or update plugins\t:PackerUpdate", 'PackerUpdate'],
      \ [ "Clean plugins\t:PackerClean", 'PackerClean'],
			\ ])

call quickui#menu#install("&Window", [
      \ [ "Buffer List", 'BuffergatorToggle', '' ],
      \ [ "Split horizontal\t:split", 'split', '' ],
      \ [ "Split vertical\t:vsplit", 'vsplit', '' ],
      \ [ "Zoom +\tCtrl +", 'call AdjustFontSize(1)', '' ],
      \ [ "Zoom -\tCtrl -", 'call AdjustFontSize(-1)', '' ],
      \ ])

call quickui#menu#install("&LSP", [
      \ ["LSP Completion\tCtrl x Ctrl o", 'call feedkeys("\<ESC>i\<right>\<C-x>\<C-o>")'],
			\ ["Buffer symbols", 'lua vim.lsp.buf.document_symbol()'],
			\ ["Go declaration\tgD", 'lua vim.lsp.buf.declaration()'],
			\ ["Go definition\tgd", 'lua vim.lsp.buf.definition()'],
      \ ["Show info\tK", 'lua vim.lsp.buf.hover()'],
			\ ["Go implementation\tgi", 'lua vim.lsp.buf.implementation()'],
			\ ["Signature help\tCtrl k", 'lua vim.lsp.buf.signature_help()'],
      \ ['--', ''],
			\ ['Add workspace folder', 'lua vim.lsp.buf.add_workspace_folder()'],
			\ ['Remove workspace folder', 'lua vim.lsp.buf.remove_workspace_folder()'],
			\ ['List workspace folders', 'lua vim.lsp.buf.list_workspace_folders()'],
			\ ['Type definition', 'lua vim.lsp.buf.type_definition()'],
			\ ['Rename', 'lua vim.lsp.buf.rename()'],
			\ ['Code action', 'lua vim.lsp.buf.code_action()'],
			\ ['References', 'lua vim.lsp.buf.references()'],
			\ ['Formatting', 'lua vim.lsp.buf.formatting()'],
      \ ['--', ''],
      \ ["Diagnostic open float\t<space>e", 'lua vim.diagnostic.open_float()'],
      \ ["Diagnostic go to prev\t[d", 'lua vim.diagnostic.goto_prev()'],
      \ ["Diagnostic go to next\t]d", 'lua vim.diagnostic.goto_next()'],
      \ ["Diagnostic setloclist\t<space>q", 'lua vim.diagnostic.open_float()'],
			\ ])

" register HELP menu with weight 10000
call quickui#menu#install('H&elp', [
			\ ["&Cheatsheet", 'help index', ''],
			\ ['T&ips', 'help tips', ''],
			\ ['--',''],
			\ ["&Tutorial", 'help tutor', ''],
			\ ['&Quick Reference', 'help quickref', ''],
			\ ['&Summary', 'help summary', ''],
			\ ], 10000)

" enable to display tips in the cmdline
let g:quickui_show_tip = 1
let g:quickui_border_style = 3
" hit space twice to open menu
noremap <space><space> :call quickui#menu#open()<cr>

