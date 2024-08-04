vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.autoformat = false
vim.g.have_nerd_font  = true

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wrap = true
vim.opt.scrolloff = 10
vim.opt.cursorline = false

-- Configuration of indent; Expand tab to space, Indent size, Auto indentation
vim.opt.expandtab = false 
vim.opt.shiftwidth = 4 
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- Enable mouse support (i.e. resizing split window)
vim.opt.mouse = 'a'

-- Show mode, can disable if already shown on status line
vim.opt.showmode = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'

-- Which-key popup delay
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Show whitespace characters
vim.opt.list = false

-- Live preview substitutions
vim.opt.inccommand = 'split'

-- Syntax Colour
vim.cmd('syntax on')

-- Sync clipboard between OS and nvim
vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)

local map = vim.keymap.set
local opts = { 
  noremap = true, 
  silent = true,
}

-- Exit insert mode
map('i', 'jj', '<Esc>', opts)
map('n', '<Esc>', '<cmd>nohlsearch<CR>', opts)

map('n', '<leader>q', vim.diagnostic.setloclist, {desc='Open Diagnostic [Q]uick fix list'})
map('n', '<Esc><Esc>', '<C-\\><C-n>', {desc='Exit Terminal mode'})
map('n', '<C-h>', '<C-w><C-h>', {desc='Move focus to the left window'})
map('n', '<C-l>', '<C-w><C-l>', {desc='Move focus to the right window'})
map('n', '<C-j>', '<C-w><C-j>', {desc='Move focus to the lower window'})
map('n', '<C-k>', '<C-w><C-k>', {desc='Move focus to the upper window'})

