vim.g.mapleader = ","
vim.keymap.set("n", "-", vim.cmd.Ex)
vim.keymap.set("n", "<leader><leader>", "<C-^>")
vim.keymap.set("n", "<C-", "<C-^>")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("n", "<Space><Space>", ":ccl<cr>")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
