return {
  {
    "lervag/vimtex",
    ft = "tex",
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_general_viewer =
        "/Applications/Skim.app/Contents/SharedSupport/displayline"
      vim.g.vimtex_view_general_options = "-r @line @pdf @tex"

      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_quickfix_open_on_warning = 0
    end,
  },
}
