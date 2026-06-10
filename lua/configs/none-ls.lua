-- none-ls now only surfaces diagnostics that have no native LSP equivalent.
-- All formatting is handled by conform (see configs/conform.lua).
local none_ls = require "null-ls"

require("mason-null-ls").setup {
  ensure_installed = { "checkmake" },
  automatic_installation = true,
}

none_ls.setup {
  sources = {
    none_ls.builtins.diagnostics.checkmake,
  },
}
