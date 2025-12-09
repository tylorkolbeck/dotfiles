-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },

  opts = {

    sources = {
      'filesystem',
      'buffers',
      'git_status',
    },

    git_status = {
      enabled = true,
    },
    filesystem = {

      window = {
        mappings = {
          ['<space>'] = 'none', -- don't open files by accident with space
          -- Core navigation
          ['l'] = 'open', -- open file / expand folder
          ['<CR>'] = 'open',
          ['o'] = 'open',
          ['h'] = 'close_node', -- collapse folder
          ['q'] = 'close_window', -- close neo-tree

          -- Filesystem actions
          ['R'] = 'refresh',
          ['a'] = 'add', -- add file
          ['A'] = 'add_directory', -- add folder
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['m'] = 'move', -- move file/folder
          ['c'] = 'copy',
          ['p'] = 'paste_from_clipboard',

          -- Source navigation (buffers/git/filesystem)
          ['<C-h>'] = 'prev_source',
          ['<C-l>'] = 'next_source',
        },
      },
    },
  },
}
