-- Set the behavior of tab
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.cmd([[set mouse=a
set title titlestring=%<NeoVim:%F titlelen=70
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

noremap <space><space> :emenu <C-Z>

noremap <F2> :call setqflist(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '{"bufnr": v:val}'))<CR>:copen<CR>
noremap <F3> :cclose<CR>
noremap <F4> :b <C-Z>
noremap <F5> :w<CR>:silent make<CR>:copen<CR>
]])


-- Functions
vim.g.actual_session = 'session.vim'
function save_actual_session()
    local command = ':mksession ' .. vim.g.actual_session
    vim.cmd(command)
end

-- Menus
vim.cmd([[
source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>

menu File.Open  :execute "e " . system("kdialog --getopenfilename 2> /dev/null")<CR>
menu File.Save\ as  :execute "w " . system("kdialog --getsavefilename 2> /dev/null")<CR>
menu File.Save\ all  :wa<CR>

menu Edit.Show\ line\ numbers  :set nu!<CR>
menu Edit.Set\ cursor\ line :set cursorline!<CR>

menu Tools.Spell\ check :set spell!<CR>
menu Tools.Terminal :terminal<CR>
menu Tools.Templates :e ~/.config/nvim/lua/no-packages-snips.lua<CR>

menu Session.Load :execute "source " . system("kdialog --getopenfilename 2> /dev/null")<CR>
menu Session.Save\ as :execute "mksession " . system("kdialog --getsavefilename 2> /dev/null")<CR>
menu Session.Save :lua save_actual_session()<CR>

menu Build.Make\ (F5) :silent make<CR>
]])

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





