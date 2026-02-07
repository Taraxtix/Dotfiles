-- Short alias for Neovim's option API.
local opt = vim.opt

-- Show absolute line number in the gutter.
opt.number = true

-- Show relative line numbers for fast jumps.
opt.relativenumber = true

-- Enable mouse support in all modes.
opt.mouse = 'a'

-- Use the system clipboard by default (Wayland: wl-clipboard via Neovim provider).
opt.clipboard = 'unnamedplus'

-- Use spaces instead of literal tab characters.
opt.expandtab = true

-- A <Tab> counts as 4 spaces when reading a file.
opt.tabstop = 2

-- Indentation level uses 4 spaces.
opt.shiftwidth = 2

-- Insert-mode <Tab> feels like 4 spaces.
opt.softtabstop = 2

-- Smart auto-indent.
opt.smartindent = true

-- Keep 8 lines visible above/below the cursor.
opt.scrolloff = 8

-- Keep 8 columns visible left/right of the cursor.
opt.sidescrolloff = 8

-- Live substitute preview in a split.
opt.inccommand = 'split'

-- Enable true colors (needed for modern colorschemes).
opt.termguicolors = true

-- Vertical splits open to the right.
opt.splitright = true

-- Horizontal splits open below.
opt.splitbelow = true

-- Faster CursorHold triggers and general responsiveness.
opt.updatetime = 250

-- Shorter timeout for multi-key mappings.
opt.timeoutlen = 400

-- Keep the sign column visible (prevents text shifting).
opt.signcolumn = 'yes'

-- Case-insensitive search unless uppercase appears.
opt.ignorecase = true
opt.smartcase = true

-- Show a guide column at 100 chars (adjust later).
opt.colorcolumn = '100'

-- Show certain invisible characters.
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Persist undo history across sessions.
opt.undofile = true

-- Store undo files in Neovim's state directory.
opt.undodir = vim.fn.stdpath('state') .. '/undo'

-- Prevent auto-inserting comment leaders on new lines.
opt.formatoptions:remove({ 'c', 'r', 'o' })

-- Keep command line height minimal.
opt.cmdheight = 1

-- Toggle word wrap.
opt.wrap = true

-- Don't break words when wrapping.
opt.linebreak = true

-- Indent wrapped lines to match the original line indentation.
opt.breakindent = true

-- Make wrapped lines visually continue instead of disappearing.
opt.showbreak = '↪ '

-- Makes folds, cursor and curdir part of the view
opt.viewoptions = { 'folds', 'cursor', 'curdir' }

-- Fold related options
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "1"
