local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  local cmd = {
    "git",
    "clone",
    "--filter=blob:none", -- Avoid downloading file blobs until needed.
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }

  local out = vim.fn.system(cmd)

  -- If the command failed, show the error and exit.
  if vim.v.shell_error ~= 0 then
    -- Print an error message to the user.
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "MoreMsg" },
    }, true, {})

    -- Wait for a keypress so the user can read the error.
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Prepend lazy.nvim to runtimepath so Neovim can require it.
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with plugin imports.
require("lazy").setup(
  { { import = "plugins" } },
  {
    -- Keep a lockfile for reproducible versions.
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",

    -- Enable periodic update checking (can be disabled later).
    checker = { enabled = true },

    -- Auto-detect changes in config files (no popup notifications).
    change_detection = { notify = false },

    -- Runtimepath optimizations (disable unused builtin plugins).
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip", -- Builtin gzip plugin.
          "tarPlugin", -- Builtin tar plugin.
          "tohtml", -- Builtin tohtml plugin.
          "tutor", -- Builtin tutor plugin.
          "zipPlugin", -- Builtin zip plugin.
        },
      },
    },
  }
)
