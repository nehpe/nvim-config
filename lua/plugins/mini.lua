return {
  "nvim-mini/mini.nvim",
  version = false,
  config = function()
    local pick = require("mini.pick")
    local extra = require("mini.extra")

    pick.setup()
    vim.ui.select = pick.ui_select

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
