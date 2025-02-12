return {
	"mfussenegger/nvim-lint",
	opts = {
		-- Event to trigger linters
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		linters_by_ft = {
			["*"] = { "global linter" },
			-- fish = { "fish" },
			-- Use the "*" filetype to run linters on all filetypes.
			-- ['*'] = { 'global linter' },
			-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
			-- ['_'] = { 'fallback linter' },
			-- ["*"] = { "typos" },
		},
	},
	config = function(_, opts)
		vim.api.nvim_create_autocmd(opts.events, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
