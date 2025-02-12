return {
	"nvim-telescope/telescope-file-browser.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup {
			extensions = {
				file_browser = {
					theme = "ivy",
					-- Disables netrw and uses telescope-file-browser instead
					hijack_netrw = true,
					mappings = {
						["i"] = {
							-- Custom insert mode mappings
							-- Example: ["<C-h>"] = require("telescope").extensions.file_browser.actions.goto_home_dir,
						},
						["n"] = {
							-- Custom normal mode mappings
							-- Example: ["h"] = require("telescope").extensions.file_browser.actions.goto_parent_dir,
						},
					},
				},
			},
		}
		telescope.load_extension("file_browser")

		-- Keymaps

		-- Open file_browser
		vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>", { noremap = true, silent = true })

		-- Open file_browser with the path of the current buffer
		vim.keymap.set("n", "<space>fB", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true, silent = true })
	end,
}

