vim.pack.add { 'https://github.com/folke/which-key.nvim' }

local wk = require('which-key')

wk.setup {
  preset = 'helix',
  defaults = {},
  spec = {{
    mode = {'n', 'x'},
    { '<leader>l', group = 'vimtex' },
    { '<leader>q', group = 'session' },
    { '<leader>s', group = 'search' },
    { '<leader>u', group = 'ui' },
    { '<leader>x', group = 'diagnostics/quickfix' },
    { '[', group = 'prev' },
    { ']', group = 'next' },
    { 'g', group = 'goto' },
    { 'z', group = 'fold' },
    { '<leader>b', group = 'buffer',
      expand = function()
        return require('which-key.extras').expand.buf()
      end
    },
    { '<leader>w', group = 'windows',
      proxy = '<c-w>',
      expand = function()
        return require('which-key.extras').expand.win()
      end
    },
  }}

}

vim.keymap.set('n', '<leader>?', function()
  require('which-key').show({ global = false })
end, { desc = 'Buffer Keymaps (which-key)' })

vim.keymap.set('n', '<c-w><space>', function()
  require('which-key').show({ keys = '<c-w>', loop = false })
end, { desc = 'Window Hydra Mode (which-key)' })
