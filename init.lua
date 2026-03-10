require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
  },

  { 'RRethy/vim-hexokinase', lazy = false },

  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.gitsigns',
  -- require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',

  require 'custom.plugins.telescope',
  require 'custom.plugins.harpoon',
  require 'custom.plugins.guess_indent',
  require 'custom.plugins.alpha',
  require 'custom.plugins.autocomplete',
  require 'custom.plugins.treesitter',
  require 'custom.plugins.mininvim',
  require 'custom.plugins.lsp',
  require 'custom.plugins.autoformat',
  require 'custom.plugins.sql_plugs',
  require 'custom.plugins.telekasten',
  require 'custom.plugins.gitsigns',
  require 'custom.plugins.which_key',
  require 'custom.plugins.vimwiki',
  require 'custom.plugins.tokyonight',
  require 'custom.plugins.lazydev',
  require 'custom.plugins.todo_comments',
  require 'custom.plugins.leetcode',
  require 'custom.plugins.oil',
  require 'custom.plugins.platformio',
  require 'custom.plugins.sleuth',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
-- vim.o.updatetime = 1000 -- 1 saniye (1000 ms)

-- vim.api.nvim_create_autocmd('CursorHold', {
--   callback = function()
--     vim.lsp.buf.hover()
--   end,
-- })
--
--
--

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.api.nvim_set_hl(0, '@variable', { fg = '#E0AF86' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cpp, c',
  callback = function()
    vim.api.nvim_set_hl(0, '@variable.parameter', { fg = '#2d82b7' })
    vim.api.nvim_set_hl(0, '@variable', { fg = '#5fafff' })
  end,
})
