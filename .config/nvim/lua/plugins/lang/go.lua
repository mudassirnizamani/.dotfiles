return {
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()',
        config = function()
            require("go").setup({
                goimports = 'gopls', -- Use gopls for imports
                fillstruct = 'gopls', -- Use gopls for struct filling
                dap_debug = false, -- Disable DAP to avoid conflicts
                dap_debug_gui = false,
                lsp_cfg = false, -- Don't let go.nvim configure LSP
                lsp_gofumpt = true,
                lsp_on_attach = false, -- Don't override LSP attach
                trouble = false, -- Use existing trouble config
                luasnip = true,
            })

            -- Go keymaps autocmd
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "go" },
                callback = function(ev)
                    -- CTRL/control keymaps for Go
                    vim.api.nvim_buf_set_keymap(0, "n", "<C-i>", ":GoImport<CR>", {})
                    vim.api.nvim_buf_set_keymap(0, "n", "<C-b>", ":GoBuild %:h<CR>", {})
                    vim.api.nvim_buf_set_keymap(0, "n", "<C-t>", ":GoTestPkg<CR>", {})
                    vim.api.nvim_buf_set_keymap(0, "n", "<C-c>", ":GoCoverage -p<CR>", {})
                end,
                group = vim.api.nvim_create_augroup("go_autocommands", { clear = true })
            })
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        config = function() 
            require("lsp_signature").setup({
                bind = true,
                handler_opts = {
                    border = "rounded"
                }
            }) 
        end
    }
}