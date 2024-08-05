return {
	-- Highlight, Edit, and Navigate code
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"lua",
			"luadoc",
			"markdown",
			"html",
			"vim",
			"java",
			"go",
			"python",
		},
		auto_install = true,
		highlight = {
			enable = true,
			-- Some langs require different indentations rules
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = {
			enable = true,
			disable = { "ruby" },
		},
	},
	config = function(_, opts)
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup(opts)
	end,
}
