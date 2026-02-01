return {
  "saghen/blink.cmp",

  event = "InsertEnter",
  version = "1.*",

  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },

  config = function()
    local blink = require("blink.cmp")

    blink.setup({
      fuzzy = {
        implementation = "prefer_rust",
      },

      completion = {
        menu = {
          auto_show = false,
          draw = {
            treesitter = { "lsp" },
          },
        },

        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },

        ghost_text = {
          enabled = true,
        },
      },

      signature = {
        enabled = true,
      },

      -- Keymap configuration for insert-mode completion control
      keymap = {
        -- We define explicit mappings rather than relying on presets,
        -- to match your exact behavior requirements.

        -- Force the completion popup open (your existing behavior)
        ["<C-Space>"] = { "show", "fallback" },

        -- Accept completion when something is available,
        -- else move through snippet placeholders,
        -- else fallback to a literal Tab.
        ["<Tab>"] = { "accept", "snippet_forward", "fallback" },

        -- Snippet backward jump, else fallback
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        -- If completion UI is visible: close it; otherwise keep normal <Esc>.
        ["<Esc>"] = { "hide", "fallback" },

        -- Scroll docs (if you enable docs popup later)
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },

      sources = {
        default = { "codeium", "lsp", "snippets", "path", "buffer" },
        providers = {
          codeium = {
            name = "Codeium",
            module = "codeium.blink",
            async = true,
          },
        }
      },

      -- Tell blink.cmp to use LuaSnip as the snippet engine
      snippets = {
        -- Use luasnip for snippet expansion
        preset = "luasnip",
      },
    })

    -- Make ghost text look “dimmed” (theme-independent default).
    -- If your theme defines BlinkCmpGhostText already, it will override this.
    vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { link = "Comment" })
  end,
}
