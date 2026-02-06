-- Ensures Mason-installed LSP servers are wired into nvim-lspconfig.

return {
  "williamboman/mason-lspconfig.nvim",

  dependencies = {
    "williamboman/mason.nvim",
  },

  -- Provide commands early.
  cmd = { "Mason", "LspInfo", "LspLog" },

  config = function()
    local mlsp = require("mason-lspconfig")

    mlsp.setup({
      ensure_installed = {
        "lua_ls", -- Lua language server (LuaLS).
        "marksman",
      },

      automatic_installation = true,
    })
  end,
}
