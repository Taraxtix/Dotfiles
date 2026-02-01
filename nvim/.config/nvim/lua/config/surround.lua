-- lua/config/surround.lua
-- Surround the *current* Visual selection reliably.
-- IMPORTANT: '< and '> are often only finalized after leaving Visual mode,
-- so we use getpos("v") (visual anchor) + current cursor instead.

local M = {} -- Module table.

-- Surround the current Visual selection with left/right strings.
function M.surround_visual(left, right)
  -- Get the current buffer handle.
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get the current Visual mode:
  -- "v"  = characterwise
  -- "V"  = linewise
  -- "\22" = blockwise (Ctrl-V) (we won't fully support blockwise here yet)
  local vmode = vim.fn.visualmode()

  -- getpos("v") returns { bufnum, lnum, col, off }.
  -- lnum is 1-based, col is 1-based (byte index).
  local a = vim.fn.getpos("v") -- Visual anchor (start).

  -- win_get_cursor returns { lnum, col } where:
  -- lnum is 1-based, col is 0-based (byte index).
  local c = vim.api.nvim_win_get_cursor(0) -- Visual cursor (end).

  -- Start position (from anchor).
  local srow = a[2]        -- 1-based line
  local scol_1based = a[3] -- 1-based col

  -- End position (from cursor).
  local erow = c[1]        -- 1-based line
  local ecol_0based = c[2] -- 0-based col

  -- Convert anchor col to 0-based.
  local scol = scol_1based - 1

  -- End col is already 0-based.
  local ecol = ecol_0based

  -- Normalize selection direction so (srow,scol) <= (erow,ecol).
  if erow < srow or (erow == srow and ecol < scol) then
    srow, erow = erow, srow
    scol, ecol = ecol, scol
  end

  -- Convert lines to 0-based for nvim_buf_set_text.
  local srow0 = srow - 1
  local erow0 = erow - 1

  -- Determine the exclusive end column for nvim_buf_set_text.
  -- For characterwise Visual selection, the cursor is *on* the last selected char,
  -- so the exclusive end is ecol + 1.
  local end_col_exclusive = ecol + 1

  -- Special case: linewise Visual selection ("V").
  if vmode == "V" then
    -- For linewise selection, we surround whole lines:
    -- Start at column 0 of the first line.
    scol = 0

    -- End at the end of the last line (exclusive = line length).
    local last_line = vim.api.nvim_buf_get_lines(bufnr, erow0, erow0 + 1, true)[1] or ""
    end_col_exclusive = #last_line
  end

  -- Insert RIGHT delimiter first so start indices are not shifted.
  vim.api.nvim_buf_set_text(
    bufnr,             -- buffer
    erow0,             -- end row (0-based)
    end_col_exclusive, -- end col (exclusive)
    erow0,             -- same position (insertion)
    end_col_exclusive, -- same position (insertion)
    { right }          -- text to insert
  )

  -- Insert LEFT delimiter at the start.
  vim.api.nvim_buf_set_text(
    bufnr,     -- buffer
    srow0,     -- start row (0-based)
    scol,      -- start col (0-based)
    srow0,     -- same position (insertion)
    scol,      -- same position (insertion)
    { left }   -- text to insert
  )

  -- Optional quality-of-life: reselect the original region (now surrounded).
  -- This makes repeated operations nicer.
  vim.cmd("normal! gv")
end

return M

