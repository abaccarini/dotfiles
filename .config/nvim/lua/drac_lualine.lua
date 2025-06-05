local colors = require '../colors'

return {
  normal = {
    a = { bg = colors.menu, fg = colors.purple, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.fg },
    c = { bg = colors.menu, fg = colors.fg },
  },
  insert = {
    a = { bg = colors.menu, fg = colors.green, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.fg },
    c = { bg = colors.menu, fg = colors.fg },
  },
  visual = {
    a = { bg = colors.menu, fg = colors.cyan, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.fg },
    c = { bg = colors.menu, fg = colors.fg },
  },
  replace = {
    a = { bg = colors.menu, fg = colors.red, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.fg },
    c = { bg = colors.menu, fg = colors.fg },
  },
  terminal = {
    a = { bg = colors.menu, fg = colors.pink, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.fg },
    c = { bg = colors.menu, fg = colors.fg },
  },
  command = {
    a = { bg = colors.menu, fg = colors.orange, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.fg },
    c = { bg = colors.menu, fg = colors.fg },
  },
  inactive = {
    a = { bg = colors.menu, fg = colors.fg, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.fg },
    c = { bg = colors.menu, fg = colors.fg },
  },
}
