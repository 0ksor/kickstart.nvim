return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      local treesitter = require 'nvim-treesitter.configs'

      -- configure treesitter
      treesitter.setup { -- enable syntax highlighting
        auto_install = true,
        sync_install = true,
        modules = {},
        highlight = {
          enable = true,
        },
        -- enable indentation
        indent = { enable = true },
        -- ensure these language parsers are installed
        ensure_installed = {
          'json',
          'javascript',
          'typescript',
          'tsx',
          'yaml',
          'html',
          'css',
          'prisma',
          'markdown',
          'markdown_inline',
          'svelte',
          'graphql',
          'bash',
          'lua',
          'vim',
          'dockerfile',
          'gitignore',
          'query',
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<C-space>',
            node_incremental = '<C-space>',
            scope_incremental = false,
            node_decremental = '<bs>',
          },
        },
      }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function() end,
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
