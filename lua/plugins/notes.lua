return {
  "nehpe/notes.nvim",
  dependencies = {
    "nvim-mini/mini.nvim",
  },
  opts = {},
  config = function(_, opts)
    local notes = require("notes")
    notes.setup(opts)

    local map = vim.keymap.set
    map("n", "<leader>nd", notes.today, { desc = "Today's note" })
    map("n", "<leader>nf", notes.find, { desc = "Find notes" })
    map("n", "<leader>ns", notes.search, { desc = "Search notes" })
    map("n", "<leader>nt", notes.topics, { desc = "Find topics" })
    map("n", "<leader>no", notes.topic, { desc = "Open topic from line" })
    map("n", "<leader>nc", notes.carry, { desc = "Carry tasks forward" })
    map("n", "<leader>nx", notes.cycle_task, { desc = "Cycle task state" })
  end,
}
