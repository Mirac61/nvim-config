-- Themes zum Durchschalten. Sie laden nur ihre colors/-Datei in den Runtimepath,
-- setup() laeuft erst, wenn eines wirklich aktiv wird.
local themes = {
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "EdenEast/nightfox.nvim" },
  { "sainnhe/everforest" },
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

-- tmux bekommt die Farben des aktiven Themes, das Layout bleibt in ~/.tmux.conf.
local function hex(group, attr)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  return hl[attr] and ("#%06x"):format(hl[attr]) or nil
end

local function sync_tmux()
  if not vim.env.TMUX or vim.fn.executable("tmux") == 0 then
    return
  end

  local fg = hex("Normal", "fg") or "#C5C9C5"
  local ink = hex("Normal", "bg") or "#181616"
  local bar = hex("StatusLine", "bg") or "#0D0C0C"
  local dim = hex("Comment", "fg") or "#737C73"
  local gray = hex("Visual", "bg") or "#223249"
  local blue = hex("Function", "fg") or "#8BA4B0"
  local red = hex("DiagnosticError", "fg") or "#FF5D62"

  local options = {
    ["@bar"] = bar,
    ["@fg"] = fg,
    ["@dim"] = dim,
    ["@ink"] = ink,
    ["@gray"] = gray,
    ["@blue"] = blue,
    ["status-style"] = ("bg=%s,fg=%s"):format(bar, dim),
    ["message-style"] = ("bg=%s,fg=%s"):format(gray, fg),
    ["mode-style"] = ("bg=%s,fg=%s"):format(gray, fg),
    ["pane-border-style"] = "fg=" .. gray,
    ["pane-active-border-style"] = "fg=" .. blue,
    ["window-status-bell-style"] = "fg=" .. red .. ",bold",
  }

  local cmd = { "tmux" }
  for name, value in pairs(options) do
    if #cmd > 1 then
      table.insert(cmd, ";")
    end
    vim.list_extend(cmd, { "set", "-g", name, value })
  end
  vim.list_extend(cmd, { ";", "refresh-client", "-S" })
  vim.system(cmd)
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
    sync_tmux()
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
