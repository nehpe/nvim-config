return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local signs = require("gitsigns")
      local map = function(keys, action, desc)
        vim.keymap.set("n", keys, action, {
          buffer = bufnr,
          desc = desc,
        })
      end

      map("]h", function()
        signs.nav_hunk("next")
      end, "Next hunk")
      map("[h", function()
        signs.nav_hunk("prev")
      end, "Previous hunk")
      map("<leader>gp", signs.preview_hunk, "Preview hunk")
      map("<leader>gs", signs.stage_hunk, "Stage hunk")
      map("<leader>gr", signs.reset_hunk, "Reset hunk")
      map("<leader>gb", signs.blame_line, "Blame line")
    end,
  },
}
