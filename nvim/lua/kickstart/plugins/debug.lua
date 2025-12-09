-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
-- Primarily focused on configuring the debugger for Go.

return {
  -- Core DAP plugin
  'mfussenegger/nvim-dap',

  -- Dependencies
  dependencies = {
    'rcarriga/nvim-dap-ui', -- nice UI
    'nvim-neotest/nvim-nio', -- required by dap-ui
    'mason-org/mason.nvim', -- installer
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go', -- Go-specific adapter
  },

  -- Keymaps
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
      desc = 'Debug: Toggle DAP UI',
    },
    -- 🔥 Close everything hotkey
    {
      '<F6>',
      function()
        local dap = require 'dap'
        local dapui = require 'dapui'

        -- Try to stop any running session
        pcall(dap.terminate)

        -- Close REPL + UI, ignore errors if they aren't open
        pcall(dap.repl.close)
        pcall(dapui.close)
      end,
      desc = 'Debug: Close debugger UI',
    },
  },

  -- Configuration
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- mason-nvim-dap: install / manage debug adapters
    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve', -- Go debugger
      },
    }

    -- DAP UI setup
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      layouts = {
        {
          elements = { 'scopes', 'breakpoints', 'stacks', 'watches' },
          size = 40,
          position = 'left',
        },
        {
          elements = {
            { id = 'repl', size = 1 },
            -- { id = 'console', size = 0.70 },
          },
          size = 10,
          position = 'bottom',
        },
      },
    }

    -- When debugging starts: open UI + REPL
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end

    -- NOTE: we do NOT auto-close on terminate/exited anymore
    -- so you can inspect output & state after program ends.

    -- Go-specific config
    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
        -- If using wsl switch detached to:
        -- detached = false
        coonsole = 'internalConsole',
        -- Send stdout/stderr to the internal DAP console (shown in dap-ui)
        -- console = 'internalConsole',
      },
    }
    -- Patch all Go debug configurations to use delve's remote output mode
    dap.configurations.go = dap.configurations.go or {}
    for _, cfg in ipairs(dap.configurations.go) do
      cfg.outputMode = 'remote'
    end
  end,
}
