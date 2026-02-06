return {
  "folke/which-key.nvim",

  event = "VeryLazy",

  opts = {
    preset = "helix",
    win = {
      border = "rounded",
      padding = {1, 2},
    },

    layout = {
      width = { min=20, max=50 },
      spacing = 3,
    },

    delay = 150,

    plugins = {
      marks = true,
      registers = true,
      spelling =  { enabled = true, suggestions = 20 },
    },

    -- Change which-key popup scrolling keys.
    keys = {
      -- Scroll down in the which-key window.
      scroll_down = "<C-j>",

      -- Scroll up in the which-key window.
      scroll_up = "<C-k>",
    },
  },

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.add({
      { "<leader>h", group = "Harpoon" },
    })

    wk.add({
      { "<leader>g", group = "Git" },
      { "<leader>gc", group = "Conflicts" },
      { "<leader>gco" , desc = "Take ours" },
      { "<leader>gct" , desc = "Take theirs" },
      { "<leader>gcb" , desc = "Take both" },
      { "<leader>gcn" , desc = "Take none" },
      { "<leader>g]" , group = "Next.." },
      { "<leader>g]c" , desc = "Conflict" },
      { "<leader>g[" , group = "Previous.." },
      { "<leader>g[c" , desc = "Conflict" },
      { "<leader>gt" , group = "Toggle" },
      { "<leader>gtd" , desc = "Diff view" },
    })

    wk.add({ -- No group keybinds
      { "<leader>b", group = "Browse"},
      { "<leader>bf", desc = "Browse files" },
    })

    wk.add({
      { "<leader>v", group = "View" },
      { "<leader>vt", group = "Toggle" },
      { "<leader>vtw", desc = "Word wrap" },
    })

    wk.add({
      { "<leader>e", group = "Editor/Environment" },
      { "<leader>ec", group = "Change" },
      { "<leader>ecw", group = "Change Working..." },
      { "<leader>ecwd", desc = "Change Working Directory" },
      { "<leader>ee", group = "Edit" },
      { "<leader>eep", desc = "Projects file" },
    })

    wk.add({
      {"<leader>f", group = "Find"},
      { "<leader>ff", desc = "File"},
      { "<leader>fb", desc = "Buffer"},
      { "<leader>fg", desc = "Live Grep"},
      { "<leader>fp", desc = "Projects"},
    })

    wk.add({
      { "<leader>s", group = "Show"},
      { "<leader>sk", desc = "Keymaps"},

    })

    wk.add({
      {"<leader>c", group = "Code"},
      { "<leader>cd", desc = "Diagnostics"},
      { "<leader>cc", group = "Change"},
      { "<leader>cca", desc = "Code actions"},
      { "<leader>ccr", desc = "Rename symbol"},
      { "<leader>ccf", desc = "Format buffer"},
      { "<leader>cg", group = "Go to"},
      { "<leader>cgd", desc = "Declarations"},
      { "<leader>cgf", desc = "Definitions"},
      { "<leader>cgi", desc = "Implementations"},
      { "<leader>cgr", desc = "References"},
      { "<leader>cgt", desc = "Type Definitions"},
      { "<leader>cg[", desc = "Back (Jumplist)"},
      { "<leader>cg]", desc = "Forward (Jumplist)"},
    })

    -- ===== Built-in prefixes: documentation only (no new mappings) =====

    -- Normal-mode prefix docs
    wk.add({
      -- g-prefix (tons of built-ins / common mappings from plugins too)
      { "g", group = "Go to/Zone action" },
      { "gd", desc = "Go to definition (LSP)" },
      { "gD", desc = "Go to declaration (LSP)" },
      { "gi", desc = "Go to last insert position" },
      { "gv", desc = "Reselect last visual selection" },
      { "g~", desc = "Toggle case (operator: g~{motion})" },
      { "gu", desc = "Lowercase (operator: gu{motion})" },
      { "gU", desc = "Uppercase (operator: gU{motion})" },
      { "gq", desc = "Format text (operator: gq{motion})" },

      -- z-prefix (folds, view, spelling, etc.)
      { "z", group = "Fold/View" },
      { "za", desc = "Toggle fold" },
      { "zo", desc = "Open fold" },
      { "zc", desc = "Close fold" },
      { "zR", desc = "Open all folds" },
      { "zM", desc = "Close all folds" },
      { "zz", desc = "Center cursor line" },
      { "zt", desc = "Cursor line to top" },
      { "zb", desc = "Cursor line to bottom" },

      -- ] and [ prefixes (diagnostics, quickfix, etc. often hooked by plugins/LSP)
      { "]", group = "Next …" },
      { "][", desc = "Next unmatched bracket" }, -- built-in
      { "]]", desc = "Next section start (depends on filetype)" },
      { "]d", desc = "Next diagnostic (LSP)" },
      { "]q", desc = "Next quickfix item" },
      { "[", group = "Prev …" },
      { "[]", desc = "Prev unmatched bracket" }, -- built-in
      { "[[", desc = "Prev section start (depends on filetype)" },
      { "[d", desc = "Prev diagnostic (LSP)" },
      { "[q", desc = "Prev quickfix item" },

      -- Ctrl-w prefix (windows)
      { "<C-w>", group = "Windows" },
      { "<C-w>s", desc = "Split horizontally" },
      { "<C-w>v", desc = "Split vertically" },
      { "<C-w>q", desc = "Quit window" },
      { "<C-w>o", desc = "Only this window" },
      { "<C-w>w", desc = "Next window" },
      { "<C-w>W", desc = "Prev window" },
      { "<C-w>h", desc = "Go left" },
      { "<C-w>j", desc = "Go down" },
      { "<C-w>k", desc = "Go up" },
      { "<C-w>l", desc = "Go right" },
      { "<C-w>=", desc = "Equalize splits" },
      { "<C-w>+", desc = "Increase height" },
      { "<C-w>-", desc = "Decrease height" },
      { "<C-w>>", desc = "Increase width" },
      { "<C-w><", desc = "Decrease width" },
      }, { mode = "n" })

      -- Visual-mode prefix docs (operators and text-objects become relevant here)
      wk.add({
      { "a", group = "around text-object (a…)" },
      { "i", group = "inside text-object (i…)" },
      { "a'", desc = "around single quotes" },
      { 'a"', desc = 'around double quotes' },
      { "a`", desc = "around backticks" },
      { "ab", desc = "around parentheses (alias for a())" },
      { "aB", desc = "around braces (alias for a{})" },
      { "aw", desc = "around word (includes trailing space)" },
      { "aW", desc = "around WORD (space-delimited)" },
      { "ap", desc = "around paragraph" },

      { "i'", desc = "inside single quotes" },
      { 'i"', desc = 'inside double quotes' },
      { "i`", desc = "inside backticks" },
      { "ib", desc = "inside parentheses (alias for i())" },
      { "iB", desc = "inside braces (alias for i{})" },
      { "iw", desc = "inside word" },
      { "iW", desc = "inside WORD" },
      { "ip", desc = "inside paragraph" },
      }, { mode = "v" })

      wk.add({
        { "u", desc = "Undo last change" },
        { "<C-r>", desc = "Redo undone change" },
        { "U", desc = "Undo all changes on current line" },
        }, { mode = "n" })

  end,
}

