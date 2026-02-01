-- Alias for creating augroups.
local augroup = vim.api.nvim_create_augroup
-- Alias for creating autocmds.
local autocmd = vim.api.nvim_create_autocmd

-- Create a group for our autocmds so they can be managed as one unit.
local group = augroup("ConfigAutocmds", { clear = true })

-- Highlight text briefly after yanking (visual feedback).
autocmd("TextYankPost", {
	group = group,
	desc = "Highlight when yanking text",
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

-- Auto-reload Neovim config when saving Lua files in your config directory.
autocmd("BufWritePost", {
	group = group,
	desc = "Auto-reload config on save",
	pattern = vim.fn.stdpath("config") .. "/lua/**/*.lua",
	callback = function()
		require("config.reload").reload_config()
	end,
})

-- Also reload when saving init.lua.
autocmd("BufWritePost", {
	group = group,
	desc = "Auto-reload init.lua on save",
	pattern = vim.fn.stdpath("config") .. "/init.lua",
	callback = function()
		require("config.reload").reload_config()
	end,
})
