return {
  'neovim/nvim-lspconfig',

  event = { 'BufReadPre', 'BufNewFile' },

  dependencies = {
    'williamboman/mason.nvim', -- Installs external LSP servers, etc.
    'williamboman/mason-lspconfig.nvim', -- Bridges Mason <-> server names.
    'saghen/blink.cmp', -- Adds completion capabilities for LSP.
  },

  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP: buffer-local keymaps',

      -- Callback receives event data (includes buffer id).
      callback = function(event)
        local map = vim.keymap.set

        -- Buffer-local mapping options.
        local opts = { buffer = event.buf, silent = true }

        -- In normal mode K shows hover documentation.
        map(
          'n',
          'K',
          vim.lsp.buf.hover,
          vim.tbl_extend('force', opts, {
            desc = 'LSP: hover documentation',
          })
        )

        -- Enable builtin inlay hints for this buffer if supported by the attached LSP client.
        -- Neovim native inlay hints exist since 0.10 and are the "don’t reinvent" solution.
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/inlayHint') and vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
        end

        -- Format Rust files on save using rust-analyzer / rustfmt
        if client ~= nil and client.name == 'rust_analyzer' then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = event.buf,
            callback = function()
              vim.lsp.buf.format({
                async = false,
              })
            end,
          })
        end
      end,
    })

    -- Build the base client capabilities (what Neovim supports).
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Extend capabilities to advertise nvim-cmp completion support to servers.
    capabilities = require('blink-cmp').get_lsp_capabilities(capabilities)

    vim.lsp.config('lua_ls', {
      capabilities = capabilities,

      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },

          diagnostics = {
            globals = { 'vim' },
          },

          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          },

          -- Disable telemetry.
          telemetry = {
            enable = false,
          },
        },
      },
    })
    vim.lsp.enable('lua_ls')

    vim.lsp.config('rust-analyzer', {
      capabilities = capabilities,

      settings = {
        procMacro = { enable = true },
      },

      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = { enable = true },
      },

      inlayHints = {
        bindingModeHints = { enable = true },
        closureReturnTypeHints = { enable = 'with_block' },
        lifetimeElisionHints = {
          enable = 'always',
          useParameterNames = true,
        },
        typeHints = { enable = true },
        parameterHints = { enable = true },
      },

      diagnostics = {
        enable = true,
        experimental = { enable = true },
      },

      checkOnSave = {
        command = 'clippy',
      },
    })
    vim.lsp.enable('rust_analyzer')

    vim.lsp.config('marksman', {
      capabilities = capabilities,
    })
    vim.lsp.enable('marksman')
  end,
}
