-- Convenience local for defining mappings.
local map = vim.keymap.set

-- Default mapping options: non-recursive and silent.
local opts = { noremap = true, silent = true }

-- Leader keys (Space is a practical choice for your schema).
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

------ MUSCLE MEMORY KEYBINDS ------

-- CTRL+S to save
map('n', '<C-s>', '<cmd>write<CR>', vim.tbl_extend('force', opts, { desc = 'Save file' }))
map('i', '<C-s>', '<Esc><cmd>write<CR>', vim.tbl_extend('force', opts, { desc = 'Save file' }))
map('v', '<C-s>', '<Esc><cmd>write<CR>', vim.tbl_extend('force', opts, { desc = 'Save file' }))

-- Ctrl+/ clears search highlights.
map(
  'n',
  '<C-/>',
  '<cmd>nohlsearch<CR>',
  vim.tbl_extend('force', opts, { desc = 'Clear search highlight' })
)

-- Make Y behave like D/C (yank to end of line).
map('n', 'Y', 'y$', vim.tbl_extend('force', opts, { desc = 'Yank to end of line' }))

-- Small helper: open a terminal in a horizontal split using built-in :terminal.
local function open_terminal_split()
  vim.cmd('split')
  vim.cmd('resize 30')
  vim.cmd('terminal')
  vim.cmd('startinsert')
end

-- Ctrl+` opens a terminal split.
map(
  'n',
  '<C-`>',
  open_terminal_split,
  vim.tbl_extend('force', opts, { desc = 'Open terminal split' })
)
-- Ctrl+` in terminal closes the split.
map(
  't',
  '<C-`>',
  '<C-\\><C-n><cmd>close<CR>',
  vim.tbl_extend('force', opts, { desc = 'Close terminal split' })
)

------ LEADER BASED KEYBINDS ------

---- UI ----
--- Toggle ---
-- Toggle word wrap --
map('n', '<leader>vtw', function()
---@diagnostic disable-next-line: undefined-field
  vim.opt.wrap = not vim.opt.wrap:get()
end, { desc = 'View: toggle word wrap' })

---- Show ----
-- Keys --
map('n', '<leader>sk', function()
  require('telescope.builtin').keymaps()
end, { desc = 'Show keymaps' })

-- Scratch buffer --
map('n', "<leader>ss", "<cmd>edit ~/QuickFiles/scratch.txt<CR>", { desc = 'Show scratch buffer' })

--- Code ----
-- Diagnostics --
map('n', '<leader>cd', function()
  require('config.telescope_code').diagnostics()
end, { desc = 'Code diagnostics' })

--- Change ---
-- Code Action --
map('n', '<leader>cca', function()
  require('tiny-code-action').code_action()
end, { desc = 'Code: Code actions' })

-- Rename --
map('n', '<leader>ccr', vim.lsp.buf.rename, { desc = 'Code: Rename Symbol' })

-- Format Buffer --
map('n', '<leader>ccf', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Code: change: format' })

--- Go to ---
-- Implementation(s) --
map('n', '<leader>cgi', function()
  require('telescope.builtin').lsp_implementations()
end, { desc = 'Go to Implementations' })

-- Declaration(s) --
map('n', '<leader>cgd', function()
  vim.lsp.buf.declaration()
end, { desc = 'Go to Declarations' })

-- Definition(s) --
map('n', '<leader>cgf', function()
  require('telescope.builtin').lsp_definitions()
end, { desc = 'Go to Definitions' })

-- Reference(s) --
map('n', '<leader>cgr', function()
  require('telescope.builtin').lsp_references()
end, { desc = 'Go to References' })

-- Type Definition(s) --
map('n', '<leader>cgt', function()
  require('telescope.builtin').lsp_type_definitions()
end, { desc = 'Go to Type Definitions' })

---- Find ----
-- Files --
map('n', '<leader>ff', function()
  require('telescope.builtin').find_files()
end, { desc = 'Find: files' })

-- Buffers --
map('n', '<leader>fb', function()
  require('telescope.builtin').buffers()
end, { desc = 'Find: buffers' })

-- Live grep --
map('n', '<leader>fg', function()
  require('telescope.builtin').live_grep()
end, { desc = 'Live Grep' })

-- Projects --
map('n', "<leader>fp", function ()
  require('telescope').extensions.project.project()
end, {desc = 'Find Projects'})

---- Editor/Environment ----
--- Change ---

-- Working Directory --
map('n', '<leader>ecwd', function()
  require('config.change_working_directory').cwd()
end, { desc = 'Editor: change working directory' })

--- Edit ---
local projects_path = require("config.edit_project").path
-- Projects --
map('n', "<leader>eep", "<cmd>edit " .. projects_path .. "<CR>", {desc = "Edit project file"})

---- MISC ----
-- Show top level which-key
map('n', '<leader>?', function()
  require('which-key').show({ mode = 'n' })
end, { desc = 'Which-Key: Show top-level' })

map('n', '<leader>bf', function()
  require('telescope').extensions.file_browser.file_browser()
end, { desc = 'Buffers' })

------ OTHER KEYBINDS ------

-- Visual-surround mappings: pressing the delimiter wraps the selection.
local s = require('config.surround')

-- Map ( in Visual mode to surround with parentheses.
map('x', '(', function()
  s.surround_visual('(', ')')
end, { desc = 'Surround selection with ()' })

-- Map " in Visual mode to surround with double quotes.
map('x', [["]], function()
  s.surround_visual([["]], [["]])
end, { desc = 'Surround selection with ""' })

-- Map [ in Visual mode to surround with brackets.
map('x', '[', function()
  s.surround_visual('[', ']')
end, { desc = 'Surround selection with []' })

-- Map ' in Visual mode to surround with single quotes.
map('x', "'", function()
  s.surround_visual("'", "'")
end, { desc = "Surround selection with ''" })

-- Map ` in Visual mode to surround with backticks.
map('x', '`', function()
  s.surround_visual('`', '`')
end, { desc = 'Surround selection with ``' })
