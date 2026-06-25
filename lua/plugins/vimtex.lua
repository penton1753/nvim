if vim.loop.os_uname().sysname == "Darwin" then
  vim.g.vimtex_view_method = 'skim'
  vim.g.vimtex_skim_sync = 1
  vim.g.vimtex_view_skim_activate = 1
else
  vim.g.vimtex_view_method = 'zathura'
end
  
vim.g.vimtex_compiler_latexmk_engines = { _ = '-xelatex' }

vim.pack.add { 'https://github.com/lervag/vimtex' }
