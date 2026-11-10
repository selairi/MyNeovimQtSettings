-- Set the behavior of tab
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.cmd([[set mouse=a
set title titlestring=%<NeoVim:%F titlelen=70
set nu
]])

-- Map <Esc>> to exit from terminal mode
vim.cmd([[
tnoremap <Esc> <C-\><C-n>
]])

-- Some shortcuts
vim.cmd([[
noremap <F1> :e ~/.config/nvim/help.txt<CR>
inoremap <F1> <Esc>:e ~/.config/nvim/help.txt<CR>

noremap <tab><tab> :Explore<CR>
noremap <S-tab> :ls<CR>:b

"noremap <space><space> :emenu <C-Z>

noremap <F2> :call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{"bufnr": v:val}'))<CR>:copen<CR>
noremap <F3> :cclose<CR>
noremap <F4> :b <C-Z>
noremap <F5> :w<CR>:silent make<CR>:copen<CR>
]])


-- -----------------------------
-- Snippets

snip_list = {}
-- Load snips
require('no-packages-snips')

function snip_get_last_chars(length)
    local col = vim.fn.col('.')
    local str = vim.fn.getline('.'):sub(col-length+1, col)
    return str
end

function snip_current_line_str_pos(str)
    local position = vim.fn.matchstrpos(vim.fn.getline('.'), str)
    --vim.api.nvim_put({'Pos' .. position[2]}, 'c', true, false)
    return position[2]
end

function snip_get_last_word()
    local col = vim.fn.col('.') + 1
    local word = vim.fn.matchstr(vim.fn.getline('.'), '\\S\\+\\%' .. col .. 'c')
    --vim.api.nvim_put({word}, 'c', true, false)
    return word
end

function snip_run()
    --local str = snip_get_last_chars(4)
    local str = snip_get_last_word()
    local filetype = vim.bo.filetype
    local snippets = snip_list[filetype]
    for key,value in pairs(snippets) do
      if key == str then
        -- Delete key from text
        local key_length = key:len()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_text(0, row - 1, col+1-key_length, row - 1, col+1, { '' })
        if col-key_length < 0 then 
            vim.api.nvim_win_set_cursor(0, {row,0})
        else
            vim.api.nvim_win_set_cursor(0, {row,col-key_length+1})
        end
        vim.api.nvim_put(value, 'c', true, false)
        for line = 1,#value do
            local entry_pos = snip_current_line_str_pos('$1')
            if entry_pos >= 0 then
                vim.api.nvim_buf_set_text(0, row+line-2, entry_pos, row+line-2, entry_pos+2, { '' })
                if entry_pos > 1 then
                    vim.api.nvim_win_set_cursor(0, {row+line-1,entry_pos-1})
                else
                    vim.api.nvim_win_set_cursor(0, {row+line-1,0})
                end
                break
            end
            if line < #value then
                vim.api.nvim_win_set_cursor(0, {row+line,0})
            end
        end
        break
      end
    end
end

vim.cmd([[
"inoremap <S-tab> <ESC>:lua snip_run()<CR>?$1<CR>i
inoremap <S-tab> <ESC>:lua snip_run()<CR>a
]])


-- -----------------------------
-- Menus

local M = {win = nil, buf = nil}

local menu_help = {
  { label = " ⚙️ Mini help", action = function() vim.cmd("e ~/.config/nvim/help.txt") end },
  { label = " ⚙️ Cheatsheet (:help index)", action = function() vim.cmd("help index") end },
  { label = " ⚙️ Tips  (:help tips)", action = function() vim.cmd("help tips") end },
  { label = " ⚙️ Tutorial  (:help tutor)", action = function() vim.cmd("help tutor") end },
  { label = " ⚙️ Quick reference  (:help quickref)", action = function() vim.cmd("help quickref") end },
  { label = " ⚙️ Summary  (:help summary)", action = function() vim.cmd("help summary") end },
}

local menu_windows = {
  { label = " ⚙️ Horizontal split (:split)", action = function() vim.cmd("split") end },
  { label = " ⚙️ Vertical split (:vsplit)", action = function() vim.cmd("vsplit") end },
  { label = " ❌ Close window (:q)", action = function() vim.cmd("q") end },
  { label = " ··· ", action = function() end },
  { label = " ⚙️ New tab page (:tabnew)", action = function() vim.cmd("call feedkeys(\"\\<ESC>:tabnew [name]\", 'nt')") end },
  { label = " ❌ Close tab page (:q)", action = function() vim.cmd("tabclose") end },
  { label = " ··· ", action = function() end },
  { label = " ⚙️ Buffers (:ls)", action = function() vim.cmd("call feedkeys(\"\\<ESC>:ls\\<CR>:b\", 'nt')") end },
}

