vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.lazy")
require("config.autocmds")

vim.schedule(function()
  require("config.keymaps")
end)
