function _G.nvim_config_diagnostics()
  local count = vim.diagnostic.count(0)
  local errors = count[vim.diagnostic.severity.ERROR] or 0
  local warnings = count[vim.diagnostic.severity.WARN] or 0

  if errors == 0 and warnings == 0 then
    return ""
  end

  return string.format(" E:%d W:%d", errors, warnings)
end

vim.opt.laststatus = 3
vim.opt.statusline = table.concat({
  " %f",
  " %h%m%r",
  "%=",
  "%{v:lua.nvim_config_diagnostics()}",
  " %y",
  " %l:%c",
  " %p%% ",
})
