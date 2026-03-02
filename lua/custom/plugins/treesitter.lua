return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function() end,
    keymaps = {
      -- keymaps
      vim.keymap.set('n', '<C-l>', function()
        require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner'
      end),
      vim.keymap.set('n', '<C-h>', function()
        require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.outer'
      end),
    },
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {}
    end,
    keymaps = {
      vim.keymap.set('n', '<leader>tc', function()
        require('treesitter-context').toggle()
      end),
    },
  },
}
