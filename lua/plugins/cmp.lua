return {
	"hrsh7th/nvim-cmp",
	version = false,
	event = "InsertEnter",
	dependencies = {
		{ -- Snippet engine and associated nvim-cmp source
			"L3MON4D3/LuaSnip",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {},
		},
		-- Remaining completion capabilities, they are split across multiple repos for maintenance
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		luasnip.config.setup({})
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = "menu,menuone,noinsert" },

			-- For mapping reason, read :help ins-completion
			mapping = cmp.mapping.preset.insert({
				-- Scroll documentation window
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				-- Accept ([y]es) the completion
				['<CR>'] = cmp.mapping.confirm({ select=true }),
				-- ["<C-y>"] = cmp.mapping.confirm({ select = true }),

				-- [n]ext item
				['<TAB>'] = cmp.mapping.select_next_item(),
				-- ["<C-n>"] = cmp.mapping.select_next_item(),

				-- [p]revious item
				['<S-TAB>'] = cmp.mapping.select_prev_item(),
				-- ["<C-p>"] = cmp.mapping.select_prev_item(),

				-- Manually trigger completion, should show automatically though
				["<C-Space>"] = cmp.mapping.complete({}),

				-- Move to snippet expansion
				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
				end, { "i", "s" }),

				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
				end, { "i", "s" }),
				-- See for more Luasnip keymaps: github.com/L3MON4D3/LuaSnip
			}),
			sources = {
				{name = "lazydev", group_index = 0},
				{name = "nvim_lsp"},
				{name = "luasnip"},
				{name = "path"},
			},
		})
	end,
}
