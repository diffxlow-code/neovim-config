-- Basic options
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.guicursor = ""
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
vim.opt.termguicolors = true
vim.g.mapleader = " "

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "[https://github.com/folke/lazy.nvim.git](https://github.com/folke/lazy.nvim.git)", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
    {"nvim-telescope/telescope.nvim", dependencies = {"nvim-lua/plenary.nvim"}},
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {"projekt0n/github-nvim-theme", name = "github-theme"},
    {"windwp/nvim-autopairs", event = "InsertEnter", config = true},
    {"hrsh7th/nvim-cmp"}, {"hrsh7th/cmp-nvim-lsp"}, {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-path"}, {"L3MON4D3/LuaSnip"},
    {"rose-pine/neovim", name = "rose-pine"}, {"ThePrimeagen/vim-be-good"},
    {"olimorris/onedarkpro.nvim", priority = 1000},
    {"mrcjkb/rustaceanvim", version = "^6", lazy = false},
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = {"BufReadPre", "BufNewFile"},
        opts =
        {
            indent = {char = "│", tab_char = "│",
            highlight = {"IblIndent"}},
            whitespace = {remove_blankline_trail = true},
            scope = {enabled = true, highlight = {"IblScope"},
            show_start = false, show_end = false},
            exclude = {filetypes = {"help", "dashboard", "lazy",
            "NvimTree", "Trouble", "terminal"},
            buftypes = {"terminal", "nofile"}},
        },
        config = function(_, opts) require("ibl").setup(opts)
            vim.api.nvim_set_hl(0, "IblIndent", {fg = "#555555"})
            vim.api.nvim_set_hl(0, "IblScope", {fg = "#ff5555"})
        end,
    },
    {
        "folke/flash.nvim",
        opts = {
            highlight  = {
                backdrop = false;
            }
        }
        , event = "VeryLazy",
        keys = {
            {"s", mode = {"n", "x", "o"}, function() require("flash").jump() end,
            desc = "Flash"},
            {"S", mode = {"n", "x", "o"},
            function() require("flash").treesitter() end, desc = "Flash Treesitter"},
            {"r", mode = "o", function() require("flash").remote() end,
            desc = "Remote Flash"},
            {"R", mode = {"o", "x"},
            function() require("flash").treesitter_search() end,
            desc = "Treesitter Search"},
            {"<c-s>", mode = {"c"}, function() require("flash").toggle() end,
            desc = "Toggle Flash Search"},
        },
    }
})

-- Theme
require("rose-pine").setup({ styles = { bold = fasle, italic = false, transparency = true }})
vim.cmd("colorscheme rose-pine")

-- Treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = { "cpp", "c", "lua", "python", "rust" },
    highlight = { enable = true, additional_vim_regex_highlighting = false },
})


-- Telescope keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-f>", function() builtin.find_files({ cwd = vim.fn.getcwd() }) end, { noremap = true,  silent =  true })
vim.keymap.set("n", "<C-s>", function() builtin.live_grep({ cwd = vim.fn.getcwd() }) end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", function() builtin.buffers({ cwd = vim.fn.getcwd() }) end, { noremap = true, silent = true })
vim.keymap.set("n", "0","^")

-- Autocomplete setup
local cmp = require("cmp")
cmp.setup({
    snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    }),
    sources = { { name = "nvim_lsp" }, { name = "buffer" }, { name = "path" } },
})

-- Rustaceanvim setup (handles rust-analyzer + inlay hints)
vim.g.rustaceanvim = {
    lsp = true,
    inlay_hints = {
        enable = true,
        highlight = "LspInlayHint",
        show_parameter_hints = true,
        parameter_hints_prefix = " [",
        parameter_hints_suffix = "] ",
        other_hints_prefix = " => ",
        max_len_align = false,
        right_align = false,
    },
    server = {
        on_attach = function(_, bufnr)
            local opts = { buffer = bufnr, silent = true }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        end,
        settings = {
            ["rust-analyzer"] = {
                inlayHints = {
                    bindingModeHints = { enable = true },
                    chainingHints = { enable = true },
                    closureReturnTypeHints = { enable = "always" },
                    typeHints = { enable = true },
                    parameterHints = { enable = true },
                },
            },
        },
    },
}

vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#ff5555",italic = false })



-- Highlight for inlay hints

-- Diagnostics
vim.diagnostic.config({
    virtual_text = { prefix = "●", source = "always" },
    signs = true,
    underline = true,
    severity_sort = true,
    update_in_insert = true,
})
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#ff5555" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#ffaa00" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#00aaff" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#8888ff" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true })
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { noremap = true, silent = true })

vim.cmd("lua vim.lsp.inlay_hint.enable(true)")
