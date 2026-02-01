return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,

  priority = 1000, -- Ensure theme loads before other UI plugins.

  config = function()
    require("rose-pine").setup({
      -- Use defaults for now
    })

    vim.cmd.colorscheme("rose-pine")

    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment" })
  end,
}

