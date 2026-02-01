return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  commit = 'e76cb03',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  -- Lazy-load when these keys are used (so it doesn't slow startup).
  keys = {
    { '<leader>ha', mode = 'n' },

    { '<leader>hs', mode = 'n' },

    -- Jump to slots 1..9.
    { '<leader>h1', mode = 'n' },
    { '<leader>h2', mode = 'n' },
    { '<leader>h3', mode = 'n' },
    { '<leader>h4', mode = 'n' },
    { '<leader>h5', mode = 'n' },
    { '<leader>h6', mode = 'n' },
    { '<leader>h7', mode = 'n' },
    { '<leader>h8', mode = 'n' },
    { '<leader>h9', mode = 'n' },
  },

  config = function()
    local harpoon = require('harpoon')

    local function key()
      local cwd = vim.fn.getcwd()
      return vim.fs.normalize(cwd)
    end

    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,

        key = key,
      },
    })

    local function list()
      return harpoon:list(key())
    end

    -- vim.api.nvim_create_autocmd('VimLeavePre', {
    --   desc = 'Harpoon: save on VimLeavePre',
    --   callback = function()
    --     if list() and type(list().save) == 'function' then
    --       list():save()
    --     end
    --
    --     if harpoon and type(harpoon.save) == 'function' then
    --       harpoon.save()
    --     end
    --   end,
    -- })
    --
    -- vim.api.nvim_create_autocmd('DirChanged', {
    --   desc = 'Harpoon: refresh list when project/cwd changes',
    --   callback = function()
    --     harpoon:list()
    --   end,
    -- })

    -- Add current file to the project's list.
    vim.keymap.set('n', '<leader>ha', function()
      list():add()
    end, { desc = 'harpoon current buffer file' })

    vim.keymap.set('n', '<leader>hs', function()
      harpoon.ui:toggle_quick_menu(list())
    end, { desc = 'Show harpoon menu' })

    for i = 1, 9 do
      vim.keymap.set('n', ('<leader>h%d'):format(i), function()
        list():select(i)
      end, { desc = ('Harpoon: go to %d'):format(i) })
    end

    local wk = require('which-key')
    wk.add({
      { '<leader>h', group = 'Harpoon' },
      { '<leader>ha', desc = 'Add current buffer' },
      { '<leader>hs', desc = 'Show menu' },
    })
  end,
}
