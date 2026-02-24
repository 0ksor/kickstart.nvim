return {
  'stevearc/oil.nvim',
  lazy = false,

  keys = {
    { '<leader>n', '<cmd>Oil<CR>', desc = 'Open Oil File Explorer' },
    {
      'ga',
      function()
        local oil = require 'oil'
        vim.g.oil_detail = not vim.g.oil_detail

        if vim.g.oil_detail then
          oil.set_columns { 'icon', 'permissions', 'size', 'mtime' }
        else
          oil.set_columns { 'icon' }
        end
      end,
      desc = 'Toggle detail view',
    },
  },

  config = function()
    --------------------------------------------------
    -- GIT STATUS CACHE
    --------------------------------------------------

    local function parse_output(proc)
      local result = proc:wait()
      local ret = {}

      if result.code == 0 then
        for line in vim.gsplit(result.stdout, '\n', { plain = true, trimempty = true }) do
          line = line:gsub('/$', '')
          ret[line] = true
        end
      end

      return ret
    end

    local function new_git_status()
      return setmetatable({}, {
        __index = function(self, key)
          local ignore_proc = vim.system({ 'git', 'ls-files', '--ignored', '--exclude-standard', '--others', '--directory' }, { cwd = key, text = true })

          local tracked_proc = vim.system({ 'git', 'ls-tree', 'HEAD', '--name-only' }, { cwd = key, text = true })

          local ret = {
            ignored = parse_output(ignore_proc),
            tracked = parse_output(tracked_proc),
          }

          rawset(self, key, ret)
          return ret
        end,
      })
    end

    local git_status = new_git_status()

    --------------------------------------------------
    -- Refresh hook
    --------------------------------------------------

    local refresh = require('oil.actions').refresh
    local orig = refresh.callback

    refresh.callback = function(...)
      git_status = new_git_status()
      orig(...)
    end

    --------------------------------------------------
    -- Setup
    --------------------------------------------------

    require('oil').setup {
      win_options = {
        signcolumn = 'yes:2',
      },

      preview_win = {
        update_on_cursor_moved = true,
        preview_method = 'fast_scratch',
        disable_preview = function(filename)
          return vim.fn.getfsize(filename) > 1024 * 1024
        end,
      },

      delete_to_trash = true,

      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = true,
      },

      use_default_keymaps = false,

      keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['g~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
        ['<BS>'] = 'actions.parent',
      },

      view_options = {
        show_hidden = false,

        is_hidden_file = function(name, bufnr)
          local oil = require 'oil'
          local dir = oil.get_current_dir(bufnr)
          local is_dotfile = vim.startswith(name, '.')

          if not dir then
            return is_dotfile
          end

          if not git_status[dir] then
            return is_dotfile
          end

          if is_dotfile then
            return not git_status[dir].tracked[name]
          else
            return git_status[dir].ignored[name]
          end
        end,
      },
    }
  end,
}
