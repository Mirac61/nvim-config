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
				width = 110,
				preset = {
					header = [[
 ▄████████    ▄████████    ▄████████  ▄█          ▄████████    ▄████████     ███      ▄█     ▄████████
███    ███   ███    ███   ███    ███ ███         ███    ███   ███    ███ ▀█████████▄ ███    ███    ███
███    █▀    ███    ███   ███    █▀  ███         ███    █▀    ███    █▀     ▀███▀▀██ ███▌   ███    ███
███          ███    ███  ▄███▄▄▄     ███        ▄███▄▄▄       ███            ███   ▀ ███▌   ███    ███
███        ▀███████████ ▀▀███▀▀▀     ███       ▀▀███▀▀▀     ▀███████████     ███     ███▌ ▀███████████
███    █▄    ███    ███   ███    █▄  ███         ███    █▄           ███     ███     ███    ███    ███
███    ███   ███    ███   ███    ███ ███▌    ▄   ███    ███    ▄█    ███     ███     ███    ███    ███
████████▀    ███    █▀    ██████████ █████▄▄██   ██████████  ▄████████▀     ▄████▀   █▀     ███    █▀]],
				},
			},
		},
	},
}