return {
  "bbjornstad/pretty-fold.nvim",
  event = { "BufReadPost", "BufNewFile" },

  config = function()
    require("pretty-fold").setup({
      -- Keep default for now
    })
  end,
}
