return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 300,
    icons = {
      mappings = false,
      rules = false,
    },
    spec = {
      { "<leader>c", group = "Code" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>n", group = "Notes" },
      { "<leader>t", group = "Toggle" },
    },
  },
}
