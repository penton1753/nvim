vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons' }
vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }

local chroma_theme = require('chroma.lualine')

require('lualine').setup {
  options = {
    theme = chroma_theme,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
  },
}

-- vim.api.nvim_create_autocmd('OptionSet', {
  -- pattern = 'background',
  -- callback = function()
    -- local lualine = require('lualine')
    -- local config = lualine.get_config()
    -- config.options.theme = chroma_theme
    -- lualine.setup(config)
  -- end
-- })
