require("config.options")
require("config.keymaps")

-- lazy.vim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Configuration of plugins
-- Check status using `:Lazy` and Update plugins using `:Lazy update`
require("lazy").setup({

	-- General Plugins
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.cmp"),
	require("plugins.treesitter"),
	require("plugins.todo_comments"),
	require("plugins.mini"),
	require("plugins.which_key"),
	require("plugins.flash"),
	require("plugins.lint"),
	require("plugins.trouble"),
	require("plugins.theme"),
	require("plugins.autopairs"),
	require("plugins.file_explorer"),

	-- Language Plugins and Configurations
	require("plugins.lang.java"),
	require("plugins.lang.rust"),
	require("plugins.lang.go"),

	-- Other Plugins
	-- Auto format of tabstop and shiftwidth
	{ "tpope/vim-sleuth" },
	{ "Bilal2453/luvit-meta", lazy = true },
	{ "folke/lazydev.nvim", 
		ft = "lua", 
		opts = { library = {{ path = "luvit-meta/library", words = { "vim%.uv" }}},
	}},
})
