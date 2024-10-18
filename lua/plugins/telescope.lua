return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		{ 
			"nvim-lua/plenary.nvim",
		}, 
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			-- Ran when plugin installed or updated, not when nvim started
			build = "make",
			-- Determine whether plugin is installed/ loaded
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		}, 
		{
			"nvim-telescope/telescope-ui-select.nvim",
		}, 
		{
			"nvim-tree/nvim-web-devicons",
			enabled = vim.g.have_nerd_font,
		},
	},
	config = function()
		require("telescope").setup({
			-- Configurations go here: mappings, updates - See: `:help telescope.setup()`
			defaults = { 
				file_ignore_patterns = {
					"node_modules/", "target/", "%.class", "%.jar", "%.o", "%.out", "%.bin"
				}
			},
			-- pickers  = {},
			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown() },
			},
		})
		-- Enable Telescope extensions, if installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		local map = vim.keymap.set
		local builtin = require("telescope.builtin")

		map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		map("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		map("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		-- Override default behaviour
		map("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzy search in current buffer" })

		-- Pass additional options
		map("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live grep in open files",
			})
		end, { desc = "[S]earch [/] in open files" })

		-- Shortcut to Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({
				cwd = vim.fn.stdpath("config"),
			})
		end, { desc = "[S]earch [N]eovim files" })
	end,
}

