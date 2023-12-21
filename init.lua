
-- Set the behavior of tab
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.cmd [[set mouse=a
set title titlestring=%<NeoVim:%F titlelen=70
]]

-- Map <Esc>> to exit from terminal mode
vim.cmd([[
tnoremap <Esc> <C-\><C-n>
]])

-- SnipMate config
-- Remove SnipMate error
vim.cmd([[
let g:snipMate = { 'snippet_version' : 1 }
]])

-- Some shortcuts
vim.cmd([[
noremap <F1> :e ~/.config/nvim/help.txt<CR>
inoremap <F1> <Esc>:e ~/.config/nvim/help.txt<CR>

noremap <tab><tab> :BuffergatorToggle<CR>
inoremap <F3> <Esc>:BuffergatorToggle<CR>

noremap <S-tab><S-tab> :TagbarToggle<CR>
]])

-- Menus
vim.cmd([[
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
        \ [ 'Session 1', 'mksession! ~/.config/nvim/Session-1.vim' ],
        \ [ 'Session 2', 'mksession! ~/.config/nvim/Session-2.vim' ],
        \ [ 'Session 3', 'mksession! ~/.config/nvim/Session-3.vim' ],
        \ [ 'Session 4', 'mksession! ~/.config/nvim/Session-4.vim' ],
        \ [ 'Session 5', 'mksession! ~/.config/nvim/Session-5.vim' ],
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
      \ [ "&Open File\t:e file_name", 'execute "e " . system("kdialog --getopenfilename 2> /dev/null")' ],
      \ [ "&Close\t:q", 'q' ],
      \ [ "--", '' ],
      \ [ "&Save\t:w", 'w'],
      \ [ "Save &As\t:w file_name", 'execute "w " . system("kdialog --getsavefilename 2> /dev/null")' ],
      \ [ "Save All\t:wa", 'wa' ],
      \ [ "--", '' ],
      \ ["Load session\t:source session.vim", 'call LoadSessionBox()'],
      \ ["Save session\t:mksession session.vim", 'call SaveSessionBox()'],
      \ [ "--", '' ],
      \ [ "E&xit\t:qa!", 'qa!' ],
      \ [ "Save all and E&xit\t:wqa", 'wqa' ],
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
      \ ["Enable LSP", 'edit'],
      \ ["Disable LSP", 'lua vim.lsp.stop_client(vim.lsp.get_active_clients())'],
      \ ['--', ''],  
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

]])

-- LSP Config

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- LSP servers

require'lspconfig'['clangd'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

require'lspconfig'['jdtls'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

require'lspconfig'['eslint'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

require'lspconfig'['tsserver'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

require'lspconfig'['pylsp'].setup{
  on_attach = on_attach,
  flags = lsp_flags,
}

