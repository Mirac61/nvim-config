vim.keymap.set("n", "<leader>jr", "<cmd>split | term ./mvnw -q javafx:run<cr>",
  { buffer = true, desc = "JavaFX App starten" })
