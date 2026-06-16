return function()
  local palette = require("chroma.palette")

  local colors = palette()

  local normal = {
    a = { fg = colors.fg, bg = colors.dark_blue, gui = "bold" },
    b = { fg = colors.fg, bg = colors.comment },
    c = { fg = colors.gray, bg = colors.statusline },
  }

  local command = {
    a = { fg = colors.fg, bg = colors.dark_yellow, gui = "bold" },
  }

  local visual = {
    a = { fg = colors.fg, bg = colors.dark_magenta, gui = "bold" },
  }

  local replace = {
    a = { fg = colors.fg, bg = colors.dark_red, gui = "bold" },
  }

  local insert = {
    a = { fg = colors.fg, bg = colors.dark_green, gui = "bold" },
  }

  local inactive = {
    a = { fg = colors.nontext, bg = colors.gray, gui = 'bold' },
    b = { fg = colors.gray, bg = colors.statusline },
    c = { fg = colors.nontext, bg = colors.statusline },
  }

  return {
    normal = normal,
    command = command,
    visual = visual,
    inactive = inactive,
    replace = replace,
    insert = insert,
  }
end
