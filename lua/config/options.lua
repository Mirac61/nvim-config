local o = vim.opt

-- UI
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.termguicolors = true
o.laststatus = 3
o.showmode = false
o.splitbelow = true
o.splitright = true
o.scrolloff = 8
o.pumheight = 12
o.winborder = "rounded"
o.fillchars = { eob = " ", vert = "│", fold = " " }
o.cursorlineopt = "number"

-- Editing
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true
o.undofile = true
o.confirm = true
o.updatetime = 250
o.timeoutlen = 400

-- Suche
o.ignorecase = true
o.smartcase = true

-- Clipboard (System)
o.clipboard = "unnamedplus"

require("config.remote_clipboard").setup()

-- Obsidian/Markdown: Links etc. concealen
o.conceallevel = 2

-- Vermeide "hit-enter"-Prompts
o.shortmess:append("cIW")
