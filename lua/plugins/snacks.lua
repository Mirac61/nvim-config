return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			notifier = { enabled = true, timeout = 3000 },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			-- Smooth scrolling
			scroll = { enabled = true },
			indent = {
				enabled = true,
				char = "▏",
				-- Aktueller Scope dezent hervorgehoben
				scope = { enabled = true, char = "▏", hl = "Comment" },
				animate = { enabled = true },
			},
			input = { enabled = true },
			picker = {
				enabled = true,
				ui_select = true,
				sources = {
					files = { hidden = true },
					explorer = {
						hidden = true,
						ignored = true,
					},
				},
			},
			explorer = {
				replace_netrw = true,
			},
			dashboard = {
				preset = {
					header = [[
███╗   ██╗██╗   ██╗██╗███╗   ███╗
████╗  ██║██║   ██║██║████╗ ████║
██╔██╗ ██║██║   ██║██║██╔████╔██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],
				},
				sections = {
					-- Bild oben (chafa rendert es als Unicode-Halbblöcke).
					-- Anderes Bild? Einfach ~/.config/nvim/assets/dashboard.png ersetzen.
					{
						section = "terminal",
						cmd = "chafa "
							.. vim.fn.stdpath("config")
							.. "/assets/dashboard.png --format symbols --symbols vhalf --size 60x40; sleep .1",
						height = 20,
						padding = 1,
					},
					{
						text = {
							{ "  " .. os.date("%H:%M"), hl = "special" },
							{ "    " .. os.date("%a, %d. %b %Y"), hl = "footer" },
						},
						align = "center",
						padding = 1,
					},
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "recent_files", title = "Recent", padding = 1 },
					{ section = "startup" },
				},
			},
		},
	},
}
