-- lua/config/diagnostics_inline.lua
-- Custom diagnostic renderer:
--  - Prefer inline EOL diagnostics (like many IDEs)
--  - If it would overflow the window width, render above the line instead
--  - If it still doesn't fit, wrap across multiple virtual lines
--  - virt_lines are attached to the buffer line, so folding that line hides them too

local M = {} -- Module table.

-- Create a dedicated namespace for our extmarks so we can clear/redraw easily.
local ns = vim.api.nvim_create_namespace("ConfigInlineDiagnostics")

-- Map diagnostic severity to standard highlight groups that colorschemes (rose-pine) style.
local severity_to_hl = {
  [vim.diagnostic.severity.ERROR] = "DiagnosticVirtualTextError", -- Red-ish (theme-controlled)
  [vim.diagnostic.severity.WARN]  = "DiagnosticVirtualTextWarn",  -- Yellow-ish
  [vim.diagnostic.severity.INFO]  = "DiagnosticVirtualTextInfo",  -- Blue-ish
  [vim.diagnostic.severity.HINT]  = "DiagnosticVirtualTextHint",  -- Gray/green-ish
}

-- Sanitize diagnostic message into a single line (inline text should not contain newlines).
local function normalize_message(msg)
  -- Convert nil to empty string.
  msg = msg or ""
  -- Replace newlines and carriage returns with spaces.
  msg = msg:gsub("\r", " "):gsub("\n", " ")
  -- Collapse multiple spaces into one.
  msg = msg:gsub("%s+", " ")
  -- Trim leading/trailing spaces.
  msg = msg:gsub("^%s+", ""):gsub("%s+$", "")
  -- Return the cleaned message.
  return msg
end

-- Split a message into multiple lines that each fit within max_width (display width).
local function wrap_message(msg, max_width)
  -- If max_width is too small, just return the whole message as one line.
  if max_width <= 5 then
    return { msg }
  end

  -- Prepare output lines.
  local out = {}

  -- Current line being built.
  local line = ""

  -- Iterate words so wrapping happens at word boundaries.
  for word in msg:gmatch("%S+") do
    -- Candidate if we append this word.
    local candidate = (line == "") and word or (line .. " " .. word)

    -- If candidate fits, keep building the current line.
    if vim.fn.strdisplaywidth(candidate) <= max_width then
      line = candidate
    else
      -- Otherwise, push the current line if non-empty.
      if line ~= "" then
        table.insert(out, line)
      end

      -- If a single word is longer than max_width, hard-split it.
      if vim.fn.strdisplaywidth(word) > max_width then
        local chunk = ""
        for i = 1, #word do
          local ch = word:sub(i, i)
          local cand = chunk .. ch
          if vim.fn.strdisplaywidth(cand) <= max_width then
            chunk = cand
          else
            table.insert(out, chunk)
            chunk = ch
          end
        end
        line = chunk
      else
        -- Start a new line with the current word.
        line = word
      end
    end
  end

  -- Flush last line if any.
  if line ~= "" then
    table.insert(out, line)
  end

  -- Return the wrapped lines.
  return out
end

-- Get an approximate window width for the buffer.
-- If the buffer is shown in multiple windows, we pick the current window if possible,
-- otherwise we pick the first window found, otherwise fallback to 80.
local function get_buf_win_width(bufnr)
  -- Get windows showing this buffer.
  local wins = vim.fn.win_findbuf(bufnr)

  -- If current window shows this buffer, use it.
  local cur = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_is_valid(cur) and vim.api.nvim_win_get_buf(cur) == bufnr then
    return vim.api.nvim_win_get_width(cur)
  end

  -- Otherwise, if there is any window showing the buffer, use the first.
  if type(wins) == "table" and #wins > 0 then
    return vim.api.nvim_win_get_width(wins[1])
  end

  -- Fallback if not visible.
  return 80
end

-- Clear all diagnostic extmarks for a buffer.
local function clear(bufnr)
  -- Clear our namespace in the whole buffer.
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

