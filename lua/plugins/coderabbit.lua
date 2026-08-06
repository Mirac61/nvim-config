return {
  {
    "smnatale/coderabbit.nvim",
    cmd = {
      "CodeRabbitReview",
      "CodeRabbitStop",
      "CodeRabbitClear",
      "CodeRabbitShow",
      "CodeRabbitQuickfix",
      "CodeRabbitHistory",
    },
    keys = {
      { "<leader>crr", "<cmd>CodeRabbitReview uncommitted<cr>", desc = "Review: uncommitted" },
      { "<leader>cra", "<cmd>CodeRabbitReview all<cr>", desc = "Review: alles" },
      { "<leader>crs", "<cmd>CodeRabbitShow<cr>", desc = "Ergebnis anzeigen" },
      { "<leader>crq", "<cmd>CodeRabbitQuickfix<cr>", desc = "In Quickfix-Liste" },
      { "<leader>crh", "<cmd>CodeRabbitHistory<cr>", desc = "Frühere Reviews" },
      { "<leader>crx", "<cmd>CodeRabbitStop<cr>", desc = "Review abbrechen" },
      { "<leader>crc", "<cmd>CodeRabbitClear<cr>", desc = "Diagnostics leeren" },
    },
    opts = {
      review = { type = "uncommitted" },
      show = {
        layout = "float",
        float = { width = 0.6, height = 0.7, border = "rounded" },
      },
    },
  },
}
