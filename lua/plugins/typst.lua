return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {
      -- tinymist kommt über mason, nicht selbst herunterladen
      dependencies_bin = {
        tinymist = vim.fn.stdpath("data") .. "/mason/bin/tinymist",
      },
    },
    keys = {
      { "<leader>tp", "<cmd>TypstPreviewToggle<cr>", desc = "Typst Preview Toggle", ft = "typst" },
    },
  },
}
