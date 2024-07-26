vim.keymap.set("n", "<F1>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F2>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F3>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<F4>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F5>", ":lua require'dap'.run_to_cursor()<CR>")
vim.keymap.set("n", "<F12>", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>dt", ":lua require('dap-go').debug_test()<CR>")
vim.keymap.set("n", "<leader>dl", ":lua require('dap-go').debug_last_test()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log pointer...: '))<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>r", ":lua require'dap'.restart()<CR>")

vim.keymap.set("n", "<leader>ds", function()
    vim.cmd(":lua require'dap'.close()")
    vim.cmd(":lua require'dapui'.close()")
end)

--- show the dap.log file
-- vim.keymap.set("n", "<leader>dl", function() 
--         local d = vim.fn.stdpath('cache') .. "/dap.log"
--         vim.cmd(":!cat " .. d)
-- end)

require('dapui').setup()
require('nvim-dap-virtual-text').setup()
require('dap-go').setup({
    on_attach = function() 
    end
})


require('dap').set_log_level('DEBUG')

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