-- Telescope Plugin
map('n', '<leader>ff', ':Telescope find_files<CR>', opts)
map('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
map('n', '<leader>fb', ':Telescope buffers<CR>', opts)
map('n', '<leader>fh', ':Telescope help_tags<CR>', opts)
map('n', '<leader>sg', ':Telescope live_grep<CR>', opts)

-- Use lazy.vim plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system {
		'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath 
	}
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Configuration of plugins
-- Check status using `:Lazy` and Update plugins using `:Lazy update`
require('lazy').setup({
	-- Auto format of tabstop and shiftwidth
	'tpope/vim-sleuth',
	{
		'folke/which-key.nvim', event = 'VimEnter',
		config = function()
			require('which-key').setup()
			require('which-key').add {
				{'<leader>c', group = '[C]ode'},
				{'<leader>d', group = '[D]ocument'},
				{'<leader>r', group = '[R]ename'},
				{'<leader>s', group = '[S]earch'},
				{'<leader>w', group = '[W]orkspace'},
				{'<leader>t', group = '[T]oggle'},
			}
		end,
	}, {
		-- Fuzzy Finder
		'nvim-telescope/telescope.nvim', event = 'VimEnter', branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim', 
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				-- Ran when plugin installed or updated, not when nvim started
				build = 'make', 
				-- Determine whether plugin is installed/ loaded
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			}, {
				'nvim-telescope/telescope-ui-select.nvim'
			}, {
				'nvim-tree/nvim-web-devicons',
				enabled = vim.g.have_nerd_font
			},
		},
		config = function()
			require('telescope').setup {
				-- Configurations go here: mappings, updates - See: `:help telescope.setup()`
				-- defaults = { mappings = {} },
				-- pickers  = {},
				extensions = {
					['ui-select'] = { require('telescope.themes').get_dropdown() }
				}
			}
			-- Enable Telescope extensions, if installed
			pcall(require('telescope').load_extension, 'fzf')
			pcall(require('telescope').load_extension, 'ui-select')

			local builtin = require('telescope.builtin')

			map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
			map('n', '<leader>sk', builtin.keymaps, {desc='[S]earch [K]eymaps'})
			map('n', '<leader>sf', builtin.find_files, {desc='[S]earch [F]iles'})
			map('n', '<leader>ss', builtin.builtin, {desc='[S]earch [S]elect Telescope'})
			map('n', '<leader>sw', builtin.grep_string, {desc='[S]earch current [W]ord'})
			map('n', '<leader>sg', builtin.live_grep, {desc='[S]earch by [G]rep'})
			map('n', '<leader>sd', builtin.diagnostics, {desc='[S]earch [D]iagnostics'})
			map('n', '<leader>sr', builtin.resume, {desc='[S]earch [R]esume'})
			map('n', '<leader>s.', builtin.oldfiles, {desc='[S]earch Recent Files ("." for repeat)'})
			map('n', '<leader><leader>', builtin.buffers, {desc='[ ] Find existing buffers'})

			-- Override default behaviour
			map('n', '<leader>/', function()
				builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10, previewer = false,
				})
			end, { desc = '[/] Fuzzy search in current buffer' })

			-- Pass additional options
			map('n', '<leader>s/', function()
				builtin.live_grep { 
					grep_open_files = true, 
					prompt_title = 'Live grep in open files'
				}
			end, { desc = '[S]earch [/] in open files' })

			-- Shortcut to Neovim configuration files
			vim.keymap.set('n', '<leader>sn', function()
				builtin.find_files {
					cwd = vim.fn.stdpath 'config'
				}
			end, { desc = '[S]earch [N]eovim files' })
		end,
	}, {
		'folke/lazydev.nvim', ft = 'lua',
		opts = { 
			library = {{ path='luvit-meta/library', words={'vim%.uv'} }}
		}
	}, {
		'Bilal2453/luvit-meta', lazy=true
	}, {
		-- Main LSP Configuration
		'neovim/nvim-lspconfig',
		dependencies = {
			{
				'williamboman/mason.nvim', config = true
			},
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',
			{
				-- opts={} same as calling require('fidget').setup({})
				'j-hui/fidget.nvim', opts={}
			},
			'hrsh7th/cmp-nvim-lsp',
		},
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
				callback = function(event)
					local map = function(keys, fn, desc)
						vim.keymap.set('n', keys, fn, {
				buffer = event.buf, 
				desc = 'LSP:' .. desc
			  })
					end

					map('gd', require('telescope.builtin').lsp_definitions, '[G]o to [D]efinition')
					map('gr', require('telescope.builtin').lsp_references, '[G]o to [R]eferences')
					map('gI', require('telescope.builtin').lsp.implementations, '[G]o to [I]mpl')
					map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
					map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
					map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
					map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
					map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
					map('gD', vim.lsp.buf.declaration, '[G]o to [D]eclaraction')

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						-- Highlight references under cursor after delay
						local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', {clear=false})
						vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
							buffer = event.buf,
							group  = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd('LspDetach', {
							group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds {
									group ='kickstart-lsp-highlight',
									buffer=event2.buf
								}
							end,
						})
					end

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHints) then
						map('<leader>th', function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {bufnr=event.buf})
						end, '[T]oggle Inlay [H]ints')
					end
				end,
			})
			-- LSP servers and clients need to communicate their supported capabilities
			-- When adding nvim-cmp, luasnip, etc. neovim now supports *more* capabilities
			-- Then we need to create new capabilities with nvim cmp and broadcast that to the servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
			-- Following servers will be automatically installed. See `:help lspconfig-all` for list of all pre-configured LSP
			local servers = {
					pyright = {}, 
					htmx = {}, 
					-- gopls = {}, jdtls = {}, cmake = {}, 
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = 'Replace',
							},
							diagnostics = { 
								disable = {'missing-fields'} 
							},
						},
					},
				},
			}
			-- Ensure above servers and tools are installed
			require('mason').setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				-- Lua code format
				'stylua', 
			})
			require('mason-tool-installer').setup { ensure_installed=ensure_installed }
			require('mason-lspconfig').setup {
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
						require('lspconfig')[server_name].setup(server)
					end,
				},
			}
		end,
	}, {
		-- Autoformat
		'stevearc/conform.nvim',
		event = {'BufWritePre'},
		cmd = {'ConformInfo'},
		key = {{
			'<leader>f', function()
				require('conform').format { async=true, lsp_fallback=true }
			end,
			mode = '',
			desc = '[F]ormat Buffer',
		},},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable format on save for some files
				local disable_filetypes = { c=true, cpp=true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = {"stylua"},
				-- Conform plugin can run multipe formatters sequentially
				-- python = {"isort", "black"},
				-- javascript = {"prittierd", "prettier", stop_after_first=true},
			},
		},
	}, {
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{ -- Snippet engine and associated nvim-cmp source
				'L3MON4D3/LuaSnip',
				build = (function()
					if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
						return
					end
					return 'make install_jsregexp'
				end)(),
				dependencies = {},
			},
			-- Remaining completion capabilities, they are split across multiple repos for maintenance
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
		},
		config = function()
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			luasnip.config.setup {}
			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = 'menu,menuone, noinsert' },
				
				-- For mapping reason, read :help ins-completion
				mapping = cmp.mapping.preset.insert {
					['<C-n>'] = cmp.mapping.select_next_item(), -- [n]ext item
					['<C-p>'] = cmp.mapping.select_prev_item(), -- [p]revious item

					['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll docs window
					['<C-f>'] = cmp.mapping.scroll_docs(4),

					-- Accept ([y]es) the completion
					['<C-y>'] = cmp.mapping.confirm { select=true },

					-- More traditional completion keymaps
					-- ['<CR>'] = cmp.mapping.confirm { select=true },
					-- ['<TAB>'] = cmp.mapping.select_next_item(),
					-- ['<S-TAB>'] = cmp.mapping.select_prev_item(),
					
					-- Manually trigger completion, should show automatically though
					['<C-Space>'] = cmp.mapping.complete {}, 

					-- Move to snippet expansion
					['<C-l>'] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, {'i', 's'}),

					['<C-h>'] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, {'i', 's'}),

					-- See for more Luasnip keymaps: github.com/L3MON4D3/LuaSnip
				},
				sources = {
					{
						name = 'lazydev', group_index = 0
					}, {
						name = 'nvim_lsp',
					}, {
						name = 'luasnip', 
					}, {
						name = 'path',
					},
				},
			}
		end,
	}, {
		-- Highlight To Do, Notes, etc. in comments
		'folke/todo-comments.nvim',
		event = 'VimEnter',
		dependencies = {
			'nvim-lua/plenary.nvim'
		},
		opts = {
			signs = false 
		}
	}, {
		-- Collection of small independent plugins
		'echasnovski/mini.nvim',
		config = function()
			-- Better Around/Inside textobjects
			-- va)  - [V]isually select [A]round [)]Paren
			-- yinq - [Y]ank [I]nside [N]ext [Q]uote
			-- ci'  - [C]hange [I]nside [']quote
			require('mini.ai').setup {
				n_lines = 500
			}

			-- Add/ Delete/ Replace surroundings
			-- saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- sd'   - [S]urround [D]elete [']Quotes
			-- sr)'  - [S]urround [R]eplace [)] [']
			require('mini.surround').setup()

			-- Status Line
			local statusline = require 'mini.statusline'
			statusline.setup {use_icons = vim.g.have_nerd_font}
		end,
	}, {
		-- Highlight, Edit, and Navigate code
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		opts = {
			ensure_installed = {
				'bash', 'c', 'lua', 'luadoc', 'markdown', 'html', 'vim', 
		  -- 'gopls'
			},
			auto_install = true,
			highlight = {
				enable = true,
				-- Some langs require diff indentations rules
				additional_vim_regex_highlighting = { 'ruby' },
			},
			indent = {
				enable = true,
				disable = { 'ruby' }
			},
		},
		config = function(_, opts)
			---@diagnostic disable-next-line: missing-fields
			require('nvim-treesitter.configs').setup(opts)
		end,
	},
})

