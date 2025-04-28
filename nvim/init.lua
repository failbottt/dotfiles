-- COLOR
vim.opt.background = "dark"
vim.cmd.colorscheme("black")

-- OPTIONS
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.nu = true
vim.opt.updatetime = 50
vim.opt.cursorline = true
vim.opt.syntax = "off"
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.shell = "/bin/bash"

-- KEY MAPS
vim.g.mapleader = ","
vim.keymap.set('n', '-', ":Ex<cr>", {})
vim.keymap.set("n", "<leader><leader>", "<C-^>")
vim.keymap.set("n", "<C-", "<C-^>")
vim.keymap.set("n", "<Space><Space>", ":ccl<cr>")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Helper to send <C-\><C-n> to leave terminal Insert mode
local function smart_split_move(cmd)
  -- If we're in terminal mode, leave insert mode first
  if vim.fn.mode() == 't' then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true), 'n', true)
  end
  vim.cmd('wincmd ' .. cmd)
end

-- Map movement keys in Normal and Terminal modes
vim.keymap.set({ 'n' }, '<C-h>', function() smart_split_move('h') end)
vim.keymap.set({ 'n' }, '<C-j>', function() smart_split_move('j') end)
vim.keymap.set({ 'n' }, '<C-k>', function() smart_split_move('k') end)
vim.keymap.set({ 'n' }, '<C-l>', function() smart_split_move('l') end)

if vim.loader then
  vim.loader.enable()
end

-- DISABLE UNUSED PLUGINS
local disabled_built_ins = {
  "gzip",
  "tar",
  "tarPlugin",
  "zip",
  "zipPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Telescope (fuzzy finder)
  {
     "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      event = "VeryLazy",
  },

  -- LSP Support
  "neovim/nvim-lspconfig",

  {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
          require("toggleterm").setup({
              start_in_insert = true,
              open_mapping = [[<leader>t]],
              direction = "float",
              float_opts = {
                border = "curved",
                width = math.floor(vim.o.columns * 0.8),
                height = math.floor(vim.o.lines * 0.8),
                winblend = 0,
              },
              hidden = true,
          })
      end,
  },

  {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      config = function()
          require('telescope').load_extension('fzf')
      end
  },
})

-- TELESCOPE KEYMAPS
require('telescope').setup{
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
            horizontal = {
                prompt_position = "top",
            }
        },
        find_command = {'rg', '--files', '--hidden', '-g', '!.git' },
        sorting_strategy = "ascending",
        file_ignore_patterns = {
            "%.lock",
            ".git/",
            "vendor",
            "node_modules",
            "hq/images",
            "dbdata",
            "composer.phar",
            "composer.lock",
        },
        -- Smart case matching
        file_sorter = require('telescope.sorters').get_fuzzy_file,
        generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
        path_display = { "smart" }, -- Clean up file paths
    },
    pickers = {
        find_files = {
            hidden = true  -- Allow finding dotfiles
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,                     -- True: fuzzy match
            override_generic_sorter = true,   -- Faster sorting
            override_file_sorter = true,      -- Faster file sorting
            case_mode = "smart_case",         -- Smart case (lowercase = insensitive, caps = sensitive)
        }
    }
}
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', function()
  builtin.find_files({ cwd = vim.fn.getcwd() })
end, { desc = 'Find files (cwd)' })
vim.keymap.set('n', '\\', function()
  builtin.live_grep({ cwd = vim.fn.getcwd() })
end, { desc = 'Grep (cwd)' })
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>r', builtin.resume, {})
vim.keymap.set("n", "S", function()
    local w = vim.fn.expand("<cword>")
    vim.cmd(":Telescope grep_string default_text=" .. w)
end)

-- LSP BASIC SETUP
local lspconfig = require('lspconfig')

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
  nmap('gi', builtin.lsp_implementations, '[G]oto [I]mplementation')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>n', vim.lsp.buf.rename, '[R]e[n]ame Symbol')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
  nmap(']d', vim.diagnostic.goto_next, 'Next Diagnostic')
  nmap('<leader>e', vim.diagnostic.open_float, 'Open Diagnostic Float')
