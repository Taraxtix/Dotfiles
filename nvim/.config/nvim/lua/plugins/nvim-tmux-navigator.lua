return {
  'christoomey/vim-tmux-navigator',
  lazy = false,

  config = function()
    local opts = { silent = true }

    vim.keymap.set('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', opts)
    vim.keymap.set('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', opts)
    vim.keymap.set('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', opts)
    vim.keymap.set('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', opts)
  end,
}
