local cmd = vim.cmd

-- Highlight on yank
cmd [[
  augroup GoWriteFile
    autocmd!
    autocmd BufWritePost *.go silent !gofmt -w %
  augroup end
]]
