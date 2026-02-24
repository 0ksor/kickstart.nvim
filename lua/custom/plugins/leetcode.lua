return {
  'kawre/leetcode.nvim',
  event = 'VeryLazy',
  build = ':TSUpdate html',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  },
  opts = {},
}
