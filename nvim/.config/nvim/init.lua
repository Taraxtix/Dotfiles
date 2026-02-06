-- Plain nvim configs --
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.reload")
-- require("config.diagnostics_inline").setup()

-- Plugin manager + plugins --
require("config.lazy")
