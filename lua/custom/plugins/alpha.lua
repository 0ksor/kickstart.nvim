return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local dashboard = require 'alpha.themes.dashboard'

    vim.api.nvim_create_user_command('FindHere', function()
      require('telescope.builtin').find_files {
        find_command = { 'find', '.', '-maxdepth', '1', '-type', 'f' },
      }
    end, {})

    dashboard.section.header.val = {
      [[                               __                ]],
      [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
      [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
      [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \_\ \ ]],
      [[\ \_\ \_\ \____\ \____/\ \___/  \_\_\ \_\ \____/ ]],
      [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/___/  ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button('e', 'New File', ':ene <BAR> startinsert<CR>'),
      dashboard.button('f', 'Find File', ':Telescope find_files<CR>'),
      dashboard.button('F', 'Find Here (Non-recursive)', ':FindHere<CR>'),
      dashboard.button('r', 'Recent Files', ':Telescope oldfiles<CR>'),
      dashboard.button('g', 'Search Text', ':Telescope live_grep<CR>'),
      dashboard.button('q', 'Quit', ':qa<CR>'),
      dashboard.button('c', 'Config', ':e $MYVIMRC<CR>'),
      dashboard.button('C', 'Config', ':e' .. vim.fn.expand '~/.config/hypr/my_scripts.conf <CR>'),
      {
        type = 'text',
        val = '──────────────────────────────',
        opts = { position = 'center', hl = 'Comment' },
      },
      { type = 'text', val = 'Frequently Used Files', opts = { position = 'center', hl = 'Title' } },
      dashboard.button('t', ' Tockens', ':e ' .. vim.fn.expand '~/.t' .. '<CR>'),
    }

    require('alpha').setup(dashboard.config)
  end,
}
