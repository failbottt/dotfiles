-- This file can be loaded by calling `lua require('plugins')` from your init.vim

print("PACKER CALLED");
-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }

    -- debugging
    use('mfussenegger/nvim-dap')
    use('leoluz/nvim-dap-go')
    use('rcarriga/nvim-dap-ui')
    use('theHamsta/nvim-dap-virtual-text')
    use('nvim-telescope/telescope-dap.nvim')

    use({
        'kelly-lin/telescope-ag',
        requires = { 'nvim-telescope/telescope.nvim' },
    })

    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use('tpope/vim-commentary')
    use('klen/nvim-test')

    use('nvim-lua/plenary.nvim')
    use('ThePrimeagen/harpoon')
end)

