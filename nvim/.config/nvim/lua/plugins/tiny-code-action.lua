-- lua/plugins/tiny-code-action.lua
-- Better LSP code-action UI, can use Telescope as the picker backend.

return {
  "rachartier/tiny-code-action.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- since you want Telescope UI for selection
  },
  config = function()
    require("tiny-code-action").setup({
      -- Use telescope as the picker UI.
      picker = "telescope",
    })
  end,
}
