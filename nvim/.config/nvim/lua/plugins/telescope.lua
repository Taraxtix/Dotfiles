-- Fuzzy finder UI

return {
  'nvim-telescope/telescope.nvim',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-project.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
  },

  event = 'VeryLazy',

  config = function()
    local telescope = require('telescope')

    telescope.setup({
      defaults = {
        layout_strategy = 'horizontal',
        follow_symlinks = true,
      },

      extensions = {
        project = {
          on_project_selected = function(prompt_bufnr)

            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')

            local entry = action_state.get_selected_entry()

            actions.close(prompt_bufnr)

            local project_path = entry.path or entry.value

            if not project_path or project_path == '' then
              return
            end

            vim.cmd('cd ' .. vim.fn.fnameescape(project_path))

            local ok, harpoon = pcall(require, 'harpoon')

            local function key()
              local cwd = vim.fn.getcwd()
              return vim.fs.normalize(cwd)
            end

            if ok then
              local list = harpoon:list(key())
              local len = type(list.length) == 'function' and list:length() or 0

              if len >= 1 then
                list:select(1)
                return
              end
            else
              vim.notify('Harpoon was unable to be required inside on_project_selected', vim.log.levels.ERROR)
            end

            require('telescope.builtin').find_files({
              cwd = project_path,
              hidden = true,
            })
          end,
        },
      },
    })

    telescope.load_extension('file_browser')
    telescope.load_extension('project')
  end,
}
