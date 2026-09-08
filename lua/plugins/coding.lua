return {
	-- Treesitter (main-Branch, nvim 0.12)
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			local parsers = {
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"go",
				"gomod",
				"templ",
				"html",
				"javascript",
				"css",
				"comment",
				"java",
				"cpp",
				"c",
				"typst",
				"yaml",
				"toml",
				"json",
				"bash",
			}
			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
				callback = function(ev)
					-- vimtex macht bei tex sein eigenes Highlighting
					if ev.match == "tex" then
						return
					end
					local lang = vim.treesitter.language.get_lang(ev.match)
					if lang and vim.treesitter.language.add(lang) then
						vim.treesitter.start(ev.buf, lang)
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},

	-- Completion (ersetzt den ganzen nvim-cmp-Stack)
	{
		"saghen/blink.cmp",
		version = "1.*",
		event = "InsertEnter",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			keymap = {
				preset = "none",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-n>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
			},
			appearance = { nerd_font_variant = "normal" },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
				menu = { border = "rounded" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			signature = { enabled = true },
		},
	},

	-- Formatter
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofumpt" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				java = { "google-java-format" },
				typst = { "typstyle" },
				markdown = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
			},
			format_on_save = function(bufnr)
				-- Markdown im Vault nicht ungefragt umformatieren
				if vim.bo[bufnr].filetype == "markdown" then
					return nil
				end
				-- sqls formatiert schlecht, lieber manuell
				if vim.bo[bufnr].filetype == "sql" then
					return nil
				end
				return { timeout_ms = 1000, lsp_format = "fallback" }
			end,
		},
	},

	-- Autopairs (leichter als nvim-autopairs)
	{ "nvim-mini/mini.pairs", event = "InsertEnter", opts = {} },

	-- Git-Zeichen in der Statuscolumn
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},

	-- TODO/FIXME-Highlighting
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
}
