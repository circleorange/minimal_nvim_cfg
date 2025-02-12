return {
	-- Highlight, Edit, and Navigate code
	-- :TSModuleInfo		- Module state for each filetype
	-- :TSInstall <lang>	- Install parser
	-- :TSInstallInfo		- List available parsers
	-- :TSUpdate			- Update all parsers
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"bash", "c", "lua", "luadoc", "markdown", "html", "vim", "java", "go", "python",
		},
		auto_install = false,
		-- Ignore parsers. Example: "all", "javascript"
		ignore_install = {},
		highlight = {
			enable = true,
			-- Some langs require different indentations rules
			additional_vim_regex_highlighting = { "ruby" },
			-- Disable languages. Example: "c", "rust"
			disable = {},
		},
		indent = { enable = true, disable = { "ruby" } },
	},
	config = function(_, opts)
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup(opts)
	end,
}
