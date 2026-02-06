return {
  "mfussenegger/nvim-lint",

  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      markdown = { "markdownlint-cli2" },
      ["markdown.mdx"] = { "markdownlint-cli2" },
    }

    local group = vim.api.nvim_create_augroup("ConfigLint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = group,
      callback = function()
        pcall(lint.try_lint)
      end,
    })
  end,
}

