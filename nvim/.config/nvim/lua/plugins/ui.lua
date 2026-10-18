-- Die Farben kommen aus dem aktiven Colorscheme, damit der Theme-Switcher die
-- Statusline mitnimmt.
local function bubbles_theme()
  package.loaded["lualine.themes.auto"] = nil
  return vim.deepcopy(require("lualine.themes.auto"))
end

return {
  -- Colorscheme wird von plugins/caelestia.lua gesetzt (folgt dem Desktop-Theme).

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return {
        options = {
          theme = bubbles_theme(),
          globalstatus = true,
          -- The same powerline segment shape as tmux-ukiyo.
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            { "mode", icon = "", right_padding = 2 },
          },
          lualine_b = {
            { "branch", icon = "" },
            { "diff", symbols = { added = " ", modified = " ", removed = " " } },
          },
          lualine_c = {
            { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
            { "filename", symbols = { modified = "[+]", readonly = " ", unnamed = "[kein Name]" } },
          },
          lualine_x = {
            { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
            "encoding",
          },
          lualine_y = { "lsp_status", "progress" },
          lualine_z = {
            { "location", left_padding = 2 },
          },
        },
      }
    end,
    config = function(_, opts)
      local lualine = require("lualine")
      lualine.setup(opts)
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          lualine.setup({ options = { theme = bubbles_theme() } })
        end,
      })
    end,
  },

  -- Keymap-Hilfe
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>d", group = "Dokumente" },
        { "<leader>g", group = "git" },
        { "<leader>cr", group = "coderabbit" },
        { "<leader>u", group = "ui" },
      },
    },
  },

  -- Nachrichten/Cmdline-UI (vim.notify läuft über snacks.notifier)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = {
        progress = { enabled = true },
      },
      cmdline = { enabled = false },
      messages = { enabled = false },
      presets = {
        lsp_doc_border = true,
      },
    },
  },
}
