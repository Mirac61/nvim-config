-- Themes zum Durchschalten. Sie laden nur ihre colors/-Datei in den Runtimepath,
-- setup() laeuft erst, wenn eines wirklich aktiv wird.
local themes = {
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "EdenEast/nightfox.nvim" },
  { "sainnhe/everforest" },
  { "tiesen243/vercel.nvim", opts = { theme = "dark" } },
}

local variants = { "wave", "dragon", "lotus" }

-- caelestia baut seine Palette aus ~/.local/state/caelestia/scheme.json und folgt
-- damit dem Desktop-Theme. Ohne die Datei -- also ueberall ausser auf dem Arch-
-- Laptop -- bliebe nvim ungestylt, deshalb dort kanagawa als Start-Theme.
local function caelestia_bereit()
  local state = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")
  return vim.fn.filereadable(state .. "/caelestia/scheme.json") == 1
end

local default = caelestia_bereit() and "caelestia" or "kanagawa-dragon"

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

-- kanagawa meldet alle drei Varianten als "kanagawa", die echte steht nur intern.
local function active()
  if vim.g.colors_name == "kanagawa" then
    local ok, kanagawa = pcall(require, "kanagawa")
    return "kanagawa-" .. ((ok and kanagawa._CURRENT_THEME) or "wave")
  end
  return vim.g.colors_name
end

local function apply(name)
  if name:find("^kanagawa") then
    vim.o.background = name == "kanagawa-lotus" and "light" or "dark"
  end
  if pcall(vim.cmd.colorscheme, name) then
    remember(name)
  end
end

-- Namen aus `ghostty +list-themes`. Ohne Eintrag bleibt das Terminal, wie es ist.
local ghostty_themes = {
  ["kanagawa-wave"] = "Kanagawa Wave",
  ["kanagawa-dragon"] = "Kanagawa Dragon",
  ["kanagawa-lotus"] = "Kanagawa Lotus",
  tokyonight = "TokyoNight",
  catppuccin = "Catppuccin Mocha",
  ["rose-pine"] = "Rose Pine",
  nightfox = "Nightfox",
  everforest = "Everforest Dark Hard",
  vercel = "Vercel",
}

local function sync_ghostty()
  local name = active()
  if not name then
    return
  end

  -- Varianten wie "tokyonight-storm" fallen auf den Grundnamen zurueck.
  local theme = ghostty_themes[name] or ghostty_themes[name:match("^[^-]+")]
  if not theme then
    return
  end

  local f = io.open(vim.fn.expand("~/.config/ghostty/theme.conf"), "w")
  if not f then
    return
  end
  f:write("theme = " .. theme .. "\n")
  f:close()
  vim.system({ "pkill", "-USR2", "-x", "ghostty" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    sync_ghostty()
  end,
})

local spec = vim.deepcopy(themes)

table.insert(spec, {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    background = { dark = "dragon", light = "lotus" },
    colors = {
      palette = {
        -- dragon-Hintergrund Richtung Vercel: kuehles, tiefes Schwarz
        -- statt der warmen dragonBlack-Toene (Zinc-Skala wie bei Vercel).
        dragonBlack0 = "#050506",
        dragonBlack1 = "#060608",
        dragonBlack2 = "#0f0f12",
        dragonBlack3 = "#09090b",
        dragonBlack4 = "#18181b",
        dragonBlack5 = "#27272a",
        dragonBlack6 = "#52525b",
      },
      theme = {
        dragon = {
          syn = {
            -- edleres Jade-Gruen fuer Strings statt dragonGreen2
            string = "#87b89e",
          },
        },
      },
    },
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    apply(remembered() or default)
  end,
})

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
                apply(item.text)
              end)
            end
          end,
        })
      end,
      desc = "Theme wechseln",
    },
    {
      "<leader>uk",
      function()
        local current = (active() or ""):match("^kanagawa%-(.+)$")
        local index = 0
        for i, variant in ipairs(variants) do
          if variant == current then
            index = i
          end
        end
        apply("kanagawa-" .. variants[index % #variants + 1])
      end,
      desc = "Kanagawa: wave/dragon/lotus",
    },
  },
})

return spec
