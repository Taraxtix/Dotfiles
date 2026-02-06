return {
  "iamcco/markdown-preview.nvim",

  ft = { "markdown", "markdown.mdx" },

  build = "cd app && npm install",
  init = function() vim.g.mkdp_filetypes = { "markdown" } end,

  config = function()
    -- Use a custom browser (optional).
    -- vim.g.mkdp_browser = "firefox"

    -- Make preview open on demand (not auto).
    vim.g.mkdp_auto_start = 0

    -- Stop preview when leaving buffer (optional).
    vim.g.mkdp_auto_close = 1

    -- Keybind: Show → Markdown → Preview (toggle).
    vim.keymap.set("n", "<leader>smp", "<cmd>MarkdownPreviewToggle<CR>", {
      desc = "Show: Markdown preview (browser)",
    })
  end,
}

