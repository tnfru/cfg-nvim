-- lua/plugins/init.lua
return {
  -- Existing plugins
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  -- LSP configuration with Mason integration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Mason for automatic LSP installation
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Completion capabilities for LSP
      "hrsh7th/cmp-nvim-lsp",

      -- LSP status updates
      {
        "j-hui/fidget.nvim",
        tag = "v1.4.0",
      },

      -- Telescope for LSP navigation features
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Load LSP config first (includes NvChad defaults)
      require "configs.lspconfig"

      -- Apply diagnostic config AFTER NvChad defaults so we override them.
      -- Also re-apply on LspAttach since NvChad may override during async attach.
      local diag_config = {
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅙",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "󰋼",
            [vim.diagnostic.severity.HINT] = "󰌵",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "single",
          suffix = function(diag)
            if diag.code and diag.source then
              local source = diag.source:lower()
              if source:find("ruff") then
                return " " .. diag.code .. " https://docs.astral.sh/ruff/rules/" .. diag.code .. " ", "DiagnosticUnnecessary"
              end
              if source:find("ty") then
                return " " .. diag.code .. " https://docs.astral.sh/ty/reference/rules/#" .. diag.code .. " ", "DiagnosticUnnecessary"
              end
            end
            if diag.code then
              return " [" .. diag.code .. "]", "DiagnosticUnnecessary"
            end
            return "", ""
          end,
        },
      }

      vim.diagnostic.config(diag_config)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user-diagnostic-config", { clear = true }),
        callback = function()
          vim.diagnostic.config(diag_config)
        end,
      })
    end,
  },

  -- None-ls with Mason integration
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
      "jayp0521/mason-null-ls.nvim",
    },
    config = function()
      require "configs.none-ls"
    end,
  },

  -- Pretty UI for vim.ui.input/select (NvimTree create, LSP rename, etc.)
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { relative = "cursor" },
    },
  },

  -- Telescope ignore patterns
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = {
          "%.git/",
          "__pycache__/",
          "%.venv/",
          "node_modules/",
          "%.pyc$",
        },
      },
    },
  },

  -- Surround: ys/cs/ds to add/change/delete surrounding chars
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- Treesitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "bash",
        "python",
        "json",
        "yaml",
        "toml",
      },
    },
  },
}
