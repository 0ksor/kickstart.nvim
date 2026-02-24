vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.virtualedit = 'all'
vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.keymap.set('i', '<C-c', '<Esc>')
vim.keymap.set('n', 'x', '"_x')
vim.keymap.set('n', 'X', '"_X')
vim.keymap.set('x', '<leader>rr', '"_dP')

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'c,cpp',
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- hop to the preious file

local last_file = nil
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local current = vim.api.nvim_buf_get_name(0)
    if current ~= last_file then
      vim.g.prev_file, last_file = last_file, current
    end
  end,
})

vim.keymap.set('n', '<leader>v', function()
  if vim.g.prev_file then
    vim.cmd('edit ' .. vim.g.prev_file)
  end
end, { desc = '[B]ack to previous file' })

-- o upgraded
vim.keymap.set('n', 'o', function()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  local brace_col = line:find '{'
  if line:match '{%}$' then
    vim.api.nvim_win_set_cursor(0, { row, brace_col })
    vim.cmd 'startinsert'
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'i', true)
  else
    vim.api.nvim_feedkeys('o', 'n', false)
  end
end, { noremap = true, silent = true })

-- true <-> false toggle
local function toggle_true_false()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  -- sütun bazlı kelime arama
  local start_col, end_col = line:find('true', col + 1)
  local start_col2, end_col2 = line:find('True', col + 1)
  if start_col then
    -- true ise false yap
    line = line:sub(1, start_col - 1) .. 'false' .. line:sub(end_col + 1)
  elseif start_col2 then
    line = line:sub(1, start_col2 - 1) .. 'False' .. line:sub(end_col2 + 1)
  else
    start_col, end_col = line:find('false', col + 1)
    start_col2, end_col2 = line:find('False', col + 1)
    if start_col then
      -- false ise true yap
      line = line:sub(1, start_col - 1) .. 'true' .. line:sub(end_col + 1)
    elseif start_col2 then
      line = line:sub(1, start_col2 - 1) .. 'True' .. line:sub(end_col2 + 1)
    else
      return -- ne true ne false bulundu
    end
  end

  vim.api.nvim_set_current_line(line)
end

-- ss tuşunu normal modda bağla
vim.keymap.set('n', 'ss', toggle_true_false, { noremap = true, silent = true })

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = false

vim.opt.scrolloff = 10

vim.opt.confirm = true

-- vimviki

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'vimwiki',
  callback = function()
    local key1 = vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
    local key2 = vim.api.nvim_replace_termcodes('<enter>', true, false, true)
    for i = 1, 9 do
      local key = 'g' .. i
      local pattern = string.format([[^\s*%d\.]], i)
      vim.keymap.set('n', key, function()
        vim.fn.search(pattern)
        vim.api.nvim_feedkeys(key1, 'm', false)
        vim.api.nvim_feedkeys(key2, 'm', false)
      end, { buffer = true })
    end
  end,
})

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

vim.keymap.set('n', '<leader>sa', function()
  -- Tüm dosyayı al
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  -- Satırları birleştir ve + register'ına ekle
  vim.fn.setreg('+', table.concat(lines, '\n'))
  print 'File yanked to clipboard!'
end, { desc = 'Yank the entire file to clipboard' })
vim.keymap.set('n', '<leader>sp', function()
  -- Clipboard'daki içeriği al
  local clipboard_content = vim.fn.getreg '+'
  -- Buffer'ı seç
  local buf_lines = vim.api.nvim_buf_line_count(0)

  -- Tüm buffer'ı güncelle
  vim.api.nvim_buf_set_lines(0, 0, buf_lines, false, vim.split(clipboard_content, '\n'))
  print 'Buffer replaced with clipboard content!'
end, { desc = 'Replace buffer with clipboard content' })

vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true })

vim.keymap.set('n', '<C-m>', '$', { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', '%', { noremap = true, silent = true })

-- vim.keymap.set('i', 'jj', '<Esc>j')
-- vim.keymap.set('i', 'kk', '<Esc>k')

vim.keymap.set('n', '<A-o>', 'o<Esc>', { noremap = true, silent = true }) -- Alt + o alt satır
vim.keymap.set('n', '<A-O>', 'O<Esc>', { noremap = true, silent = true }) -- Alt + Shift + o üst satır

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-c>', '<cmd>nohlsearch<CR>')

-- terminal açmak için
vim.keymap.set('n', '<leader>tt', function()
  -- dosya yolu
  local path = vim.fn.expand '%:p:h'
  -- tmux komutu
  local cmd = "tmux split-window -v -l 15 'cd " .. path .. " && exec $SHELL'"
  -- shell'e gönder
  os.execute(cmd)
end, { desc = 'Open tmux split in file directory' })

vim.keymap.set('n', '<C-z>', function()
  vim.cmd 'wa' -- tüm dosyaları kaydet
  vim.api.nvim_feedkeys('\026', 'n', false) -- gerçek Ctrl-Z göndermek için: \026 = <C-z>
end, { noremap = true, silent = true })

vim.keymap.set('n', 'cc', '0D', { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- arduino keymaps
-- platformio.ini dosyasını yukarı doğru arar
local function find_pio_root(start_path)
  local path = vim.fn.fnamemodify(start_path or vim.fn.expand '%:p', ':p')
  while path ~= '/' do
    if vim.fn.filereadable(path .. '/platformio.ini') == 1 then
      return path
    end
    path = vim.fn.fnamemodify(path, ':h')
  end
  return nil
end

-- Piorun için keymap
vim.keymap.set('n', '<leader>pr', function()
  local root = find_pio_root()
  if root then
    vim.cmd('cd ' .. root)
    vim.cmd 'Piorun'
  else
    vim.notify('platformio.ini not found!', vim.log.levels.ERROR)
  end
end, { desc = 'Arduino [P]latformIO [R]un' })

-- Piomon için keymap
vim.keymap.set('n', '<leader>pm', function()
  local root = find_pio_root()
  if root then
    vim.cmd('cd ' .. root)
    vim.cmd 'Piomon'
  else
    vim.notify('platformio.ini not found!', vim.log.levels.ERROR)
  end
end, { desc = 'Arduino [P]latformIO [M]on' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>sF', ':FindHere<CR>', { desc = 'Find files non-recursive' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.keymap.set('n', 's', 's', { noremap = true, silent = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

