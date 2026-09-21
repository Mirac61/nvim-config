local aug = vim.api.nvim_create_augroup("user", { clear = true })

-- Auto-Save (ersetzt auto-save.nvim): beim Verlassen von Insert/Buffer/Fokus speichern
vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave", "FocusLost" }, {
  group = aug,
  callback = function(ev)
    local buf = ev.buf
    if vim.bo[buf].modified and vim.bo[buf].buftype == "" and vim.bo[buf].modifiable
        and vim.api.nvim_buf_get_name(buf) ~= "" then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("silent! noautocmd update")
      end)
    end
  end,
})

-- Kurz highlighten, was gerade gey ankt wurde
vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Cursor an letzter Position wiederherstellen
vim.api.nvim_create_autocmd("BufReadPost", {
  group = aug,
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Markdown: kein Umbruch (breite Tabellen bleiben Tabellen), Umbruch mit <leader>uw togglebar
vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = "markdown",
  callback = function(ev)
    vim.wo.wrap = false
    vim.wo.linebreak = true -- falls wrap an: nur an Wortgrenzen umbrechen
    vim.keymap.set("n", "<leader>uw", function()
      vim.wo.wrap = not vim.wo.wrap
    end, { buffer = ev.buf, desc = "Wrap togglen" })
  end,
})

-- q schließt Hilfs-Fenster
vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = { "help", "qf", "checkhealth", "man" },
  callback = function(ev)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})

-- :Issue <nr> öffnet ein GitHub-Ticket samt Kommentaren im vertikalen Split (nur lesen).
-- Bewusst über --json statt --comments: Letzteres liefert außerhalb eines TTY nichts.
vim.api.nvim_create_user_command("Issue", function(opts)
  local jq = '"# " + .title + "\\n\\n" + .body + "\\n\\n" + '
    .. '(if (.comments | length) > 0 then '
    .. '(.comments | map("---\\n\\n**@" + .author.login + "**\\n\\n" + .body) | join("\\n\\n")) '
    .. 'else "" end)'
  local out = vim.fn.systemlist({ "gh", "issue", "view", opts.args,
    "--json", "title,body,comments", "--jq", jq })
  if vim.v.shell_error ~= 0 then
    vim.notify(table.concat(out, "\n"), vim.log.levels.ERROR)
    return
  end
  vim.cmd("vsplit | enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.filetype = "markdown"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
  vim.cmd("normal! gg")
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true })
end, { nargs = 1, desc = "GitHub-Issue im Split anzeigen" })
