return {
  "nvim-mini/mini.nvim",
  version = false,
  config = function()
    local pick = require("mini.pick")
    local extra = require("mini.extra")
    local starter = require("mini.starter")

    pick.setup()
    vim.ui.select = pick.ui_select

    starter.setup({
      header = "NEOVIM",
      footer = "",
      items = {
        {
          name = "Find files",
          action = "lua require('mini.pick').builtin.files()",
          section = "Find",
        },
        {
          name = "Search text",
          action = "lua require('mini.pick').builtin.grep_live()",
          section = "Find",
        },
        starter.sections.recent_files(5, false, true),
        starter.sections.builtin_actions(),
        {
          name = "Plugin manager",
          action = "Lazy",
          section = "Actions",
        },
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.padding(3, 2),
        starter.gen_hook.aligning("center", "center"),
      },
    })

    local map = vim.keymap.set

    map("n", "<leader>ff", pick.builtin.files, { desc = "Find files" })
    map("n", "<leader>fg", pick.builtin.grep_live, { desc = "Search text" })
    map("n", "<leader>fb", pick.builtin.buffers, { desc = "Find buffers" })
    map("n", "<leader>fh", pick.builtin.help, { desc = "Find help" })
    map("n", "<leader>fr", extra.pickers.oldfiles, { desc = "Recent files" })
    map("n", "<leader>fk", extra.pickers.keymaps, { desc = "Find keymaps" })
    map("n", "<leader>f.", pick.builtin.resume, { desc = "Resume picker" })
  end,
}
