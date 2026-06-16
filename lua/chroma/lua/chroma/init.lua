local M = {}

local function apply_term_colors(colors)
  vim.g.terminal_color_0 = colors.black
  vim.g.terminal_color_1 = colors.red
  vim.g.terminal_color_2 = colors.green
  vim.g.terminal_color_3 = colors.yellow
  vim.g.terminal_color_4 = colors.blue
  vim.g.terminal_color_5 = colors.magenta
  vim.g.terminal_color_6 = colors.cyan
  vim.g.terminal_color_7 = colors.silver
  vim.g.terminal_color_8 = colors.gray
  vim.g.terminal_color_9 = colors.bright_red
  vim.g.terminal_color_10 = colors.bright_green
  vim.g.terminal_color_11 = colors.bright_yellow
  vim.g.terminal_color_12 = colors.bright_blue
  vim.g.terminal_color_13 = colors.bright_magenta
  vim.g.terminal_color_14 = colors.bright_cyan
  vim.g.terminal_color_15 = colors.white
  vim.g.terminal_color_background = colors.bg
  vim.g.terminal_color_foreground = colors.fg
end

local function apply()
  local palette = require("chroma.palette")
  apply_term_colors(palette())
  local groups = require("chroma.groups").setup()

  -- set defined highlights
  for group, setting in pairs(groups) do
    vim.api.nvim_set_hl(0, group, setting)
  end
end

M.setup = function()
  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    callback = function()
      if vim.g.colors_name == "chroma" then
        M.load()
      end
    end,
  })
end


M.load = function()
  -- reset colors
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.g.colors_name = "chroma"

  apply()

  -- forces colorscheme reload (fixes ibl)
  vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "chroma" })
end

return M
