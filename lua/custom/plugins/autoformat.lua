return { -- Autoformat
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      cpp = { 'clang-format' },
      c = { 'clang-format' },
      lua = { 'stylua' },
      python = { 'isort', 'black' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = {
      -- I recommend these options. See :help conform.format for details.
      lsp_format = 'fallback',
      timeout_ms = 1000,
    },
  },
}