-- Render diagnostics for a buffer using our rules.
local function render(bufnr)
  -- Ignore invalid buffers.
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  -- Clear existing marks before re-drawing.
  clear(bufnr)

  -- Get the window width to decide overflow.
  local win_width = get_buf_win_width(bufnr)

  -- Avoid silly widths.
  if win_width < 20 then
    win_width = 20
  end

  -- Fetch diagnostics for this buffer.
  local diags = vim.diagnostic.get(bufnr)

  -- Render each diagnostic.
  for _, d in ipairs(diags) do
    -- Normalize the diagnostic message for inline rendering.
    local msg = normalize_message(d.message)

    -- Skip empty messages.
    if msg ~= "" then
      -- Determine highlight group from severity.
      local hl = severity_to_hl[d.severity] or "DiagnosticVirtualTextInfo"

      -- Get the current line text to compute how much space is left at EOL.
      local line = vim.api.nvim_buf_get_lines(bufnr, d.lnum, d.lnum + 1, true)[1] or ""

      -- Display width of the line as shown (tabs expand, etc.).
      local line_width = vim.fn.strdisplaywidth(line)

      -- We add a small prefix so diagnostics are visually separated.
      local prefix = " 󰌶 " -- icon + spacing (font-dependent; safe if missing)
      local inline_text = prefix .. msg

      -- Available space on the right side of the line in the current window.
      -- Subtract 1 to avoid touching the right edge.
      local available = win_width - line_width - 1

      -- If it fits inline, show it at EOL as virtual text.
      if vim.fn.strdisplaywidth(inline_text) <= available and available > 10 then
        -- Place virtual text at end of line.
        vim.api.nvim_buf_set_extmark(bufnr, ns, d.lnum, -1, {
          -- virt_text is a list of {text, highlight}.
          virt_text = { { inline_text, hl } },
          -- Place the text at the end-of-line (EOL).
          virt_text_pos = "eol",
          -- Keep it aligned with the line it belongs to.
          hl_mode = "combine",
        })
      else
        -- Otherwise, render above the line as virtual lines.
        -- This satisfies your "show it on top instead of to the right".
        local max_width = win_width - 2 -- leave small padding

        -- Wrap the message to fit within max_width.
        local wrapped = wrap_message(prefix .. msg, max_width)

        -- Convert wrapped lines into virt_lines format.
        local virt_lines = {}
        for _, wline in ipairs(wrapped) do
          -- Each virt_lines entry is a "screen line" made of chunks.
          table.insert(virt_lines, { { wline, hl } })
        end

        -- Place virt_lines above the diagnostic line.
        vim.api.nvim_buf_set_extmark(bufnr, ns, d.lnum, 0, {
          -- virt_lines displays extra lines; these are naturally hidden when the line is folded.
          virt_lines = virt_lines,
          -- Put the virtual lines above the real line.
          virt_lines_above = true,
          -- Combine highlight with existing.
          hl_mode = "combine",
        })
      end
    end
  end
end

-- Public setup: configure vim.diagnostic + install redraw hooks.
function M.setup()
  -- Disable Neovim's own virtual_text / virtual_lines so we fully control rendering.
  vim.diagnostic.config({
    -- We render inline ourselves.
    virtual_text = false,
    -- We render "on top" ourselves.
    virtual_lines = false,
    -- Keep underline/signs if you want (good for visibility).
    underline = true,
    signs = true,
    -- Update diagnostics less aggressively while typing (optional).
    update_in_insert = false,
    -- Keep floating diagnostics available (e.g., on hover) if you want later.
    float = {
      border = "rounded",
      source = "if_many",
    },
  })

  -- Redraw diagnostics when diagnostics change.
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    -- Describe for debugging.
    desc = "Redraw inline diagnostics on changes",
    -- Callback gives us the buffer in args.buf.
    callback = function(args)
      render(args.buf)
    end,
  })

  -- Redraw when entering a buffer window (needed on first open).
  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
    desc = "Redraw inline diagnostics on buffer enter",
    callback = function(args)
      render(args.buf)
    end,
  })

  -- Redraw on resize because our wrap/overflow decisions depend on window width.
  vim.api.nvim_create_autocmd("VimResized", {
    desc = "Redraw inline diagnostics on resize",
    callback = function()
      -- Redraw for the current buffer (cheap enough).
      render(vim.api.nvim_get_current_buf())
    end,
  })
end

return M
