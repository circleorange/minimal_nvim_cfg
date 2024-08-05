return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		integrations = {
			cmp = true,
			flash = true,
			grug_far = true,
			lsp_trouble = true,
			mason = true,
			markdown = true,
			mini = true,
			native_lsp = {
				enabled = true,
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			navic = { enabled = true, custom_bg = "lualine" },
			telescope = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
		},
	},
}
