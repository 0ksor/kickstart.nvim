return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI',
    },
  },
  config = function()
    local dap = require 'dap'
    local ui = require 'dapui'
    local dap_virtual_text = require 'nvim-dap-virtual-text'

    -- Dap Virtual Text
    dap_virtual_text.setup {}

    -- codelldb adapter
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
        args = { '--port', '${port}' },
      },
    }

    -- Configurations
    dap.configurations.rust = {
      {
        name = 'Debug executable',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local metadata_json = vim.fn.system 'cargo metadata --format-version 1 --no-deps'
          local metadata = vim.fn.json_decode(metadata_json)
          local target_dir = metadata.target_directory
          local default_exe = target_dir .. '/debug/' .. vim.fn.input 'Executable name: '
          return vim.fn.input('Path to executable: ', default_exe, 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    dap.configurations.cpp = {
      {
        name = 'Launch file',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp

    -- Dap UI
    ui.setup()
    vim.fn.sign_define('DapBreakpoint', { text = '🐞' })

    dap.listeners.after.event_initialized['dapui_config'] = ui.open
    dap.listeners.before.event_terminated['dapui_config'] = ui.close
    dap.listeners.before.event_exited['dapui_config'] = ui.close
  end,
}
