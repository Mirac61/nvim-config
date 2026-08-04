return {
	"Mirac61/code-stats.nvim",
	cmd = "Stats",
	keys = {
		{
			"<leader>cs",
			function()
				require("code-stats").show()
			end,
			desc = "Code stats",
		},
	},
	opts = {
		exclude = { "node_modules", "vendor", "dist", "build", "shared/fonts" },
	},
}
