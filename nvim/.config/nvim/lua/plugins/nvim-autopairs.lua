-- Automatically inserts closing pairs and provides "smart quotes" behavior.

return {
  "windwp/nvim-autopairs",

  event = "InsertEnter",

  config = function()
    local npairs = require("nvim-autopairs")

    npairs.setup({
      enable_check_bracket_line = true,

      -- Prevent autopairs in some contexts (we keep defaults for now).
      check_ts = false,
    })

    -- Load the Rule constructor to customize pairing logic.
    local Rule = require("nvim-autopairs.rule")

    -- Load built-in conditions helpers.
    local cond = require("nvim-autopairs.conds")

    -- Helper: count occurrences of a character on the current line up to the cursor.
    local function count_before_cursor(char)
      -- Get current line as a string.
      local line = vim.api.nvim_get_current_line()

      -- Get cursor column (0-based).
      local col = vim.api.nvim_win_get_cursor(0)[2]

      -- Take substring from start of line up to cursor (exclusive).
      local before = line:sub(1, col)

      -- Count occurrences of the target char.
      local _, n = before:gsub(vim.pesc(char), "")

      -- Return the count.
      return n
    end

    -- Smart rule for double quotes:
    -- If there is an odd number of " before cursor on the line, we are "inside" quotes,
    -- so typing " should likely close (no auto-insert of another ").
    npairs.add_rule(
      Rule([["]], [["]])
        :with_pair(function()
          -- If count is even, we open a new quote pair.
          return (count_before_cursor([["]]) % 2) == 0
        end)
        -- If next char is a quote, allow moving over it rather than inserting.
        :with_move(cond.none())
        :with_del(cond.none())
        :with_cr(cond.none())
    )

    -- Smart rule for single quotes:
    -- Same logic as double quotes (odd/even count on line).
    npairs.add_rule(
      Rule([["'"]], [["'"]])
        :with_pair(function()
          -- If count is even, open a new quote pair.
          return (count_before_cursor("'") % 2) == 0
        end)
        -- Avoid pairing in words like don't / it's by requiring not alphanumeric before/after.
        :with_pair(cond.not_before_regex("[%w_]"))
        :with_pair(cond.not_after_regex("[%w_]"))
        :with_move(cond.none())
        :with_del(cond.none())
        :with_cr(cond.none())
    )

    -- Smart rule for backticks:
    -- Great for Markdown and many shells.
    npairs.add_rule(
      Rule("`", "`")
        :with_pair(function()
          -- If count is even, open a new backtick pair.
          return (count_before_cursor("`") % 2) == 0
        end)
        :with_move(cond.none())
        :with_del(cond.none())
        :with_cr(cond.none())
    )
  end,
}