end

-- add the on_attach to each language server you want
-- to use the keymaps above
lspconfig.pylsp.setup{
    on_attach = on_attach,
}
lspconfig.gopls.setup{
    on_attach = on_attach,
}
lspconfig.intelephense.setup({
  on_attach = on_attach,
  settings = {
    intelephense = {
      environment = {
        includePaths = {}, -- if you want to manually add folders
      },
      files = {
        maxSize = 5000000, -- (optional) raise max file size if needed
        exclude = {
          "**/vendor/**",
          "**/node_modules/**",
          "**/.git/**",
        },
      },
    },
  },
})
-- FILES
vim.api.nvim_create_augroup("FormatFilesOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = "FormatFilesOnSave",
  pattern = "*",
  callback = function()
    -- 1. Trim trailing whitespace in all files
    vim.cmd([[%s/\s\+$//e]])

    -- 2. If it's a Go file, run gofmt
    if vim.bo.filetype == "go" then
      vim.cmd("silent! !gofmt -w %")
      vim.cmd("edit!")  -- reload buffer after external format
    end
  end,
})

-- large files
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function(args)
    local file = args.file
    local stats = vim.loop.fs_stat(file)
    if stats and stats.size > 1024 * 1024 * 2 then
      vim.b.large_file = true
      vim.cmd("syntax off")
      vim.cmd("filetype off")
      vim.opt_local.undofile = false
      vim.opt_local.swapfile = false
      vim.opt_local.wrap = false
      vim.opt_local.lazyredraw = true
    end
  end,
})

-- FILES

-- DIAGNOSTICS

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = " ",
      scope = "cursor",
    })
  end
})

-- Copy the diagnostic under cursor to system clipboard
vim.keymap.set('n', '<leader>c', function()
  local diagnostic = vim.diagnostic.get_next()
  if diagnostic then
    vim.fn.setreg('+', diagnostic.message)
    vim.notify("Diagnostic copied to clipboard", vim.log.levels.INFO)
  else
    vim.notify("No diagnostic under cursor", vim.log.levels.WARN)
  end
end, { desc = "Copy Diagnostic Message" })
-- DIAGNOSTICS END


-- FLOATING WINDOW
--
-- Set FloatBorder highlight
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff", bg = "#000000" })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#000000", bg = "#000000" })

-- Override open_floating_preview to set border highlight and max size
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  opts.border_highlight = opts.border_highlight or { "FloatBorder" }

  -- Set maximum size constraints
  opts.max_width = opts.max_width or 80  -- Max width in columns
  opts.max_height = opts.max_height or 20  -- Max height in lines

  -- Optional: make floats minimal style (no extra borders inside)
  opts.style = opts.style or "minimal"

  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
-- FLOATING WINDOW

-- PROVIDERS

-- Smart disabling of unused providers
local function disable_unused_providers()
  -- Always disable these by default
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_ruby_provider = 0

  -- Check for Node.js based plugin usage
  local has_coc = vim.fn.globpath(vim.o.runtimepath, 'autoload/coc.vim') ~= ''

  if not has_coc then
    vim.g.loaded_node_provider = 0
  end

  -- Check if you need Python3 (common for some plugins)
  local has_pynvim = vim.fn.executable('pynvim') == 1

  if not has_pynvim then
    vim.g.loaded_python_provider = 0
  end
end

disable_unused_providers()

if vim.fn.filereadable('package.json') == 1 then
  vim.g.loaded_node_provider = 1
end

local function check_providers()
  local providers = {
    python3 = vim.g.loaded_python_provider,
    ruby = vim.g.loaded_ruby_provider,
    node = vim.g.loaded_node_provider,
    perl = vim.g.loaded_perl_provider,
  }

  for name, loaded in pairs(providers) do
    if loaded == 0 then
      print("Provider [" .. name .. "] is DISABLED")
    else
      print("Provider [" .. name .. "] is ENABLED")
    end
  end
end

-- You can manually call this with:
vim.api.nvim_create_user_command('CheckProviders', check_providers, {})
