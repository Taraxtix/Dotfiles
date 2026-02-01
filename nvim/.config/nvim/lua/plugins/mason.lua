-- Mason: manages external tooling (LSP servers, formatters, linters).

return {
  "williamboman/mason.nvim",

  -- Provide Mason command early so you can run :Mason anytime.
  cmd = { "Mason" },

  config = function()
    local mason = require("mason")

    mason.setup({
      -- We keep defaults for now
    })
  end,
}
