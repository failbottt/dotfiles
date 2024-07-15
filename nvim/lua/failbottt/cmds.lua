local cmd = vim.cmd

-- go fmt on write
cmd [[
  augroup GoWriteFile
    autocmd!
    autocmd BufWritePost *.go silent !gofmt -w %
  augroup end
]]
