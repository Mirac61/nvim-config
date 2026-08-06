-- Themes zum Durchschalten. Sie laden nur ihre colors/-Datei in den Runtimepath,
-- setup() laeuft erst, wenn eines wirklich aktiv wird.
local themes = {
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "EdenEast/nightfox.nvim" },
  { "sainnhe/everforest" },
}

local statefile = vim.fn.stdpath("state") .. "/colorscheme"

local function remember(name)
  local f = io.open(statefile, "w")
  if f then
    f:write(name)
    f:close()
  end
end

local function remembered()
  local f = io.open(statefile, "r")
  if not f then
    return nil
  end
  local name = vim.trim(f:read("*a") or "")
  f:close()
  return name ~= "" and name or nil
end

local spec = vim.deepcopy(themes)

table.insert(spec, {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>ut",
      function()
        Snacks.picker.colorschemes({
          confirm = function(picker, item)
            picker.preview.state.colorscheme = nil
            picker:close()
            if item then
              vim.schedule(function()
                vim.cmd.colorscheme(item.text)
                remember(item.text)
              end)
            end
          end,
        })
      end,
      desc = "Theme wechseln",
    },
  },
  init = function()
    -- Die Auswahl der letzten Sitzung gewinnt gegen das Default aus ui.lua.
    local saved = remembered()
    if saved then
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          if vim.g.colors_name ~= saved then
            pcall(vim.cmd.colorscheme, saved)
          end
        end,
      })
    end
  end,
})

return spec
