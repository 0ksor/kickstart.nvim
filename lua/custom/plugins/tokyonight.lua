return {
  'folke/tokyonight.nvim',
  lazy = false,
  config = function()
    require('tokyonight').setup {
      style = 'night',
      transparent = true,
      --- You can override specific color groups to use other groups or a hex color
      --- function will be called with a ColorScheme table
      ---@param colors ColorScheme
      on_colors = function(colors) end,

      --- You can override specific highlights to use other groups or a hex color
      --- function will be called with a Highlights and ColorScheme table
      ---@param highlights tokyonight.Highlights
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors) end,

      cache = true, -- When set to true, the theme will be cached for better performance
    }
    vim.cmd 'colorscheme tokyonight'
  end,
}
