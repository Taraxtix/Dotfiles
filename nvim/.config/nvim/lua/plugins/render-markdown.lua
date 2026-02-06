return {
  'MeanderingProgrammer/render-markdown.nvim',

  ft = { 'markdown', 'markdown.mdx' },

  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },

  -- Plugin options.

  config = function()
    local rm = require('render-markdown')

    rm.setup({
      render_modes = true, -- Render in every mode
    })

    -- Optional: provide a toggle (View → Toggle → Markdown render).
    vim.keymap.set('n', '<leader>vtm', function()
      rm.toggle()
    end, { desc = 'View: toggle Markdown render' })
  end,
}
