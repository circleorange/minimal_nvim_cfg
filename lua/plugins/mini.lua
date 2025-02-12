return {
	-- Collection of small independent plugins
	"echasnovski/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects
		-- va)  - [V]isually select [A]round [)]Paren
		-- yinq - [Y]ank [I]nside [N]ext [Q]uote
		-- ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({
			n_lines = 500,
		})

		-- Add/ Delete/ Replace surroundings
		-- saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- sd'   - [S]urround [D]elete [']Quotes
		-- sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()

		-- Status Line
		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })
	end,
}

