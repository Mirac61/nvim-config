local M = {}

local function buf_path()
	return vim.api.nvim_buf_get_name(0)
end

local function ext(path)
	return path:match("%.([^.]+)$")
end

-- Öffnet eine PDF in Skim.
local function open_skim(pdf)
	local res = vim.system({ "open", "-a", "Skim", pdf }, { text = true }):wait()
	if res.code ~= 0 then
		vim.notify("Skim konnte nicht geöffnet werden:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
		return
	end
	vim.notify("Geöffnet: " .. vim.fn.fnamemodify(pdf, ":t"), vim.log.levels.INFO)
end

-- Kompiliert tex/typ und gibt den PDF-Pfad zurück (nil bei Fehler).
local function compile(path)
	local e = ext(path)
	local cmd
	if e == "tex" then
		-- -cd: latexmk wechselt ins Verzeichnis der .tex, PDF landet daneben
		cmd = { "latexmk", "-pdf", "-cd", "-interaction=nonstopmode", path }
	elseif e == "typ" then
		cmd = { "typst", "compile", path }
	else
		return nil
	end

	if vim.fn.executable(cmd[1]) == 0 then
		vim.notify(cmd[1] .. " nicht im PATH von Neovim", vim.log.levels.ERROR)
		return nil
	end

	-- Ungespeicherte Änderungen zuerst schreiben, sonst wird der alte Stand kompiliert
	vim.cmd("silent! update")

	local dir = vim.fn.fnamemodify(path, ":h")
	local res = vim.system(cmd, { cwd = dir, text = true }):wait()
	if res.code ~= 0 then
		local out = (res.stderr ~= "" and res.stderr) or res.stdout or ""
		vim.notify(cmd[1] .. " fehlgeschlagen:\n" .. out, vim.log.levels.ERROR)
		return nil
	end

	return vim.fn.fnamemodify(path, ":r") .. ".pdf"
end

-- Kompiliert das aktuelle LaTeX/Typst-Dokument und öffnet das PDF extern.
function M.open_pdf()
	local path = buf_path()
	if path == "" then
		vim.notify("Keine Datei offen", vim.log.levels.WARN)
		return
	end

	local e = ext(path)
	if e == "pdf" then
		open_skim(path)
		return
	end
	if e ~= "tex" and e ~= "typ" then
		vim.notify("Kein unterstütztes Dokument (tex/typst/pdf)", vim.log.levels.WARN)
		return
	end

	local pdf = compile(path)
	if pdf and vim.fn.filereadable(pdf) == 1 then
		open_skim(pdf)
	end
end

-- Kompiliert nur, ohne zu öffnen.
function M.compile()
	local path = buf_path()
	if compile(path) then
		vim.notify("Kompiliert: " .. vim.fn.fnamemodify(path, ":t"), vim.log.levels.INFO)
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
	table.sort(items, function(a, b)
		return a.text < b.text
	end)
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
