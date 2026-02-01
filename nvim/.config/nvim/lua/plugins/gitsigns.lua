-- lua/plugins/gitsigns.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      return {
        signcolumn = true, -- show signs in signcolumn
        numhl = false,     -- number highlighting
        linehl = false,    -- full line highlighting
        word_diff = false,

        signs = {
          add          = { text = "+" },
          change       = { text = "~" },
          delete       = { text = "-" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~-" },
          untracked    = { text = "┆" },
        },
      }
    end,

    config = function(_, opts)
      require("gitsigns").setup(opts)

      vim.opt.signcolumn = "yes"

      -- ---------------------------
      -- Diff toggle: <leader>gtd
      -- ---------------------------
      local gs = require("gitsigns")

      local function diff_is_on()
        -- diff mode is window-local
        return vim.wo.diff
      end

      local function toggle_diff()
        if diff_is_on() then
          vim.cmd("diffoff")
          return
        end

        gs.diffthis()
      end

      vim.keymap.set("n", "<leader>gtd", toggle_diff, { desc = "Git: toggle diff (HEAD)" })

      -- ----------------------------------------------------
      -- Merge conflict helpers (no extra plugin required)
      -- ----------------------------------------------------
      local function is_git_dir(path)
        return path and #path > 0 and vim.uv.fs_stat(path) ~= nil
      end

      local function get_git_dir()
        local ok_cache, cache = pcall(require, "gitsigns.cache")
        if ok_cache and cache and cache.cache and cache.cache[vim.api.nvim_get_current_buf()] then
          local c = cache.cache[vim.api.nvim_get_current_buf()]
          if c and c.gitdir then
            return c.gitdir
          end
        end

        local out = vim.fn.systemlist({ "git", "rev-parse", "--git-dir" })
        if vim.v.shell_error ~= 0 or not out[1] then
          return nil
        end

        local gd = out[1]
        if not gd:match("^/") then
          gd = vim.fn.fnamemodify(gd, ":p")
        end
        return gd
      end

      local function merge_in_progress()
        local gitdir = get_git_dir()
        if not gitdir then
          return false
        end

        -- common indicators:
        -- MERGE_HEAD: merge
        -- rebase-apply / rebase-merge: rebase
        -- CHERRY_PICK_HEAD: cherry-pick
        -- REVERT_HEAD: revert
        return is_git_dir(gitdir .. "/MERGE_HEAD")
          or is_git_dir(gitdir .. "/rebase-apply")
          or is_git_dir(gitdir .. "/rebase-merge")
          or is_git_dir(gitdir .. "/CHERRY_PICK_HEAD")
          or is_git_dir(gitdir .. "/REVERT_HEAD")
      end

      local function has_conflict_markers()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for _, l in ipairs(lines) do
          if l:match("^<<<<<<<") or l:match("^=======") or l:match("^>>>>>>>") then
            return true
          end
        end
        return false
      end

      local function notify_warn(msg)
        vim.notify(msg, vim.log.levels.WARN, { title = "Git" })
      end

      local function conflict_next()
        if not has_conflict_markers() then
          notify_warn("No conflict markers in this buffer.")
          return
        end
        vim.fn.search("^<<<<<<<", "W")
      end

      local function conflict_prev()
        if not has_conflict_markers() then
          notify_warn("No conflict markers in this buffer.")
          return
        end
        vim.fn.search("^<<<<<<<", "bW")
      end

      -- Resolve helpers via :diffget
      -- In a 3-way merge in diff mode, these typically map to:
      --   //2 = ours, //3 = theirs (depends on setup, but this is the common convention)
      -- If not in diff mode, we still can help using conflict markers only (see below).
      local function diffget_ours()
        if not diff_is_on() then
          notify_warn("Not in diff mode. Use <leader>gtd to open a diff first.")
          return
        end
        vim.cmd("diffget //2")
      end

      local function diffget_theirs()
        if not diff_is_on() then
          notify_warn("Not in diff mode. Use <leader>gtd to open a diff first.")
          return
        end
        vim.cmd("diffget //3")
      end

      -- Marker-based resolution (works even without diff mode):
      -- Select the conflict block and keep either side.
      local function resolve_with_markers(which)
        if not has_conflict_markers() then
          notify_warn("No conflict markers in this buffer.")
          return
        end

        -- Find nearest conflict start above cursor
        local cur = vim.api.nvim_win_get_cursor(0)[1] - 1
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

        local start = nil
        for i = cur, 0, -1 do
          if lines[i + 1]:match("^<<<<<<<") then
            start = i
            break
          end
        end
        if start == nil then
          notify_warn("Cursor is not inside a conflict block.")
          return
        end

        local mid, finish = nil, nil
        for i = start + 1, #lines - 1 do
          if lines[i + 1]:match("^=======") then
            mid = i
          elseif lines[i + 1]:match("^>>>>>>>") then
            finish = i
            break
          end
        end

        if not (mid and finish) then
          notify_warn("Malformed conflict markers (missing ======= or >>>>>>>).")
          return
        end

        -- Build replacement depending on choice
        local keep = {}
        if which == "ours" then
          for i = start + 1, mid - 1 do
            table.insert(keep, lines[i + 1])
          end
        elseif which == "theirs" then
          for i = mid + 1, finish - 1 do
            table.insert(keep, lines[i + 1])
          end
        elseif which == "both" then
          for i = start + 1, mid - 1 do
            table.insert(keep, lines[i + 1])
          end
          for i = mid + 1, finish - 1 do
            table.insert(keep, lines[i + 1])
          end
        elseif which == "none" then
          keep = {}
        end

        -- Replace the whole conflict block [start..finish] with keep
        vim.api.nvim_buf_set_lines(0, start, finish + 1, false, keep)
      end

      -- Keymaps (choose a consistent category: <leader>g m ...)
      vim.keymap.set("n", "<leader>g]c", conflict_next, { desc = "Git: next conflict" })
      vim.keymap.set("n", "<leader>g[c", conflict_prev, { desc = "Git: prev conflict" })

      -- Prefer diffget when in diff mode, fallback to marker-based when not.
      vim.keymap.set("n", "<leader>gco", function()
        if diff_is_on() then
          diffget_ours()
        else
          resolve_with_markers("ours")
        end
      end, { desc = "Git: take ours" })

      vim.keymap.set("n", "<leader>gct", function()
        if diff_is_on() then
          diffget_theirs()
        else
          resolve_with_markers("theirs")
        end
      end, { desc = "Git: take theirs" })

      vim.keymap.set("n", "<leader>gcb", function()
        resolve_with_markers("both")
      end, { desc = "Git: take both" })

      vim.keymap.set("n", "<leader>gcn", function()
        resolve_with_markers("none")
      end, { desc = "Git: take none" })

      -- Optional: warn if you're in a merge state (nice UX)
      vim.api.nvim_create_user_command("GitMergeStatus", function()
        if merge_in_progress() then
          vim.notify("Merge/rebase/cherry-pick in progress.", vim.log.levels.INFO, { title = "Git" })
        else
          vim.notify("No merge/rebase/cherry-pick in progress.", vim.log.levels.INFO, { title = "Git" })
        end
      end, {})
    end,
  },
}