local menu_lsp = {
  { label = " ⚙️ Enable LSP", action = function() vim.cmd("edit") end },
  { label = " ⚙️ Disable LSP", action = function() vim.cmd("lua vim.lsp.stop_client(vim.lsp.get_active_clients())") end },
  { label = " ··· ", action = function() end },
  { label = " ⚙️ LSP Completion (Ctrl x Ctrl o)", action = function() vim.cmd("call feedkeys(\"\\<ESC>i\\<right>\\<C-x>\\<C-o>\", 'nt')") end },
  { label = " ⚙️ Buffer symbols", action = function() vim.cmd("lua vim.lsp.buf.document_symbol()") end },
  { label = " ⚙️ Go declaration (gD)", action = function() vim.cmd("lua vim.lsp.buf.declaration()") end },
  { label = " ⚙️ Go definition (gd)", action = function() vim.cmd("lua vim.lsp.buf.definition()") end },
  { label = " ⚙️ Show info (K)", action = function() vim.cmd("lua vim.lsp.buf.hover()") end },
  { label = " ⚙️ Go implementation (gi)", action = function() vim.cmd("lua vim.lsp.buf.implementation()") end },
  { label = " ⚙️ Signature help (Ctrl k)", action = function() vim.cmd("lua vim.lsp.buf.signature_help()") end },
  { label = " ··· ", action = function() end },
  { label = " ⚙️ Add workspace folder", action = function() vim.cmd("lua vim.lsp.buf.add_workspace_folder()") end },
  { label = " ⚙️ Remove workspace folder", action = function() vim.cmd("lua vim.lsp.buf.remove_workspace_folder()") end },
  { label = " ⚙️ List workspace folder", action = function() vim.cmd("lua vim.lsp.buf.list_workspace_folder()") end },
  { label = " ⚙️ Type definition", action = function() vim.cmd("lua vim.lsp.buf.type_definition()") end },
  { label = " ⚙️ Rename", action = function() vim.cmd("lua vim.lsp.buf.rename()") end },
  { label = " ⚙️ Code action", action = function() vim.cmd("lua vim.lsp.buf.code_action()") end },
  { label = " ⚙️ References", action = function() vim.cmd("lua vim.lsp.buf.references()") end },
  { label = " ⚙️ Formatting", action = function() vim.cmd("lua vim.lsp.buf.formatting()") end },
  { label = " ··· ", action = function() end },
  { label = " ⚙️ Diagnostic open float (<space>e)", action = function() vim.cmd("lua vim.diagnostic.open_float()") end },
  { label = " ⚙️ Diagnostic go to prev ([d)", action = function() vim.cmd("lua vim.diagnostic.goto_prev()") end },
  { label = " ⚙️ Diagnostic go to next (]d)", action = function() vim.cmd("lua vim.diagnostic.goto_next()") end },
  { label = " ⚙️ Diagnostic setloclist (<space>q)", action = function() vim.cmd("lua vim.diagnostic.open_float()") end },
}

local menu_tools = {
  { label = " ⚙️ Spell check (:set spell!)", action = function() vim.cmd("set spell!") end },
  { label = " 🐚 Terminal  (:terminal)", action = function() vim.cmd("terminal") end },
  { label = " ⚙️ Edit snippets ", action = function() vim.cmd("e ~/.config/nvim/lua/no-packages-snips.lua") end },
  { label = " ··· ", action = function() end },
  { label = " ⚙️ Make (F5)", action = function() vim.cmd("silent make") end },
  { label = " ··· ", action = function() end },
  { label = " ⚙️ Load session", action = function() vim.cmd("execute \"source \" . system(\"kdialog --getopenfilename 2> /dev/null\")") end },
  { label = " ⚙️ Save session", action = function() vim.cmd("execute \"mksession \" . system(\"kdialog --getsavefilename 2> /dev/null\")") end },
  { label = " ··· ", action = function() end },
  { label = " ⚙️ Color scheme (:colorscheme)", action = function() vim.cmd("call feedkeys(\"\\<ESC>:colorscheme \\<TAB>\", 'nt')") end },
  { label = " ☀️ Light theme (:colorscheme shine)", action = function() vim.cmd("colorscheme shine") end },
  { label = " 🌒 Dark theme (:colorscheme desert)", action = function() vim.cmd("colorscheme desert") end },
  { label = " ⚙️ Soft theme (:colorscheme catppuccin)", action = function() vim.cmd("colorscheme catppuccin") end },
  { label = " ⚙️ Default theme (:colorscheme default)", action = function() vim.cmd("colorscheme default") end },
  { label = " ··· ", action = function() end },
  { label = " ⚙️ Edit settings", action = function() vim.cmd("Explore ~/.config/nvim") end },
}

