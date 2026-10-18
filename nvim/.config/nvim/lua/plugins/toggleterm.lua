return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		shell = vim.o.shell,
		-- In Neovim entspricht Control + Backslash auf Mac-DE der Kombination <C-\>
		open_mapping = [[<C-\>]],
		-- IDE-Style: Terminal UNTEN. toggleterm nennt das "horizontal" (botright split)
		direction = "horizontal",
		size = 15,
		-- Terminal wechselt beim Öffnen in das Verzeichnis der aktuellen Datei
		autochdir = true,
		-- Geöffnete Terminals leicht absetzen (visuell unterscheidbar)
		shade_terminals = true,
		float_opts = {
			border = "curved",
		},
		insert_mappings = true,
		terminal_mappings = true,
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)
		local Terminal = require("toggleterm.terminal").Terminal

		-- <leader>t: Terminal als Split UNTEN (IDE-Style)
		vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Terminal (unten)" })

		-- <leader>tc: Terminal als Split RECHTS (hochkant; toggleterm nennt das "vertical" = vsplit)
		vim.keymap.set("n", "<leader>tc", "<cmd>ToggleTerm direction=vertical size=80<cr>", { desc = "Terminal (rechts)" })

		-- <leader>tf: Terminal als Floating-Fenster (über allem)
		vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal (float)" })

		-- <leader>tt: Terminal als Tab (voller Bildschirm)
		vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=tab<cr>", { desc = "Terminal (Tab)" })

		-- Nummerierte Terminals: <A-1> .. <A-4> zum Wechseln zwischen mehreren Shells
		for i = 1, 4 do
			vim.keymap.set("n", "<A-" .. i .. ">", i .. "<cmd>ToggleTerm<cr>", { desc = "Terminal " .. i })
		end

		-- Git-Status als interaktives Terminal (lazygit)
		local lazygit = Terminal:new({
			cmd = "lazygit",
			dir = "git_dir",
			direction = "float",
			hidden = true,
			on_open = function(term)
				-- Im lazygit-Terminal mit Esc zurück in den Normal-Mode
				vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true, buffer = term.bufnr })
			end,
		})
		vim.keymap.set("n", "<leader>tg", function()
			lazygit:toggle()
		end, { desc = "lazygit" })
	end,
}
