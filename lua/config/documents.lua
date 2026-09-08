local M = {}

local function buf_path()
  return vim.api.nvim_buf_get_name(0)
end

local function ext(path)
  return path:match("%.([^.]+)$")
end

-- Öffnet eine PDF in Skim.
local function open_skim(pdf)
  vim.fn.system({ "open", "-a", "Skim", pdf })
  vim.notify("Geöffnet: " .. vim.fn.fnamemodify(pdf, ":t"), vim.log.levels.INFO)
end

-- Kompiliert das aktuelle LaTeX/Typst-Dokument und öffnet das PDF extern.
function M.open_pdf()
  local path = buf_path()
  if path == "" then
    vim.notify("Keine Datei offen", vim.log.levels.WARN)
    return
  end
  local ft = vim.bo.filetype
  local e = ext(path)

  if ft == "pdf" or e == "pdf" then
    open_skim(path)
  elseif ft == "tex" or e == "tex" then
    local pdf = path:sub(1, #path - 4) .. ".pdf"
    vim.fn.system({ "latexmk", "-pdf", "-interaction=nonstopmode", path })
    if vim.fn.filereadable(pdf) == 1 then
      open_skim(pdf)
    else
      vim.notify("LaTeX-Kompilierung fehlgeschlagen", vim.log.levels.ERROR)
    end
  elseif ft == "typst" or e == "typ" then
    local pdf = path:sub(1, #path - 4) .. ".pdf"
    vim.fn.system({ "typst", "compile", path })
    if vim.fn.filereadable(pdf) == 1 then
      open_skim(pdf)
    else
      vim.notify("Typst-Kompilierung fehlgeschlagen", vim.log.levels.ERROR)
    end
  else
    vim.notify("Kein unterstütztes Dokument (tex/typst/pdf)", vim.log.levels.WARN)
  end
end

-- Kompiliert nur, ohne zu öffnen.
function M.compile()
  local path = buf_path()
  local e = ext(path)
  if e == "tex" then
    vim.fn.system({ "latexmk", "-pdf", "-interaction=nonstopmode", path })
    vim.notify("LaTeX kompiliert", vim.log.levels.INFO)
  elseif e == "typ" then
    vim.fn.system({ "typst", "compile", path })
    vim.notify("Typst kompiliert", vim.log.levels.INFO)
  else
    vim.notify("Kein kompilierbares Dokument (tex/typst)", vim.log.levels.WARN)
  end
end

-- Palette: PDFs im aktuellen Verzeichnis wählen und öffnen.
function M.pick_pdf()
  local cwd = vim.fn.getcwd()
  local pdfs = vim.fn.glob(cwd .. "/**/*.pdf", false, true)
  if #pdfs == 0 then
    vim.notify("Keine PDFs gefunden in " .. cwd, vim.log.levels.WARN)
    return
  end
  local items = {}
  for _, p in ipairs(pdfs) do
    table.insert(items, { text = vim.fn.fnamemodify(p, ":."), file = p })
  end
  table.sort(items, function(a, b) return a.text < b.text end)
  require("snacks").picker.pick({
    items = items,
    format = "text",
    title = "PDFs öffnen",
    confirm = function(picker, item)
      picker:close()
      if item then
        open_skim(item.file)
      end
    end,
  })
end

return M
