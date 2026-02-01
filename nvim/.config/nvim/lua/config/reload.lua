-- lua/config/reload.lua
-- Provides a reload function to re-source config without restarting Neovim.

-- Small helper: safely notify with a fallback (works with nvim-notify too).
local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Config" })
end

-- Unload all Lua modules under a given prefix from package.loaded.
-- This ensures the next require() loads the updated code from disk.
local function unload_prefix(prefix)
  -- Iterate all loaded Lua modules.
  for name, _ in pairs(package.loaded) do
    -- If the module name begins with the prefix, unload it.
    if name:sub(1, #prefix) == prefix then
      package.loaded[name] = nil
    end
  end
end

-- Public reload function.
local function reload_config()
  -- Save all modified buffers before reloading (optional, but nice).
  -- pcall prevents errors if something goes wrong.
  pcall(vim.cmd, "wall")

  -- Unload your own config modules so edits are picked up.
  unload_prefix("config")
  unload_prefix("plugins")

  -- Re-run your core modules in a known good order.
  -- (These are “safe” to reload repeatedly.)
  pcall(require, "config.options")
  pcall(require, "config.keymaps")
  pcall(require, "config.autocmds")

  -- Ask lazy.nvim to re-read specs and apply changes.
  -- :Lazy sync is heavier; :Lazy reload + :Lazy load is usually enough.
  -- We call the Lua API to avoid depending on user commands.
  local ok, lazy = pcall(require, "lazy")
  if ok and type(lazy.reload) == "function" then
    pcall(lazy.reload)
  else
    pcall(vim.cmd, "Lazy reload")
  end

  -- Tell the user it worked.
  notify("Reloaded Neovim config", vim.log.levels.INFO)
end

-- Return module table.
return {
  reload_config = reload_config,
}
