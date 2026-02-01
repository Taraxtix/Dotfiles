local M = {}

M.cwd = function()
  local telescope = require('telescope') -- Telescope main module.
  local fb = telescope.extensions.file_browser -- file_browser extension entrypoint.
  local actions = require('telescope.actions') -- Telescope actions.
  local action_state = require('telescope.actions.state') -- Read current selection.

  local root = vim.fn.expand('~') -- Start browsing from HOME.

  fb.file_browser({
    path = root, -- Initial path shown in the browser.
    cwd = root, -- Base cwd for the picker.
    hidden = true, -- Show dotfiles/dirs.
    grouped = true, -- Group directories first (nice for navigation).
    select_buffer = true, -- Reuse current buffer for the browser UI.
    follow_symlink = true,

    attach_mappings = function(prompt_bufnr, map)
      -- We keep default <CR> behavior so you can keep browsing into directories.

      -- Function to set cwd to the currently selected entry.
      local function set_cwd_to_selection()
        local entry = action_state.get_selected_entry() -- Selected node.
        if not entry then
          return
        end

        local p = entry.path -- Full path from file_browser.
        local stat = vim.uv.fs_stat(p) -- File/dir stat.

        -- If user selected a file, cd to its parent directory.
        if stat and stat.type == 'file' then
          p = vim.fs.dirname(p)
        end

        actions.close(prompt_bufnr) -- Close the picker.
        vim.fn.chdir(p) -- :cd equivalent.
        vim.notify('cwd → ' .. vim.fn.getcwd(), vim.log.levels.INFO) -- Confirm.
      end

      -- Ctrl+Enter: set cwd (may not work in every terminal).
      map('i', '<C-CR>', set_cwd_to_selection) -- Insert-mode mapping in picker.
      map('n', '<C-CR>', set_cwd_to_selection) -- Normal-mode mapping in picker.

      -- Fallback: "C" to set cwd (works everywhere).
      map('i', 'C', set_cwd_to_selection) -- Insert-mode.
      map('n', 'C', set_cwd_to_selection) -- Normal-mode.

      return true -- Keep other default mappings.
    end,
  })
end

return M
