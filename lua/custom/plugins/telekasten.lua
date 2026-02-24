return {
  'renerocksai/telekasten.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('telekasten').setup {
      home = vim.fn.expand '~/files/notes',
      take_over_my_home = true,
      auto_set_filetype = false,
    }
  end,
}
