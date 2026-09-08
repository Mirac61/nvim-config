-- Caelestia-managed colorscheme.
-- colors/caelestia.lua builds the palette from ~/.local/state/caelestia/scheme.json
-- and watches that file, so nvim follows the desktop / wallpaper theme live --
-- the same role omarchy-theme-hotreload.lua used to fill.
--
-- vim.g.caelestia_transparent = false  -- opaque background, default true
return {
  {
    name = "caelestia-theme",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      -- Apply now for a themed first frame ...
      pcall(vim.cmd.colorscheme, "caelestia")
      -- ... and again once plugins shipping highlight groups have loaded.
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        group = vim.api.nvim_create_augroup("caelestia_colorscheme", { clear = true }),
        callback = function()
          if vim.g.colors_name == "caelestia" then
            pcall(vim.cmd.colorscheme, "caelestia")
          end
        end,
      })
    end,
  },
}
