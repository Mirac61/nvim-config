return {
  -- Obsidian (Community-Fork, epwalsh ist unmaintained)
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "noteking",
          path = "/Users/mirac/Library/Mobile Documents/iCloud~md~obsidian/Documents/NoteKingVault",
          overrides = {
            templates = { folder = "Templates" },
            daily_notes = { folder = "daily", date_format = "%Y-%m-%d", template = nil },
          },
        },
        {
          name = "brain",
          path = "/Users/mirac/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes",
          overrides = {
            templates = { folder = "templates" },
            daily_notes = { folder = "daily", date_format = "%Y-%m-%d", template = "daily-template.md" },
          },
        },
      },
      templates = {
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      ui = { enable = false }, -- render-markdown übernimmt das Rendering
    },
  },

  -- Markdown-Rendering im Buffer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      anti_conceal = { enabled = true },
      heading = {
        enabled = true,
        position = "inline",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "block",
        border = true,
      },
      code = {
        style = "full",
        position = "right",
        width = "block",
        border = "thin",
        left_pad = 1,
        right_pad = 1,
      },
      bullet = { icons = { "● ", "○ ", "◆ ", "◇ " } },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
      },
      quote = { icon = "▎" },
      dash = { icon = "─", width = "full" },
      pipe_table = { preset = "round" },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      -- Transparente Hintergründe (Ghostty background-opacity)
      local highlights = {
        "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg", "RenderMarkdownH5Bg", "RenderMarkdownH6Bg",
        "RenderMarkdownCode", "RenderMarkdownCodeInline",
      }
      for _, hl in ipairs(highlights) do
        vim.api.nvim_set_hl(0, hl, { bg = "none" })
      end

      -- Heading-Farben (Kanagawa-Palette), bg bleibt none
      local ok, kanagawa_colors = pcall(function()
        return require("kanagawa.colors").setup().palette
      end)
      local palette = ok and kanagawa_colors or {}
      local heading_fg = {
        RenderMarkdownH1 = palette.surimiOrange or "#ffa066",
        RenderMarkdownH2 = palette.crystalBlue or "#7e9cd8",
        RenderMarkdownH3 = palette.springGreen or "#98bb6c",
        RenderMarkdownH4 = palette.carpYellow or "#e6c384",
        RenderMarkdownH5 = palette.oniViolet or "#957fb8",
        RenderMarkdownH6 = palette.waveAqua2 or "#7aa89f",
      }
      for hl, fg in pairs(heading_fg) do
        vim.api.nvim_set_hl(0, hl, { fg = fg, bg = "none" })
      end
    end,
  },

  -- Tabellen beim Tippen automatisch ausrichten
  {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    init = function()
      vim.g.table_mode_corner = "|" -- GitHub-flavored Markdown
      vim.g.table_mode_map_prefix = "<leader>T" -- nicht mit <leader>t (Typst) kollidieren
    end,
    keys = {
      { "<leader>tt", "<cmd>TableModeToggle<cr>", desc = "Table Mode Toggle", ft = "markdown" },
    },
  },

  -- Browser-Vorschau
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "dark"
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview Toggle", ft = "markdown" },
    },
  },
}
