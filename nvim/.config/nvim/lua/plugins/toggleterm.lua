return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      direction = "float",
      shade_terminals = false,
      start_in_insert = true,
      persist_mode = true,
      persist_size = true,
      close_on_exit = false,
      float_opts = {
        border = "rounded",
        width = function()
          return math.floor(vim.o.columns * 0.92)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.92)
        end,
        winblend = 0,
      },
    })
  end,
}
