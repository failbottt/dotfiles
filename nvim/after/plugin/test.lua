require('nvim-test').setup {
    args = { "run", "-v" },
    run = true,                 -- run tests (using for debug)
    commands_create = true,     -- create commands (TestFile, TestLast, ...)
    filename_modifier = ":.",   -- modify filenames before tests run(:h filename-modifiers)
    silent = false,             -- less notifications
    term = "terminal",          -- a terminal to run ("terminal"|"toggleterm")
    termOpts = {
        direction = "horizontal",   -- terminal's direction ("horizontal"|"vertical"|"float")
        width = 96,               -- terminal's width (for vertical|float)
        height = 24,              -- terminal's height (for horizontal|float)
        go_back = false,          -- return focus to original window after executing
        stopinsert = "auto",      -- exit from insert mode (true|false|"auto")
        keep_one = true,          -- keep only one terminal for testing
    },
    runners = {                   -- setup tests runners
        go = "nvim-test.runners.go-test",
    }
}

vim.keymap.set("n", "<leader>T", ":TestFile<cr>")
vim.keymap.set("n", "<leader>t", ":TestNearest<cr>")
vim.keymap.set("n", "<leader>l", ":TestLast<cr>")
vim.keymap.set("n", "<leader>v", ":TestVisit<cr>")
vim.keymap.set("n", "<leader>e", ":TestEdit<cr>")
