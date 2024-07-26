local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>r', builtin.resume, {})

require('telescope').setup{
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
            horizontal = {
                prompt_position = "top",
            }
        },
        find_command = "rg",
        sorting_strategy = "ascending",
        -- path_display = {"truncate"},
        file_ignore_patterns = { 
            "vendor",
            "node_modules",
            "hq/images",
            "dbdata",
            "composer.phar",
            "composer.lock",
        },
    },
}
