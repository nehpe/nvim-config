vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("MarkdownOptions", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.textwidth = 0
    vim.opt_local.wrapmargin = 0
    vim.opt_local.formatoptions:remove({ "t", "c" })
  end,
})

vim.keymap.set("n", "<leader>ts", function()
  vim.wo.spell = not vim.wo.spell
  vim.notify("Spell check " .. (vim.wo.spell and "on" or "off"))
end, { desc = "Toggle spell check" })
