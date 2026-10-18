return {
  -- Schnelle Sprünge/Motion (Clean + Motion Pass)
  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
  -- <C-h/j/k/l> wechselt nahtlos zwischen nvim-Fenstern und tmux-Panes
  {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Fenster links" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Fenster unten" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Fenster oben" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Fenster rechts" },
    },
  },
}
