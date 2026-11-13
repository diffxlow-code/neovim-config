-- general nvim settings

---@diagnostic disable: undefined-global
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.updatetime = 20
vim.opt.wrap = false
vim.opt.guicursor = ""
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "

-- lazy plugin manager setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- prefix keys
vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"
-- localmap leader also exists but i dont use it

-- we keep all our plugins here

require("lazy").setup({
    spec = {
        -- colorscheme
        { "aymenhafeez/doric-themes.nvim", priority = 1000 },
        {"metalelf0/base16-black-metal-scheme"},
        "Mofiqul/vscode.nvim",
        --telescope

        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            opts = {
                defaults = {
                    prompt_prefix = "  ",
                    selection_caret = "  ",
                    entry_prefix = "  ",

                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",

                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.45,
                            results_width = 0.55,
                        },
                        width = 0.80,
                        height = 0.80,
                        preview_cutoff = 120,
                    },

                    border = false,
                    winblend = 0,

                    path_display = { "truncate" },
                    color_devicons = false,

                    results_title = false,
                    prompt_title = false,
                    preview_title = false,

                    dynamic_preview_title = false,

                    mappings = {
                        i = {
                            ["<C-j>"] = "move_selection_next",
                            ["<C-k>"] = "move_selection_previous",
                        },
                        n = {
                            ["j"] = "move_selection_next",
                            ["k"] = "move_selection_previous",
                        },
                    },
                },
            },
        },
        -- Mason for lsp
        {
            "mason-org/mason.nvim",
            opts = {}
        },

        -- nvim-cmp for auto completion

        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                -- lspkind is for icons
                "onsails/lspkind.nvim",
            },
            config = function()
                local cmp = require("cmp")

                cmp.setup({
                    completion = {
                        completeopt = "menu,menuone,noselect",
                    },

                    experimental = {
                        ghost_text = true,
                    },

                    -- key mappings for completion


                    mapping = cmp.mapping.preset.insert({
                        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                        ["<CR>"] = cmp.mapping.confirm({ select = false }),
                        ["<C-n>"] = cmp.mapping.select_next_item(),
                        ["<C-p>"] = cmp.mapping.select_prev_item(),
                        ["<C-e>"] = cmp.mapping.abort(),
                    }),
                    -- sources for completion 
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "path" },
                        { name = "buffer" },
                    }),

                    -- icons 
                    formatting = {
                        format = require("lspkind").cmp_format({
                            mode = "symbol_text",
                            maxwidth = 50,
                            ellipsis_char = "...",
                        }),
                    },

                })
            end,
        },

        {
            "https://github.com/ej-shafran/compile-mode.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },

            config = function ()
                vim.g.compile_mode = {
                    default_command = "/home/dev_aadarsh/.local/bin/ziggy/zig build",
                }
            end
        },

        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            lazy = false,
            config = function()
                require("nvim-treesitter").setup()
            end,
        },
    },

    -- automatic plugin update check
    checker = { enabled = true },
})

vim.cmd("colorscheme base16-black-metal-gorgoroth")

vim.api.nvim_set_hl(0, "LineNr", {
    fg = "#666666",
    bg = "none",
})

vim.api.nvim_set_hl(0, "CursorLineNr", {
    fg = "#ffffff",
    bg = "none",
    bold = false,
})

--telescope ( done as documentation )

local builtin = require("telescope.builtin");
vim.keymap.set('n', '<leader>pv', builtin.find_files, { desc = 'netrw menu' })
vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- quality of life keymaps
vim.keymap.set('n', '<leader>nh', ":nohl<CR>", { desc = 'Remove search highlights' })
vim.keymap.set('n', '<leader>gg', "GG", { desc = 'go to bottom' })
vim.keymap.set('n', '<leader>le', ":vsplit<CR>", { desc = 'split window' })
vim.keymap.set('n', '<leader>lt', ":tabnew %<CR>", { desc = 'open a new tab with current buffer' })

-- some lsp keymaps
vim.keymap.set('n', 'gd',vim.lsp.buf.definition, { desc = 'goto definition' })
vim.keymap.set('n', 'gr',vim.lsp.buf.references, { desc = 'goto references' })


-- code actions
vim.keymap.set('n', '<leader>ca',vim.lsp.buf.code_action, { desc = 'code actions' })



-- lsp config shit
-- lil helper function I wrote
-- cmd might be different (write abs path instead)

function Default_lsp_setup(name,cmd,filetypes,root_markers)
    vim.lsp.config(name, {
        cmd = { cmd },
        filetypes = { filetypes },
        root_markers =  root_markers ,
    })

    vim.lsp.enable(name)

end

-- we call the function for each lsp config we want

-- provide absolute path to your language server executable   
Default_lsp_setup("zls","/home/dev_aadarsh/.local/share/nvim/mason/packages/zls/zls","zig",{ 'build.zig','build.zig.zon','.git'})
Default_lsp_setup("lua-language-server","/home/dev_aadarsh/.local/share/nvim/mason/packages/lua-language-server/lua-language-server","lua",{'.git'})
-- and so on

-- for inline diagnostics (errors and all that stuff)
vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = false,
    underline = true,
    signs = true,
})

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", {
    fg = "#b06a6a",
    bg = "#241719",
    italic = true,
})

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", {
    fg = "#b09a70",
    bg = "#242018",
    italic = true,
})

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", {
    fg = "#819b9b",
    bg = "#192122",
    italic = true,
})

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", {
    fg = "#888888",
    bg = "#202020",
    italic = true,
})

-- for inlay hints

vim.api.nvim_set_hl(0, "LspInlayHint", {
    fg = "#ffffff",
})

vim.lsp.inlay_hint.enable(true)