local menu_edit_insert_mark = {
  { label = " ⚙️ Mark 0 (m0)", action = function() vim.cmd("call feedkeys(\"m0\", 'nt')") end },
  { label = " ⚙️ Mark 1 (m1)", action = function() vim.cmd("call feedkeys(\"m1\", 'nt')") end },
  { label = " ⚙️ Mark 2 (m2)", action = function() vim.cmd("call feedkeys(\"m2\", 'nt')") end },
  { label = " ⚙️ Mark 3 (m3)", action = function() vim.cmd("call feedkeys(\"m3\", 'nt')") end },
  { label = " ⚙️ Mark 4 (m4)", action = function() vim.cmd("call feedkeys(\"m4\", 'nt')") end },
}

local menu_edit_jump_to_mark = {
  { label = " ⚙️ Mark 0 (`0)", action = function() vim.cmd("call feedkeys(\"`0\", 'nt')") end },
  { label = " ⚙️ Mark 1 (`1)", action = function() vim.cmd("call feedkeys(\"`1\", 'nt')") end },
  { label = " ⚙️ Mark 2 (`2)", action = function() vim.cmd("call feedkeys(\"`2\", 'nt')") end },
  { label = " ⚙️ Mark 3 (`3)", action = function() vim.cmd("call feedkeys(\"`3\", 'nt')") end },
  { label = " ⚙️ Mark 4 (`4)", action = function() vim.cmd("call feedkeys(\"`4\", 'nt')") end },
}

local menu_edit_copy = {
  { label = " ⚙️ Register a (\"ay)", action = function() vim.api.nvim_input("gv\"ay") end },
  { label = " ⚙️ Register b (\"by)", action = function() vim.api.nvim_input("gv\"by") end },
  { label = " ⚙️ Register c (\"cy)", action = function() vim.api.nvim_input("gv\"cy") end },
  { label = " ⚙️ Register d (\"dy)", action = function() vim.api.nvim_input("gv\"dy") end },
}

local menu_edit_paste = {
  { label = " ⚙️ Register a (\"ap)", action = function() vim.api.nvim_input("\"ap") end },
  { label = " ⚙️ Register b (\"bp)", action = function() vim.api.nvim_input("\"bp") end },
  { label = " ⚙️ Register c (\"cp)", action = function() vim.api.nvim_input("\"cp") end },
  { label = " ⚙️ Register d (\"dp)", action = function() vim.api.nvim_input("\"dp") end },
}

function go_to_line()
  vim.ui.input(
    { prompt = 'Line: ', default = '1' },
    function(input)
      if input then
        vim.cmd("call feedkeys(\"" .. input .. "G\", 'nt')")
      end
    end
  )
end

local menu_edit = {
  { label = " ⎌ Undo (:undo)", action = function() vim.cmd("undo") end },
  { label = " ↷ Redo (:redo)", action = function() vim.cmd("redo") end },
  { label = " ⚙️ Copy (\"+y)", action = function() vim.api.nvim_input("gv\"+y") end },
  { label = " ⚙️ Copy to register (\"xy)", action =  function() M.menu_open(menu_edit_copy) end },
  { label = " ⚙️ Paste (\"+p)", action = function() vim.api.nvim_feedkeys("\"+p", 'nt', false) end },
  { label = " ⚙️ Paste from register (\"xp)", action =  function() M.menu_open(menu_edit_paste) end },
  { label = " ⚙️ Select all", action = function() vim.api.nvim_feedkeys('GG$vgg0', 'nt', false) end },
  { label = " ⚙️ Block Select (Ctrl v)", action = function()
    vim.ui.input(
      { prompt = 'Press I to block edit and ESC (press enter to continue)' },
      function(input)
        if input then
          vim.cmd("call feedkeys(\"\\<C-V>\", 'nt')")
        end
      end
    )
  end },
  { label = " ··· ", action = function() end },
  { label = " ⚙️ Go to line (lineG)", action =  function() go_to_line() end },
  { label = " ⚙️ Insert mark (mx)", action =  function() M.menu_open(menu_edit_insert_mark) end },
  { label = " ⚙️ Jump to mark (`x)", action =  function() M.menu_open(menu_edit_jump_to_mark) end },
  { label = " ··· ", action = function() end },
  { label = " ⚙️ Show line numbers (:set nu!)", action = function() vim.cmd("set nu!") end },
  { label = " ⚙️ Set cursor line (:set cursorline!)", action = function() vim.cmd("set cursorline!") end },
  { label = " ⚙️ Reformat all code (ggvGG=)", action = function() vim.api.nvim_feedkeys('ggvGG=', 'nt', false) end },
  { label = " ⚙️ Reformat selected code (=)", action = function() vim.api.nvim_input('gv=') end },
}

