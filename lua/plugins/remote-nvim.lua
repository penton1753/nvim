vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
})

vim.pack.add({
  'https://github.com/amitds1997/remote-nvim.nvim'
})

require('remote-nvim').setup {}
