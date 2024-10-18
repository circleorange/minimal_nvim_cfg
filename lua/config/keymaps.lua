local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Exit insert mode
map("i", "jj", "<Esc>", opts)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Misc
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostic [Q]uick fix list" })
map("t", "jj", "<C-\\><C-n>", { desc = "Exit Terminal mode" })
map('n', '<leader>qq', '<CMD>qa<CR>', { desc = "Quit All" })

-- Window
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Telescope Plugin
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
map("n", "<leader>fb", ":Telescope buffers<CR>", opts)
map("n", "<leader>fh", ":Telescope help_tags<CR>", opts)
map("n", "<leader>sg", ":Telescope live_grep<CR>", opts)

-- Move Lines
map('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = "Move Down" })
map('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = "Move Up" })
map('i', '<A-j>', '<Esc><Cmd>m .+1<CR>==gi', { desc = "Move Down" })
map('i', '<A-k>', '<Esc><Cmd>m .-2<CR>==gi', { desc = "Move Up" })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = "Move Down" })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = "Move Up" })

-- Buffers
map('n', '<S-h>', '<Cmd>bprevious<CR>', { desc = "Previous Buffer" })
map('n', '<S-l>', '<Cmd>bnext<CR>', { desc = "Next Buffer" })
map('n', '<leader>bb', '<Cmd>e #<CR>', { desc = "Switch to Other Buffer" })

-- Highlight under cursor
map('n', '<leader>ui', vim.show_pos, { desc = "Inspect Position" })
map('n', '<leader>uI', '<CMD>InspectTree<CR>', { desc = "Inspect Tree" })

