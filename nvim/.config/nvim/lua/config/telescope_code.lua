-- Telescope entrypoints related to "Code" views (diagnostics, symbols, etc.)

local M = {}

-- Build a previewer that shows:
--   (top) full diagnostic message (multiline, wrapped)
--   (bottom) 2 lines above + line + 2 lines below (context excerpt)
local function diagnostic_message_and_context_previewer()
  local previewers = require("telescope.previewers")
  local putils = require("telescope.previewers.utils")
  local ns = vim.api.nvim_create_namespace("ConfigTelescopeDiagPreview")

  -- Helper: make a nice separator line that spans the preview window width.
  local function separator_line(winid)
    local w = vim.api.nvim_win_get_width(winid)
    if w < 10 then
      w = 10
    end
    -- Use box-drawing char; change to "-" if your font is weird.
    return string.rep("─", w - 2)
  end

  -- Helper: safely get context lines from a buffer around a 0-based line index.
  local function get_context(bufnr, lnum0)
    local line_count = vim.api.nvim_buf_line_count(bufnr)

    local start0 = math.max(0, lnum0 - 2)
    local end0_excl = math.min(line_count, lnum0 + 3) -- +3 because end is exclusive

    local lines = vim.api.nvim_buf_get_lines(bufnr, start0, end0_excl, true)

    return lines, start0
  end

  return previewers.new_buffer_previewer({
    title = "Diagnostic",

    -- Called whenever the selection changes.
    define_preview = function(self, entry, _)
      -- Clear any old highlights we added to this preview buffer.
      vim.api.nvim_buf_clear_namespace(self.state.bufnr, ns, 0, -1)

      -- Telescope entry shape varies by version; diagnostics may live in different fields.
      -- Try the common places in order.
      local diag = entry.value
      if type(diag) ~= "table" then
        diag = entry.diagnostic
      end
      if type(diag) ~= "table" then
        diag = entry.data end

        -- Use the diagnostic message if we found one; otherwise fall back to
        -- entry text.
        local msg = (type(diag) == "table" and diag.message) or
        entry.ordinal or "(no diagnostic message)"

        -- Buffer/position (prefer diagnostic fields, then entry fields).
        local bufnr = (type(diag) == "table" and diag.bufnr) or entry.bufnr
        local lnum = (type(diag) == "table" and diag.lnum) or entry.lnum

        -- Neovim diagnostics are 0-based; Telescope sometimes stores 1-based.
        -- If it looks 1-based, convert to 0-based.
        local lnum0 = nil if type(lnum) == "number" then if lnum >= 1 then
        lnum0 = lnum - 1 else lnum0 = lnum end end      local msg_lines =
        vim.split(msg, "\n", { plain = true })

      local out = {}
      -- Header: message section.
      table.insert(out, "DIAGNOSTIC MESSAGE")
      table.insert(out, "") -- blank spacer
      -- Message body.
      for _, line in ipairs(msg_lines) do
        table.insert(out, line)
      end
      -- Separator between message and context.
      table.insert(out, "")
      table.insert(out, separator_line(self.state.winid))
      table.insert(out, "")
      table.insert(out, "CONTEXT (±2 lines)")

      -- Context body.
      table.insert(out, "") -- spacer before context lines

      -- If we have a valid buffer/line, show excerpt; otherwise show a fallback.
      local diag_context_preview_row0 = nil -- will hold the preview-row of the diagnostic line for highlighting
      if bufnr and lnum0 ~= nil and vim.api.nvim_buf_is_valid(bufnr) then
        -- Fetch the context excerpt.
        local ctx_lines, start0 = get_context(bufnr, lnum0)

        -- Compute the width for line number column.
        local max_lnum = math.min(vim.api.nvim_buf_line_count(bufnr), lnum0 + 3)
        local lnum_width = tostring(max_lnum):len()

        -- Render each context line with line numbers.
        for i, line in ipairs(ctx_lines) do
          -- Actual buffer line number (1-based for display).
          local this_lnum1 = (start0 + (i - 1)) + 1

          -- Marker for the diagnostic line.
          local is_diag_line = (start0 + (i - 1)) == lnum0
          local mark = is_diag_line and "▶" or " "

          -- Format: "▶  123 | actual line"
          local prefix = string.format("%s %"..lnum_width.."d | ", mark, this_lnum1)

          -- Append to output.
          table.insert(out, prefix .. line)

          -- Record which preview row contains the diagnostic line (for highlighting).
          if is_diag_line then
            diag_context_preview_row0 = #out - 1
          end
        end
      else
        -- No buffer info available; show a fallback note.
        table.insert(out, "(no source buffer/position available for context)")
      end

      -- Set the preview buffer content.
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, out)

      -- Turn on wrapping so long diagnostic messages wrap in the top section.
      vim.api.nvim_set_option_value("wrap", true, { win = self.state.winid })
      vim.api.nvim_set_option_value("linebreak", true, { win = self.state.winid })

      -- Make preview buffer non-editable-like.
      vim.api.nvim_set_option_value("modifiable", false, { buf = self.state.bufnr })

      -- Highlight section headers.
      vim.api.nvim_buf_set_extmark(self.state.bufnr, ns, 0, 0, {
            hl_group = "Title",
            hl_eol = true,
          })
      local sep_row0 = nil
      -- Find the separator row to highlight it.
      for i, line in ipairs(out) do
        if line:match("^─") then
          sep_row0 = i - 1 -- convert to 0-based
          break
        end
      end
      if sep_row0 then
        -- vim.api.nvim_buf_add_highlight(self.state.bufnr, ns, "Comment", sep_row0, 0, -1)
        vim.api.nvim_buf_set_extmark(self.state.bufnr, ns, sep_row0, 0, {
          hl_group = "Comment",
          hl_eol = true,
        })
      end

      -- Highlight context header if present.
      for i, line in ipairs(out) do
        if line == "CONTEXT (±2 lines)" then
          vim.api.nvim_buf_set_extmark(self.state.bufnr, ns, i - 1, 0, {
            hl_group = "Title",
            hl_eol = true,
          })
          break
        end
      end

      -- Highlight the diagnostic line inside the context excerpt (if we found it).
      if diag_context_preview_row0 then
        -- Highlight the whole line; you can change group if you want it stronger.
        vim.api.nvim_buf_set_extmark(self.state.bufnr, ns, diag_context_preview_row0, 0, {
          hl_group = "Visual",
          hl_eol = true,
        })
      end

      -- Optional: give the preview some syntax-like highlighting.
      -- (This is mild; remove if you dislike it.)
      putils.highlighter(self.state.bufnr, "markdown")
    end,
  })
end

-- Show diagnostics in Telescope with severity sorting and the custom previewer.
function M.diagnostics()
  local builtin = require("telescope.builtin")

  builtin.diagnostics({
    -- Whole workspace diagnostics (set bufnr = 0 if you want current buffer only).
    workspace_diagnostics = true,

    -- Sort by severity (ERROR first).
    severity_sort = true,

    -- Use our composite previewer.
    previewer = diagnostic_message_and_context_previewer(),
  })
end

return M
