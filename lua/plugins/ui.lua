return {
  -- Colorscheme
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      transparent = true, -- Ghostty background-opacity
      theme = "wave",
      colors = {
        theme = { all = { ui = { bg_gutter = "none", float = { bg = "none" } } } },
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Floats transparent, aber Rand dezent sichtbar
          FloatBorder = { fg = theme.ui.nontext, bg = "none" },
          -- Pmenu (Completion) dunkel-transparent statt kräftigem Panel
          Pmenu = { bg = theme.ui.bg_p1, blend = 15 },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa")
    end,
  },

  -- Statusline (Bubble-Style)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      -- Mittlere Sektion (lualine_c) transparent, damit die Bubble-Optik
      -- nur an den Rändern sichtbar ist
      local theme = require("lualine.themes.kanagawa")
      for _, mode in pairs(theme) do
        if mode.c then
          mode.c.bg = "none"
        end
      end
      return {
        options = {
          theme = theme,
          globalstatus = true,
          component_separators = "",
          -- Powerline-Pfeile statt runder Kappen
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            { "mode", icon = "" },
          },
          lualine_b = {
            { "branch", icon = "" },
            { "diff", symbols = { added = " ", modified = " ", removed = " " } },
          },
          lualine_c = {
            { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
            { "filename", symbols = { modified = "●", readonly = "", unnamed = "" } },
          },
          lualine_x = {
            { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
          },
          lualine_y = { "lsp_status", "progress" },
          lualine_z = {
            { "location", icon = "" },
          },
        },
      }
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
        { "<leader>o", group = "obsidian" },
        { "<leader>g", group = "git" },
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
      presets = {
        command_palette = true,
        lsp_doc_border = true,
      },
      routes = {
        -- Nur Routine-Rauschen ausblenden ("3 Zeilen geschrieben", Suche umgebrochen);
        -- Fehler und alle anderen Meldungen bleiben sichtbar
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "written" },
            },
          },
          opts = { skip = true },
        },
      },
    },
  },
}
