vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.autoformat = false
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.cursorline = false

-- Configuration of indent; Expand tab to space, Indent size, Auto indentation
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- Enable mouse support (i.e. resizing split window)
vim.opt.mouse = "a"

-- Show mode, can disable if already shown on status line
vim.opt.showmode = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"

-- Which-key popup delay
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Show whitespace characters
vim.opt.list = false

-- Live preview substitutions
vim.opt.inccommand = "split"

-- Syntax Colour
vim.cmd("syntax on")

-- Sync clipboard between OS and nvim
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
