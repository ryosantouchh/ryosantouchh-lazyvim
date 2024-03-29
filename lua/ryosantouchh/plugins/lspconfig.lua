return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require("lsp-zero")
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        local opts = { buffer = bufnr }

        lsp_zero.default_keymaps(opts)
        vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<cr>", opts)
        vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        vim.keymap.set("n", "<leader>gk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
        vim.keymap.set("n", "<leader>gj", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)

        lsp_zero.buffer_autoformat()
      end)

      -- (Optional) Configure lua language server for neovim
      lsp_zero.set_sign_icons({
        error = "✘",
        warn = "▲",
        hint = "⚑",
        info = "»",
      })

      mason_lspconfig.setup({
        ensure_installed = {
          -- golang
          "gopls",
          "golangci_lint_ls",

          -- typescript/javascript
          "tsserver",
          "vtsls",
          "biome",
          "quick_lint_js",

          -- frontend core
          "html",
          "cssls",
          "cssmodules_ls",
          "unocss",
          "tailwindcss",

          -- docker
          "dockerls",
          "docker_compose_language_service",

          "eslint",

          -- haskell
          "hls",

          -- openapi/yaml
          "spectral",
          "vacuum",
          "hydra_lsp",
          "yamlls",

          "prismals", -- prisma

          -- sql
          "sqlls",
          "sqls",
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            lspconfig.lua_ls.setup(lua_opts)
          end,
        },
      })
    end,
  },
}
