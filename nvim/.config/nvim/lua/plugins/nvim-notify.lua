return {
  "rcarriga/nvim-notify",

  event = "VimEnter",

  config = function()
    local notify = require("notify")

    notify.setup({
      -- Animation style: "fade", "slide", "fade_in_slide_out", "static".
      stages = "fade_in_slide_out",

      timeout = 3000,

      minimum_width = 30,

      -- Render style: "default", "minimal", "simple", "compact", "wrapped-compact".
      render = "default",

      -- Background color of the notification window.
      -- "Normal" makes it match the colorscheme.
      background_colour = "Normal",

      -- Top-down vs bottom-up stacking.
      top_down = true,
    })

    vim.notify = notify
  end,
}
