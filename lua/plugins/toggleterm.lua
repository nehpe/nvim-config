return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    {
      "<C-\\>",
      mode = { "n", "t" },
      desc = "Toggle terminal",
    },
  },
  opts = {
    open_mapping = [[<C-\>]],
    direction = "float",
    float_opts = {
      border = "rounded",
    },
  },
}
