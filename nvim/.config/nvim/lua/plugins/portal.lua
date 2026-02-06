-- Enhanced jumplist/changelist navigation (browser-like back/forward with a UI).

return {
  "cbochs/portal.nvim",

  keys = {
    { "<leader>cg[", mode = "n" },
    { "<leader>cg]", mode = "n" },
  },

  config = function()
    local portal = require("portal")

    portal.setup({
      -- Defaults
    })

    vim.keymap.set("n", "<leader>cg[", "<cmd>Portal jumplist backward<cr>" , { desc = "Code: go back (jumplist)" })

    vim.keymap.set("n", "<leader>cg]", "<cmd>Portal jumplist forward<cr>", { desc = "Code: go forward (jumplist)" })
  end,
}