local menu_file = {
  { label = " 📂 Open (Built-in) (:Explore)", action = function() vim.cmd("Explore") end },
  { label = " 📂 Open (kdialog)", action = function() vim.cmd("execute \"e \" . system(\"kdialog --getopenfilename 2> /dev/null\")") end },
  { label = " 📂 Save (kdialog)", action = function() vim.cmd("execute \"w \" . system(\"kdialog --getsavefilename 2> /dev/null\")") end },
  { label = " 🕒 Save all", action = function() vim.cmd("wa") end },
  { label = " ··· ", action = function() end },
  { label = " ❌ Save all and Exit (:wqa)", action = function() vim.cmd("wqa") end },
  { label = " ❌ Exit (:qa!)", action = function() vim.cmd("qa!") end },
}

local menu_main = {
  { label = " 📂 File ", action = function() M.menu_open(menu_file) end },
  { label = " ⚙️ Edit ", action = function() M.menu_open(menu_edit) end },
  { label = " 🕒 LSP", action = function() M.menu_open(menu_lsp) end },
  { label = " 🔨 Tools", action = function() M.menu_open(menu_tools) end },
  { label = " ⚙️ Windows", action = function() M.menu_open(menu_windows) end },
  { label = " ⚙️ Help", action = function() M.menu_open(menu_help) end },
}

function M.menu_open(menu_items)
  -- New buffer
  M.buf = vim.api.nvim_create_buf(false, true)
  
  -- Get text from menu items
  local width = 40
  local lines = {}
  for _, item in ipairs(menu_items) do
    table.insert(lines, item.label)
    if string.len(item.label) > width then
      width = string.len(item.label)
    end
  end
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, lines)

  -- Getting size
  local height = #menu_items
  local screen_width = vim.o.columns
  local screen_height = vim.o.lines
  
  if width > (screen_width - 4) then
    width = screen_width - 4
  end

  local row = math.ceil((screen_height - height) / 2 - 1)
  local col = math.ceil((screen_width - width) / 2)

  -- floating window settings
  local win_opts = {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " Menu (<ESC> to close)",
    title_pos = "center",
  }

  -- Open floating window
  M.win = vim.api.nvim_open_win(M.buf, true, win_opts)
  
  -- Disable numbers and enable useful appearance
  vim.wo[M.win].number = false
  vim.wo[M.win].relativenumber = false
  vim.wo[M.win].wrap = false
  vim.wo[M.win].cursorline = true

  -- Keys - Shortcuts
  local opts = { replace_keycodes = true, silent = true, buffer = M.buf, expr = true }

  -- Close with q or 'Esc'
  vim.keymap.set("n", "q", M.menu_close, opts)
  vim.keymap.set("n", "<Esc>", M.menu_close, opts)

  -- Select option with enter
  vim.keymap.set("n", "<CR>", function()
    local cursor = vim.api.nvim_win_get_cursor(M.win)
    local idx = cursor[1]
    M.menu_close()
    vim.schedule(function()
      menu_items[idx].action()
    end)
  end, opts)

end

function M.menu_close()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.schedule(function() 
      vim.api.nvim_win_close(M.win, true) 
      vim.api.nvim_buf_delete(M.buf, {force = true})
    end)
  end
end

vim.keymap.set("n", "<space><space>", function() M.menu_open(menu_main) end, { desc = "Menu" })
vim.keymap.set("v", "<space><space>", function() M.menu_open(menu_main) end, { desc = "Menu" })

return M



