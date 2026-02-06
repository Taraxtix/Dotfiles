return {
  "stevearc/conform.nvim",

  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      },

      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            local lines = vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)
            for _, line in ipairs(lines) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
            return false
          end,
        },

        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diags = vim.diagnostic.get(ctx.buf)
            local md = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
                or d.source == "markdownlint-cli2"
                or d.source == "markdownlint_cli2"
            end, diags)
            return #md > 0
          end,
        },
      },
    })
  end,
}

