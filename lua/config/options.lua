local opt = vim.opt

opt.number = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.confirm = true
opt.termguicolors = true
opt.textwidth = 80
opt.list = true
opt.listchars = {
  tab = "> ",
  trail = ".",
  nbsp = "+",
  leadmultispace = "|   ",
}

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
