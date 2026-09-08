return {
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

      -- Heading-Farben aus caelestias scheme.json (term1..6), bg bleibt none.
      -- Fallback: die alten Kanagawa-Werte, falls die Datei fehlt.
      local function caelestia_palette()
        local state = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")
        local f = io.open(state .. "/caelestia/scheme.json", "r")
        if not f then return {} end
        local raw = f:read("*a")
        f:close()
        local ok, data = pcall(vim.json.decode, raw)
        local cols = ok and type(data) == "table" and data.colours or {}
        local out = {}
        for k, v in pairs(cols) do
          if type(v) == "string" and v:match("^%x%x%x%x%x%x$") then out[k] = "#" .. v end
        end
        return out
      end

      -- caelestia sendet nach jedem Theme-Wechsel ein ColorScheme-Event und
      -- render-markdown re-linkt dabei seine Gruppen -- daher hier erneut setzen.
      local function apply_hl()
        for _, hl in ipairs({
          "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg", "RenderMarkdownH5Bg", "RenderMarkdownH6Bg",
          "RenderMarkdownCode", "RenderMarkdownCodeInline",
        }) do
          vim.api.nvim_set_hl(0, hl, { bg = "none" })
        end

        local p = caelestia_palette()
        local heading_fg = {
          RenderMarkdownH1 = p.term1 or "#ffa066",
          RenderMarkdownH2 = p.term2 or "#7e9cd8",
          RenderMarkdownH3 = p.term3 or "#98bb6c",
          RenderMarkdownH4 = p.term4 or "#e6c384",
          RenderMarkdownH5 = p.term5 or "#957fb8",
          RenderMarkdownH6 = p.term6 or "#7aa89f",
        }
        for hl, fg in pairs(heading_fg) do
          vim.api.nvim_set_hl(0, hl, { fg = fg, bg = "none" })
        end
      end

      apply_hl()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("markdown_heading_colors", { clear = true }),
        callback = vim.schedule_wrap(apply_hl),
      })
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