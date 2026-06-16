vim.keymap.set({ 'i', 'n', 'v', 't', 's', 'c', 'x' }, '<C-/>', '<Esc>', {
  noremap = true,
  silent = true
})

vim.keymap.set({ 'i', 'n', 'v', 't', 's', 'c', 'x' }, '<C-_>', '<Esc>', {
  noremap = true,
  silent = true
})

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-/>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-_>', '<cmd>nohlsearch<CR>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-/><C-/>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-_><C-_>', '<C-\\><C-n>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', {
    desc = 'Move focus to the left window'
})
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', {
    desc = 'Move focus to the right window'
})
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', {
    desc = 'Move focus to the lower window'
})
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', {
    desc = 'Move focus to the upper window'
})

vim.keymap.set('n', '<Enter>', 'o<Esc>')
vim.keymap.set('n', '<S-Enter>', 'O<Esc>')
