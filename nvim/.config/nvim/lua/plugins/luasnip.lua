-- Snippet engine required by nvim-cmp for snippet expansion.

return {
  "L3MON4D3/LuaSnip",

  event = "InsertEnter",

  -- Optional build step for better regex performance (safe to skip).
  build = "make install_jsregexp",

  config = function()
    local ls = require("luasnip")

    ls.config.set_config({
      history = true,

      -- Update snippets as you type (dynamic nodes).
      updateevents = "TextChanged,TextChangedI",
    })
  end,
}
