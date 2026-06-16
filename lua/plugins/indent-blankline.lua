vim.pack.add({ 'https://github.com/lukas-reineke/indent-blankline.nvim' })

local function ibl_setup()
require('ibl').setup {
  scope = {
    show_start = false,
    show_end = false,
  },

  indent = {
    char = '│',
  }
}
end

ibl_setup()

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'chroma',
  callback = ibl_setup
})
