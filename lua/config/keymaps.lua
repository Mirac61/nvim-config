local map = vim.keymap.set

-- Standard
map("n", ";", ":", { desc = "Command mode" })
map("i", "jk", "<ESC>")
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Suche-Highlight aus" })

-- Fenster-Navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Explorer (Snacks, ersetzt NvimTree)
map("n", "<leader>e", function()
	Snacks.explorer()
end, { desc = "Explorer" })

-- Picker (Snacks, ersetzt Telescope)
map("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find Files" })
map("n", "<leader>fw", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fo", function()
	Snacks.picker.recent()
end, { desc = "Recent Files" })
map("n", "<leader>fh", function()
	Snacks.picker.help()
end, { desc = "Help" })
map("n", "<leader>fk", function()
	Snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>fc", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Nvim-Config" })

-- Terminal (Snacks, ersetzt nvchad.term)
-- fish statt $SHELL (bash), damit der Prompt wie in foot aussieht (starship,
-- Farben). vim.o.shell bleibt bash, damit :! / system() POSIX-kompatibel sind.
local termshell = vim.fn.executable("fish") == 1 and "fish" or nil
map({ "n", "t" }, "<leader>h", function()
	Snacks.terminal(termshell, { win = { position = "bottom", height = 0.3 } })
end, { desc = "Terminal Horizontal" })
map({ "n", "t" }, "<leader>v", function()
	Snacks.terminal(termshell, { win = { position = "right", width = 0.4 } })
end, { desc = "Terminal Vertikal" })
map({ "n", "t" }, "<leader>pt", function()
	Snacks.terminal(termshell, { win = { position = "float" } })
end, { desc = "Terminal Floating" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal-Modus verlassen" })

-- Git
map("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })
map("n", "<leader>gm", function()
	print(vim.fn.system("git checkout main && git fetch && git pull"))
end, { desc = "Git: main + fetch + pull" })

-- Java / JavaFX
map("n", "<leader>jr", "<cmd>split | term ./mvnw -q javafx:run<cr>", { desc = "JavaFX App starten" })

-- LaTeX
map(
	"n",
	"<leader>lb",
	"<cmd>split | term cd %:p:h && pdflatex %:t<cr>",
	{ desc = "LaTeX Build" }
)

-- Second Brain (Obsidian)
map("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New Note" })
map("n", "<leader>od", "<cmd>Obsidian today<cr>", { desc = "Daily Note" })
map("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Search Notes" })
map("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Backlinks" })
map("n", "<leader>ol", "<cmd>Obsidian links<cr>", { desc = "Links" })
map("n", "<leader>ot", "<cmd>Obsidian template<cr>", { desc = "Insert Template" })
map("n", "<leader>op", "<cmd>Obsidian quick_switch<cr>", { desc = "Quick Switch" })
map("n", "<leader>oo", "<cmd>Obsidian open<cr>", { desc = "Open in Obsidian App" })
map("n", "<leader>ox", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "Toggle Checkbox" })
map("n", "<leader>of", "<cmd>Obsidian follow_link<cr>", { desc = "Follow Link" })

-- Buffer manuell formatieren (z.B. Markdown-Tabellen via prettier ausrichten)
map({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format Buffer" })

-- LSP
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "gd", function()
	Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })
map("n", "gr", function()
	Snacks.picker.lsp_references()
end, { desc = "References" })
map("n", "<leader>ds", function()
	Snacks.picker.lsp_symbols()
end, { desc = "Document Symbols" })
map("n", "<leader>ws", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "Workspace Symbols" })
map("n", "<leader>fd", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
