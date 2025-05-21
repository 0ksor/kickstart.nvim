return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- clang-tidy linterını ekle
      lint.linters['clang-tidy'] = {
        cmd = 'clang-tidy',
        stdin = false,
        args = {
          '--quiet',
          '--extra-arg=-std=c++20',
        },
        ignore_exitcode = true,
        stream = 'stderr',
        parser = function(output, bufnr)
          local diagnostics = {}
          for _, line in ipairs(vim.split(output, '\n')) do
            local file, line, col, severity, message = line:match '([^:]+):(%d+):(%d+): (%w+): (.+)'
            if file and line and col and severity and message then
              table.insert(diagnostics, {
                bufnr = bufnr,
                lnum = tonumber(line) - 1,
                col = tonumber(col) - 1,
                severity = severity == 'error' and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
                message = message,
                source = 'clang-tidy',
              })
            end
          end
          return diagnostics
        end,
      }

      -- Linterları filetype'a göre ayarla
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        cpp = { 'clang-tidy' },
        c = { 'clang-tidy' },
        python = { 'flake8' },
      }

      -- Otomatik linting ayarı
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
