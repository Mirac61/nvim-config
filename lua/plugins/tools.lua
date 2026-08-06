return {
  {
    "mikavilpas/yazi.nvim",
    keys = {
      { "<leader>y", "<cmd>Yazi<cr>", desc = "Open Yazi" },
    },
    opts = {
      open_for_directories = true,
    },
  },
  {
    "pwntester/octo.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    cmd = "Octo",
    opts = {
      picker = "snacks",
      use_local_fs = true,
    },
    keys = {
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "GitHub Issues" },
      { "<leader>gI", "<cmd>Octo issue create<cr>", desc = "GitHub Issue erstellen" },
      { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "GitHub PRs" },
      { "<leader>gs", "<cmd>Octo search<cr>", desc = "GitHub Suche" },
    },
  },
}
