-- VSCode-like Ctrl+D multi-cursor (add next occurrence).

return { "mg979/vim-visual-multi",

  -- Lazy-load on first use.
  keys = { { "<C-d>", mode = "n" }, { "<C-d>", mode = "x" }, },


  -- Must be set BEFORE the plugin is sourced.
  init = function()
    -- Force VM_maps to be a proper dictionary (Lua table -> Vim dict). This
    -- avoids E1206 when the plugin iterates it.
    vim.g.VM_maps = {
      -- VSCode behavior: add next occurrence of word under cursor.
      ["Find Under"] = "<C-d>",

      -- Also treat subword (camelCase/snake_case parts) similarly (optional).
      ["Find Subword Under"] = "<C-d>",

      -- Previous occurrence (may not be distinguishable in some terminals).
      ["Find Under Prev"] = "<C-S-d>",
    }
  end,
}
